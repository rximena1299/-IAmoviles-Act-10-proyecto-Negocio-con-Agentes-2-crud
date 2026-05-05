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

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          backgroundColor: Colors.white,

          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(25),
          ),

          title: Text(

            id == null
                ? 'Agregar usuario'
                : 'Editar usuario',

            style: const TextStyle(

              fontWeight: FontWeight.bold,
            ),
          ),

          content: SingleChildScrollView(

            child: Column(

              mainAxisSize: MainAxisSize.min,

              children: [

                campo(nombreController, 'Nombre'),

                const SizedBox(height: 15),

                campo(apellidoController, 'Apellido'),

                const SizedBox(height: 15),

                campo(correoController, 'Correo'),
              ],
            ),
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(context);
              },

              child: const Text('Cancelar'),
            ),

            ElevatedButton(

              style: ElevatedButton.styleFrom(

                backgroundColor: const Color(0xfffa233b),
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

                id == null
                    ? 'Agregar'
                    : 'Actualizar',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget campo(

    TextEditingController controller,
    String texto,

  ) {

    return TextField(

      controller: controller,

      decoration: InputDecoration(

        hintText: texto,

        filled: true,

        fillColor: Colors.grey.shade100,

        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xfff5f5f7),

      appBar: AppBar(

        backgroundColor: Colors.white,

        elevation: 0,

        title: const Text(

          'Usuarios',

          style: TextStyle(

            color: Colors.black,

            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: const Color(0xfffa233b),

        onPressed: () {

          mostrarFormulario();
        },

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
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

                var data =
                    usuario.data()
                        as Map<String, dynamic>;

                return Container(

                  margin: const EdgeInsets.only(bottom: 20),

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius: BorderRadius.circular(30),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.black12,

                        blurRadius: 10,

                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(

                        data['nombre'] ?? '',

                        style: const TextStyle(

                          fontSize: 24,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Apellido: ${data['apellido']}',
                      ),

                      Text(
                        'Correo: ${data['correo']}',
                      ),

                      const SizedBox(height: 20),

                      Row(

                        children: [

                          Expanded(

                            child: ElevatedButton.icon(

                              style: ElevatedButton.styleFrom(

                                backgroundColor:
                                    const Color(0xfffa233b),
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

                                backgroundColor: Colors.red,
                              ),

                              onPressed: () {

                                firestoreService
                                    .eliminarUsuario(
                                  usuario.id,
                                );
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