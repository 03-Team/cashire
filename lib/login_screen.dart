import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            _JudulFormLogin(),
            _GambarLogo(),
            _FormLogin(),
          ],
        ),
      ),
    );
  }
}

class _FormLogin extends StatefulWidget {
  const _FormLogin({super.key});

  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<_FormLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InputField(label: 'Masukkan Email', controller: emailController),
            _InputField(
              label: 'Masukkan Password',
              obscure: true,
              controller: passwordController,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Tambahkan logika untuk "Lupa Password?" di sini
              },
              child: const Text(
                'Lupa Password?',
                style: TextStyle(color: Colors.black),
              ),
            ),
            _TombolLogin(
              emailController: emailController,
              passwordController: passwordController,
            )
          ],
        ),
      ),
    );
  }
}

class _TombolLogin extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _TombolLogin({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 181, 220, 238),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          String email = emailController.text;
          String password = passwordController.text;

          // Tambahkan logika autentikasi sederhana
          if (await _authenticate(email, password)) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('userEmail', email);
            await prefs.setBool('isLoggedIn', true);

            // Navigasi ke Dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardApps()),
            );
          } else {
            // Tampilkan pesan error jika autentikasi gagal
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login gagal, periksa kembali email dan password')),
            );
          }
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 120),
          child: Text('Masuk'),
        ),
      ),
    );
  }

  Future<bool> _authenticate(String email, String password) async {
    // Logika autentikasi sederhana, bisa diganti dengan yang lebih kompleks
    return email == 'user@example.com' && password == 'password123'; // Contoh kondisi
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final bool obscure;
  final TextEditingController controller;

  const _InputField({
    super.key,
    required this.label,
    this.obscure = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
            ),
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            contentPadding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _GambarLogo extends StatelessWidget {
  const _GambarLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Image.asset(
        'assets/cashire.png',
        width: 120,
      ),
    );
  }
}

class _JudulFormLogin extends StatelessWidget {
  const _JudulFormLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: const Text(
          'LOGIN',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
