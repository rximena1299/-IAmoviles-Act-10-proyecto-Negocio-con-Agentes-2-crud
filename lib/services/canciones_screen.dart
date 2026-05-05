
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';

class CancionesScreen extends StatefulWidget {
  const CancionesScreen({super.key});

  @override
  State<CancionesScreen> createState() => _CancionesScreenState();
}

class _CancionesScreenState extends State<CancionesScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final tituloController = TextEditingController();
  final artistaController = TextEditingController();
  final albumController = TextEditingController();

  void limpiar() {
    tituloController.clear();
    artistaController.clear();
    albumController.clear();
  }

  void mostrarFormulario({
    String? id,
    String titulo = '',
    String artista = '',
    String album = '',
  }) {
    tituloController.text = titulo;
    artistaController.text = artista;
    albumController.text = album;

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
                id == null ? 'Agregar Canción' : 'Editar Canción',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              campo(tituloController, 'Título'),
              const SizedBox(height: 15),
              campo(artistaController, 'Artista'),
              const SizedBox(height: 15),
              campo(albumController, 'Álbum'),
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
                      await firestoreService.agregarCancion(
                        tituloController.text,
                        artistaController.text,
                        albumController.text,
                      );
                    } else {
                      await firestoreService.actualizarCancion(
                        id,
                        tituloController.text,
                        artistaController.text,
                        albumController.text,
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
          'Canciones',
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
          stream: firestoreService.obtenerCanciones(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var canciones = snapshot.data!.docs;

            return ListView.builder(
              itemCount: canciones.length,
              itemBuilder: (context, index) {
                var cancion = canciones[index];
                var data = cancion.data() as Map<String, dynamic>;

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xff1c1c1e),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['titulo'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Artista: ${data['artista']}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Álbum: ${data['album']}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xfffa233b),
                              ),
                              onPressed: () {
                                mostrarFormulario(
                                  id: cancion.id,
                                  titulo: data['titulo'],
                                  artista: data['artista'],
                                  album: data['album'],
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
                                firestoreService.eliminarCancion(cancion.id);
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
