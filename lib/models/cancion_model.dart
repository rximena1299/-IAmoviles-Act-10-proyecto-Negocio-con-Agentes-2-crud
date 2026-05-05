class CancionModel {

  String? id;
  String titulo;
  String artista;
  String album;

  CancionModel({
    this.id,
    required this.titulo,
    required this.artista,
    required this.album,
  });

  Map<String, dynamic> toMap() {

    return {
      'titulo': titulo,
      'artista': artista,
      'album': album,
    };
  }

  factory CancionModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {

    return CancionModel(
      id: documentId,
      titulo: map['titulo'] ?? '',
      artista: map['artista'] ?? '',
      album: map['album'] ?? '',
    );
  }
}