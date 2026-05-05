import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final correoController = TextEditingController();
  final passwordController = TextEditingController();

  Future iniciarSesion() async {

    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(

        email: correoController.text.trim(),

        password: passwordController.text.trim(),
      );

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) => const HomeScreen(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(
            e.message ?? 'Error',
          ),
        ),
      );
    }
  }

  Future registrar() async {

    try {

      await FirebaseAuth.instance.createUserWithEmailAndPassword(

        email: correoController.text.trim(),

        password: passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(
            'Cuenta creada correctamente',
          ),
        ),
      );

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(
            e.message ?? 'Error',
          ),
        ),
      );
    }
  }

  Widget campo(

    TextEditingController controller,
    String texto, {

    bool ocultar = false,

  }) {

    return TextField(

      controller: controller,

      obscureText: ocultar,

      decoration: InputDecoration(

        hintText: texto,

        filled: true,

        fillColor: Colors.white,

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

      backgroundColor: const Color(0xfff5f5f7),

      body: Center(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.all(30),

            child: Container(

              padding: const EdgeInsets.all(30),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius: BorderRadius.circular(35),

                boxShadow: [

                  BoxShadow(

                    color: Colors.black12,

                    blurRadius: 20,
                  ),
                ],
              ),

              child: Column(

                mainAxisSize: MainAxisSize.min,

                children: [

                  const Icon(

                    Icons.music_note,

                    size: 80,

                    color: Color(0xfffa233b),
                  ),

                  const SizedBox(height: 20),

                  const Text(

                    'Apple Music',

                    style: TextStyle(

                      fontSize: 32,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(

                    'Inicia sesión para continuar',
                  ),

                  const SizedBox(height: 30),

                  campo(
                    correoController,
                    'Correo',
                  ),

                  const SizedBox(height: 20),

                  campo(

                    passwordController,
                    'Contraseña',

                    ocultar: true,
                  ),

                  const SizedBox(height: 30),

                  SizedBox(

                    width: double.infinity,

                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(

                        backgroundColor:
                            const Color(0xfffa233b),

                        padding: const EdgeInsets.symmetric(

                          vertical: 18,
                        ),

                        shape: RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                      ),

                      onPressed: iniciarSesion,

                      child: const Text(

                        'Iniciar sesión',

                        style: TextStyle(

                          color: Colors.white,

                          fontSize: 16,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextButton(

                    onPressed: registrar,

                    child: const Text(

                      'Crear cuenta',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}