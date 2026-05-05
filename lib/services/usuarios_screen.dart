
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final correoController = TextEditingController();

  void limpiar() {
    nombreController.clear();
    apellidoController.clear();
    correoController.clear();
  }

  void mostrarFormulario({
    String? id,
    String nombre = '',
    String apellido = '',
    String correo = '',
  }) {
    nombreController.text = nombre;
    apellidoController.text = apellido;
    correoController.text = correo;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xff1c1c1e),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                id == null ? 'Agregar Usuario' : 'Editar Usuario',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              campo(nombreController, 'Nombre'),
              const SizedBox(height: 15),
              campo(apellidoController, 'Apellido'),
              const SizedBox(height: 15),
              campo(correoController, 'Correo'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xfffa233b),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    if (id == null) {
                      await firestoreService.agregarUsuario(
                        nombreController.text,
                        apellidoController.text,
                        correoController.text,
                      );
                    } else {
                      await firestoreService.actualizarUsuario(
                        id,
                        nombreController.text,
                        apellidoController.text,
                        correoController.text,
                      );
                    }

                    limpiar();

                    Navigator.pop(context);
                  },
                  child: Text(
                    id == null ? 'Agregar' : 'Actualizar',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget campo(TextEditingController controller, String texto) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: texto,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Usuarios',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xfffa233b),
        onPressed: () {
          mostrarFormulario();
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.obtenerUsuarios(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var usuarios = snapshot.data!.docs;

            return ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                var usuario = usuarios[index];
                var data = usuario.data() as Map<String, dynamic>;

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xfffa233b),
                        Color(0xffb3122f),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['nombre'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Apellido: ${data['apellido']}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Correo: ${data['correo']}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                              ),
                              onPressed: () {
                                mostrarFormulario(
                                  id: usuario.id,
                                  nombre: data['nombre'],
                                  apellido: data['apellido'],
                                  correo: data['correo'],
                                );
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Editar'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                firestoreService.eliminarUsuario(usuario.id);
                              },
                              icon: const Icon(Icons.delete),
                              label: const Text('Eliminar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
