import 'package:Cashire/kasbon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Kalkulatorkasbon extends StatelessWidget {
  final int totalKasbon; 
  // Tambahkan parameter ini

  Kalkulatorkasbon({required this.totalKasbon}); // Ubah konstruktor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(
        totalKasbon: totalKasbon,
        kasbonId: 'W9C3kLkDLGTywkkWCJbu',
      ), // Kirim totalKasbon ke CalculatorPage
    );
  }
}

class CalculatorPage extends StatefulWidget {
  final int totalKasbon;
  final String kasbonId; // Tambahkan parameter ini

  CalculatorPage(
      {required this.totalKasbon, required this.kasbonId}); // Ubah konstruktor

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String displayValue = '0';
  int total = 0;

  Future<void> markAsPaid() async {
    try {
      var kasbonCollection = FirebaseFirestore.instance.collection('kasbon');

      // Menggunakan ID kasbon yang diteruskan ke CalculatorPage
      await kasbonCollection.doc(widget.kasbonId).update({
        'status': 'Lunas',
        'keterangan': 'Lunas',
      });

      print(
          "Kasbon dengan ID ${widget.kasbonId} telah ditandai sebagai lunas.");
    } catch (e) {
      print("Gagal memperbarui kasbon dengan ID ${widget.kasbonId}: $e");
    }
  }

  // Fungsi untuk menangani input tombol angka
  void onPressedNumber(int number) {
    setState(() {
      displayValue = displayValue == '0' ? '$number' : displayValue + '$number';
      total = int.tryParse(displayValue) ?? 0;
    });
  }

  // Fungsi untuk mereset (clear semua angka)
  void reset() {
    setState(() {
      displayValue = '0';
      total = 0;
    });
  }

  // Fungsi untuk menghapus satu angka (backspace)
  void backspace() {
    setState(() {
      if (displayValue.length > 1) {
        displayValue = displayValue.substring(0, displayValue.length - 1);
      } else {
        displayValue = '0';
      }
      total = int.tryParse(displayValue) ?? 0;
    });
  }

  // Format angka menggunakan NumberFormat dari intl
  String formatCurrency(int number) {
    final formatter = NumberFormat('#,##0', 'en_US'); // Format ribuan
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 217, 231),
        title: Text(
          'Rp. ${formatCurrency(widget.totalKasbon)}', // Gunakan totalKasbon yang dikirim
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (c) => KasbonApps()));
            }),
        actions: [
          IconButton(
            icon: Icon(Icons.check_box),
            onPressed: () async {
              await markAsPaid();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (c) => KasbonApps()),
              );
            },
          )
        ],
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Display untuk menampilkan hasil angka yang ditekan
          Container(
            alignment: Alignment.center, // Menempatkan tulisan di tengah
            padding: EdgeInsets.all(24),
            child: Text(
              'Rp ${formatCurrency(total)}', // Memformat total ke format Rp
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3, // Grid 3 kolom
              mainAxisSpacing: 10, // Spasi antar baris
              crossAxisSpacing: 15, // Spasi antar kolom
              padding: EdgeInsets.all(50),
              children: [
                for (int i = 1; i <= 9; i++) buildNumberButton(i),
                buildNumberButton(0),
                buildResetButton(),
                buildBackspaceButton(), // Tambahkan tombol backspace di grid
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNumberButton(int number) {
    return ElevatedButton(
      onPressed: () => onPressedNumber(number),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ), // Warna yang berbeda
      ),
      child: Text(
        '$number',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }

  Widget buildResetButton() {
    return ElevatedButton(
      onPressed: reset,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: Colors.green, // Warna untuk tombol reset
      ),
      child: Text(
        'C',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  // Fungsi untuk membuat tombol hapus satu angka (backspace)
  Widget buildBackspaceButton() {
    return ElevatedButton(
      onPressed: backspace,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: Colors.redAccent, // Warna untuk tombol hapus angka
      ),
      child: Icon(
        Icons.backspace, // Ikon backspace
        size: 24,
        color: Colors.white,
      ),
    );
  }
}
