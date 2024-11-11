import 'package:Cashire/barang.dart';
import 'package:Cashire/manajemen_stok.dart';
import 'package:Cashire/kategori_barang.dart';
import 'package:flutter/material.dart';
import 'package:Cashire/dashboard.dart';

class ManajemenApps extends StatelessWidget {
  const ManajemenApps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 217, 231),
        title: Text('Manajemen',
        style: TextStyle(fontWeight: FontWeight.bold),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (c) => DashboardApps()
                )
              );
            }),
          centerTitle: true,
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.category, color: Colors.orange),
              title: Text('Kategori Barang'),
              onTap: () {
                // Navigate to Kategori Barang page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KategoriBarangPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.inventory, color: Colors.green),
              title: Text('Barang'),
              onTap: () {
                // Navigate to Barang page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BarangKosong()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.storage, color: Colors.blue),
              title: Text('Manajemen Stok'),
              onTap: () {
                // Navigate to Stok Management page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
