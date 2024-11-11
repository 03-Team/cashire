import 'package:Cashire/model/produk_model.dart';
import 'package:Cashire/service/produk_service.dart';
import 'package:flutter/material.dart';
import 'package:Cashire/daftar_screen.dart';
import 'package:Cashire/login_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 199, 217, 231),
        body: Column(
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text(
                'WELCOME\nAPLIKASI KASIR',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Image.asset(
                'assets/chat.png',
                width: 170,
              ),
            ),
            TextButton(
                onPressed: () {
                  ProdukService().tambahProduk(Produk(
                      id: "1",
                      nama: "PhotoCard Xu Minghao Seventeen",
                      deskripsi: "Terbaru Album Love, Money, Fame",
                      harga: 350000,
                      gambarUrl:"manage.png" ));
                },
                child: Text("Tambah Produk")),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Card(
                color: Color.fromARGB(255, 199, 217, 231),
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (c) => LoginScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: Text('MASUK'),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => DaftarScreen()));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 100),
                            child: Text('DAFTAR'),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
