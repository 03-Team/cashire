import 'package:Cashire/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Struk extends StatelessWidget {
  final double totalAmount; // Total dari transaksi
  final double cash; // Jumlah uang yang diberikan
  final List<Map<String, dynamic>> selectedItems; // Daftar barang yang dibeli

  Struk({required this.totalAmount, required this.cash, required this.selectedItems});

  String getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String getCurrentTime() {
    return DateFormat('HH:mm:ss').format(DateTime.now());
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // Perhitungan kembalian
    final double change = cash - totalAmount;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 217, 231),
        title: Text(
          'Cetak',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Apakah Anda akan mendownload file ini?"),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (c) => DashboardApps()));
                        },
                        child: Text("Ya"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Apakah Anda akan membagi file ini?"),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Ya"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              print("Pengaturan ditekan");
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 250,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nama Toko',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 4),
              Text(
                'Alamat Toko\nNomor Transaksi',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              Divider(color: Colors.black),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getCurrentDate()), // Tanggal sekarang
                      Text(getCurrentTime()), // Jam sekarang
                      Text('No.1'), // Nomor transaksi urut
                    ],
                  ),
                  Text('Nama Owner'),
                ],
              ),
              Divider(color: Colors.black),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menampilkan setiap item yang dibeli
                  ...selectedItems.map((item) {
                    double subtotal = item['harga_jual'] * item['jumlah_beli'];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item['nama']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item['jumlah_beli']} × ${formatCurrency(item['harga_jual'])}'), // Jumlah beli dan harga
                            Text(formatCurrency(subtotal)), // Total harga item
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              Divider(color: Colors.black),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total'),
                  Text(formatCurrency(totalAmount)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bayar (Cash)'),
                  Text(formatCurrency(cash)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kembali'),
                  Text(formatCurrency(change)),
                ],
              ),
              SizedBox(height: 12),
              Text('Terima Kasih', style: TextStyle(fontSize: 16)),
              SizedBox(height: 12),
              Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Center(child: Text('Gambar')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to save the struk data to Firestore
Future<void> saveStrukToFirebase(double totalAmount, double cash, List<Map<String, dynamic>> selectedItems) async {
  final strukData = {
    'totalAmount': totalAmount,
    'cash': cash,
    'selectedItems': selectedItems,
    'timestamp': FieldValue.serverTimestamp(),
  };

  await FirebaseFirestore.instance.collection('struk').add(strukData);
}

void main() {
  runApp(MaterialApp(
    home: Struk(
      totalAmount: 12000, // Example total
      cash: 15000, // Example cash
      selectedItems: [
        {'nama': 'Barang 1', 'kode': 'B001', 'harga_jual': 6000, 'jumlah_beli': 2},
        // Tambahkan item lainnya jika diperlukan
        {'nama': 'Barang 2', 'kode': 'B002', 'harga_jual': 8000, 'jumlah_beli': 1},
      ],
    ),
  ));
}
