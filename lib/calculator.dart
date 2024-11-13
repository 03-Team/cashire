import 'package:Cashire/kasbon.dart';
import 'package:Cashire/struk.dart';
import 'package:Cashire/transaksi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package

class Kalkulator extends StatefulWidget {
  
  final List<Map<String, dynamic>> selectedItems;
  final double totalAmount;

  Kalkulator({required this.totalAmount, required this.selectedItems});

  @override
  State<Kalkulator> createState() => _KalkulatorState();
}

class _KalkulatorState extends State<Kalkulator> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home: CalculatorPage(totalAmount: widget.totalAmount, selectedItems: widget.selectedItems),
    );
  }
}

class CalculatorPage extends StatefulWidget {

  final List<Map<String, dynamic>> selectedItems;
  final double totalAmount;

   CalculatorPage({required this.totalAmount, required this.selectedItems});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String displayValue = '0';
  int total = 0;

  Future<void> updateStock() async {
  var barangCollection = FirebaseFirestore.instance.collection('barang');

  for (var item in widget.selectedItems) {
    String kode = item['kode'];  // Kode barang
    int jumlahBeli = item['jumlah_beli'];  // Jumlah yang dibeli

    try {
      // Query untuk mencari barang berdasarkan kode
      var barangQuery = await barangCollection.where('kode', isEqualTo: kode).get();

      // Jika barang ditemukan
      if (barangQuery.docs.isNotEmpty) {
        // Ambil dokumen pertama (karena kode seharusnya unik)
        var barangDoc = barangQuery.docs.first;
        
        // Ambil stok barang yang ada
        int currentStock = barangDoc['stok'] ?? 0;  // Default ke 0 jika stok tidak ada
        int newStock = currentStock - jumlahBeli;  // Hitung stok baru

        // Cek apakah stok cukup
        if (newStock >= 0) {
          // Update stok di Firestore
          await barangCollection.doc(barangDoc.id).update({
            'stok': newStock,
          });
          print('Updated stock for $kode: $newStock remaining.');
        } else {
          // Jika stok tidak cukup, tampilkan pesan error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Stok tidak cukup untuk ${item['nama']}')),
          );
        }
      } else {
        // Jika barang dengan kode tidak ditemukan
        print('Barang dengan kode $kode tidak ditemukan.');
      }
    } catch (e) {
      // Jika terjadi error saat query atau update
      print('Error updating stock for $kode: $e');
    }
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
          'Rp ${widget.totalAmount.toStringAsFixed(0)}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (c) => TransaksiApps()));
            }),
        actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
            icon: const Icon(Icons.file_copy_sharp),
            onPressed: () async {
              await updateStock();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (c) => HutangPage()
                ),
              );
            },
          ),
        ),
          IconButton(
          icon: const Icon(Icons.check_box),
          onPressed: () async {
            double cashAmount = total.toDouble(); // Mengambil total
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Cash amount: Rp ${formatCurrency(cashAmount.toInt())}')),
            );

            // Simpan data struk ke Firebase menggunakan selectedItems yang sudah ada
            await saveStrukToFirebase(widget.totalAmount, cashAmount, widget.selectedItems); // Ganti dengan widget.selectedItems
            await updateStock();
            // Arahkan ke halaman Struk dengan selectedItems yang benar
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (c) => Struk(
                  totalAmount: widget.totalAmount,
                  cash: cashAmount,
                  selectedItems: widget.selectedItems, // Ganti dengan widget.selectedItems
                ),
              ),
            );
          },
        ),
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
          // Grid tombol angka
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

  // Fungsi untuk membuat tombol angka dengan warna berbeda
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

  // Fungsi untuk membuat tombol reset dengan warna yang berbeda
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
