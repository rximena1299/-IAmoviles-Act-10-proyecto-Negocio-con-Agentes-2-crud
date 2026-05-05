import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  final CollectionReference usuarios =
      FirebaseFirestore.instance.collection('usuarios');

  final CollectionReference canciones =
      FirebaseFirestore.instance.collection('canciones');

  Future agregarUsuario(
    String nombre,
    String apellido,
    String correo,
  ) async {

    await usuarios.add({

      'nombre': nombre,

      'apellido': apellido,

      'correo': correo,
    });
  }

  Stream<QuerySnapshot> obtenerUsuarios() {

    return usuarios.snapshots();
  }

  Future eliminarUsuario(String id) async {

    await usuarios.doc(id).delete();
  }

  Future actualizarUsuario(

    String id,

    String nombre,

    String apellido,

    String correo,

  ) async {

    await usuarios.doc(id).update({

      'nombre': nombre,

      'apellido': apellido,

      'correo': correo,
    });
  }

  Future agregarCancion(

    String titulo,

    String artista,

    String album,

  ) async {

    await canciones.add({

      'titulo': titulo,

      'artista': artista,

      'album': album,
    });
  }

  Stream<QuerySnapshot> obtenerCanciones() {

    return canciones.snapshots();
  }

  Future eliminarCancion(String id) async {

    await canciones.doc(id).delete();
  }

  Future actualizarCancion(

    String id,

    String titulo,

    String artista,

    String album,

  ) async {

    await canciones.doc(id).update({

      'titulo': titulo,

      'artista': artista,

      'album': album,
    });
  }
}