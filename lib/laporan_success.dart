import 'package:Cashire/lap_bulan.dart';
import 'package:Cashire/lap_hari.dart';
import 'package:Cashire/lap_tahun.dart';
import 'package:flutter/material.dart';
import 'package:Cashire/dashboard.dart';

class LaporanSuccess extends StatelessWidget {
  const LaporanSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 217, 231),
        title: Text(
          "Laporan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (c) => DashboardApps()));
            }),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.article),
            title: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (c) => LapHari()));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 85),
                child: Text("Laporan Transaksi Hari Ini",
                    style: TextStyle(color: Colors.black, fontSize: 17)),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.article),
            title: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (c) => LapBulan(11, 2024)));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 75),
                child: Text("Laporan Transaksi Bulan Ini",
                    style: TextStyle(color: Colors.black, fontSize: 17)),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.article),
            title: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (c) => LapTahun(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 70),
                child: Text(
                  "Laporan Transaksi Tahun Ini",
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
