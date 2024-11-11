import 'package:flutter/material.dart';
import 'package:Cashire/verfikasi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaftarScreen extends StatelessWidget {
  const DaftarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Judulformlogin(),
            _GambarLogo(),
            _FormLogin(),
          ],
        ),
      ),
    );
  }
}

class _FormLogin extends StatelessWidget {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey[200],
        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InputField(label: 'Masukkan Nama', controller: namaController),
              _InputField(label: 'Masukkan Email', controller: emailController),
              _InputField(
                  label: 'Masukkan Password',
                  obscure: true,
                  controller: emailController),
              _InputField(label: '+62', controller: teleponController),
              _Tombollogin(
                nama: namaController.text,
                email: emailController.text,
                pass: passController.text,
                telepon: teleponController.text,
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Dengan mendaftar, Anda sudah menyetujui\nSyarat ketentuan dan kebijakan privasi',
                  textAlign: TextAlign.center,
                ),
              ))
            ],
          ),
        ));
  }
}

class _Tombollogin extends StatelessWidget {
  final String nama;
  final String email;
  final String pass;
  final String telepon;

  const _Tombollogin({
    required this.nama,
    required this.email,
    required this.pass,
    required this.telepon,
  });

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nama', nama);
    await prefs.setString('email', email);
    await prefs.setString('telepon', telepon);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 181, 220, 238),
            ),
            onPressed: () async {
              await saveData();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VerfikasiScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 95),
              child: Text('Buat akun'),
            )),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final bool obscure;

  const _InputField(
      {super.key,
      this.label = '',
      this.obscure = false,
      required TextEditingController controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(15)),
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(10, 12, 10, 12)),
        ),
        SizedBox(height: 10),
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

class _Judulformlogin extends StatelessWidget {
  const _Judulformlogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Text(
            'DAFTAR',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )),
    );
  }
}
