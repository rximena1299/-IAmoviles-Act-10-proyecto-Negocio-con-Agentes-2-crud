class UserModel {

  String? id;
  String nombre;
  String apellido;
  String correo;

  UserModel({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
  });

  // Convertir objeto a Map para Firebase
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
    };
  }

  // Convertir datos de Firebase a objeto
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {

    return UserModel(
      id: documentId,
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      correo: map['correo'] ?? '',
    );
  }
}