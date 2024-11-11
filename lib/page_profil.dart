import 'package:flutter/material.dart';
import 'package:Cashire/dashboard.dart';
import 'package:Cashire/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfil extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: profil(
      ),
    );
  }
}

class profil extends StatefulWidget {
  @override
  State<profil> createState() => _profilState();
}

class _profilState extends State<profil> {
  String userName = '';
  String storeName = 'Cashire';
  @override
  void initState() {
  super.initState();
    _loadUserData();
  }
    Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('userEmail');
    
  if (email != null && email.isNotEmpty) {
    setState(() {
      userName = email; // Set userName to the full email
    });
  }
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 217, 231),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (c) => DashboardApps()),
            );
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              Center(
                child: Icon(
                  Icons.account_circle,
                  size: 60.0,
                ),
              ),
              Text(
                "Profil",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 5),
              SizedBox(height: 5),
              TextField(
                decoration:
                    InputDecoration(
                      labelText: userName,
                      hintText: "Masukkan Email"),
              ),
              SizedBox(height: 5),
              TextField(
                decoration:
                    InputDecoration(
                      labelText: "0812xxxxxxx",
                      hintText: "Masukkan Telepon"),
              ),
              SizedBox(height: 5),
              TextField(
                decoration:
                    InputDecoration(
                      labelText: "Kartasura,Sukoharjo",
                      hintText: "Masukkan Alamat"),
              ),
              SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Apakah Anda akan menyimpan data ini ?"),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Simpan"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 230),
                  child: Text("Simpan"),
                ),
              ),
              SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 181, 220, 238),
              ),
              onPressed: () async {
                // Hapus status login dari SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('isLoggedIn'); // Atau gunakan `prefs.clear()` untuk menghapus semua data.

                // Arahkan pengguna kembali ke halaman login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "LOGOUT",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
