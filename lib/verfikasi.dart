import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:Cashire/data_toko.dart';
import 'package:shared_preferences/shared_preferences.dart';

  class VerfikasiScreen extends StatelessWidget {

  Future<Map<String, String>> getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String nama = prefs.getString('nama') ?? 'Nama tidak ditemukan';
  String email = prefs.getString('email') ?? 'Email tidak ditemukan';
  String telepon = prefs.getString('telepon') ?? '+62';
  
  return {
    'nama': nama,
    'email': email,
    'telepon': telepon,
  };
}

  const VerfikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text('VERIFIKASI',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 60, top: 20),
              child: Text('Demi keamanan akun dan informasi terkait, silahkan\nmasukkan kode OTP yang dikirim melalui whatsapp ke nomor anda (08xxxxxxxxxxx)',
              style: TextStyle(fontSize: 15), textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50, top: 10 ),
              child: Text('Masukkan 6 digit OTP\nKode OTP yang dikirim valid dalam 02:00',
              style: TextStyle(fontSize: 15), textAlign: TextAlign.center,
            ),
           ),
            Padding(
              padding: const EdgeInsets.only(bottom: 150),
              child: OtpTextField(
                numberOfFields: 5,
                borderColor: Color(0xFF512DA8),

                showFieldAsBox: true, 

                onCodeChanged: (String code) {
        
                },

                onSubmit: (String verificationCode){
                  showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("Verification Code"),
                          content: Text('Code entered is $verificationCode'),
                        );
                      });
                }, // end onSubmit
                ),
                ),

              SizedBox(height: 20),
              ElevatedButton(
              onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoreForm(
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Color.fromARGB(255, 181, 220, 238),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Text(
                      'VERIFIKASI',
                      style: TextStyle(fontSize: 15),
                      ),
                  ),
             ),
          ],
        ),
      ),
    );
  }
}

