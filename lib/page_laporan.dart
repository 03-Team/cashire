import 'package:flutter/material.dart';

class laporan extends StatelessWidget {
  const laporan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LAPORAN",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.article),
            title: Text("Laporan Transaksi Hari Ini"),
            onTap: () {
              _showWarningDialog(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.article),
            title: Text("Laporan Transaksi Bulan Ini"),
            onTap: () {
              _showWarningDialog(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.article),
            title: Text("Laporan Transaksi Tahun Ini"),
            onTap: () {
              _showWarningDialog(context);
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Peringatan",
            style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          ),
          content: Text(
              "Belum dapat melihat laporan. Lakukan transaksi terlebih dahulu"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          ),
            ),
          ],
        );
      },
    );
  }
}
