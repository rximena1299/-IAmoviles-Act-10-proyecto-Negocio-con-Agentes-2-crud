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
                ? 'Agregar canción'
                : 'Editar canción',

            style: const TextStyle(

              fontWeight: FontWeight.bold,
            ),
          ),

          content: SingleChildScrollView(

            child: Column(

              mainAxisSize: MainAxisSize.min,

              children: [

                campo(tituloController, 'Título'),

                const SizedBox(height: 15),

                campo(artistaController, 'Artista'),

                const SizedBox(height: 15),

                campo(albumController, 'Álbum'),
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

          'Canciones',

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

                var data =
                    cancion.data()
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

                        data['titulo'] ?? '',

                        style: const TextStyle(

                          fontSize: 24,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Artista: ${data['artista']}',
                      ),

                      Text(
                        'Álbum: ${data['album']}',
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

                                firestoreService
                                    .eliminarCancion(
                                  cancion.id,
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