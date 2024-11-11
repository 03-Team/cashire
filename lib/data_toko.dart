import 'package:flutter/material.dart';
import 'package:Cashire/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StoreForm(),
    );
  }
}

class StoreForm extends StatefulWidget {
  
  @override
  _StoreFormState createState() => _StoreFormState();
}

class _StoreFormState extends State<StoreForm> {
  Future<void> saveData(
      String alamat, String nama, String email, String telepon) async {
    // Implementasi penyimpanan alamat, misalnya menggunakan SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('alamat', alamat);

  }

  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final teleponController = TextEditingController();
  final alamatController = TextEditingController();

  @override
  void dispose() {
    // Pastikan untuk membersihkan controller setelah tidak digunakan
    namaController.dispose();
    emailController.dispose();
    teleponController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'DATA TOKO',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(45.0),
          child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Masukkan Jenis Usaha',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Masukkan Nama Toko',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Provinsi',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Kabupaten',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Kecamatan',
                  ),
                ),
                TextFormField(
                  controller: alamatController, // Tambahkan ini
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 181, 220, 238),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("KONFIRMASI"),
                            content: Text(
                                "Apakah Anda sudah mengisi data dengan benar ?"),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 181, 220, 238),
                                ),
                                onPressed: () async {
                                  await saveData(
                                    namaController.text,
                                    emailController.text,
                                    teleponController.text,
                                    alamatController.text);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DashboardApps()),
                                  );
                                },
                                child: Text(
                                  "SUDAH",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("BELUM",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 95),
                      child: Text("SIMPAN"),
                    ),
                  ),
                )
              ])),
        ));
  }
}
