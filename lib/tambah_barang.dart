import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TambahBarangPage extends StatefulWidget {
  @override
  _TambahBarangPageState createState() => _TambahBarangPageState();
}

class _TambahBarangPageState extends State<TambahBarangPage> {
  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _hargaDasarController = TextEditingController();
  final TextEditingController _hargaJualController = TextEditingController();

  String? _selectedKategori;

  @override
  void dispose() {
    _namaBarangController.dispose();
    _stokController.dispose();
    _kodeController.dispose();
    _hargaDasarController.dispose();
    _hargaJualController.dispose();
    super.dispose();
  }

  Future<void> _tambahBarang() async {
    if (_namaBarangController.text.isNotEmpty &&
        _stokController.text.isNotEmpty &&
        _kodeController.text.isNotEmpty &&
        _hargaJualController.text.isNotEmpty &&
        _selectedKategori != null) {
      await FirebaseFirestore.instance.collection('barang').add({
        'nama': _namaBarangController.text,
        'stok': int.tryParse(_stokController.text) ?? 0,
        'kode': _kodeController.text,
        'harga_dasar': int.tryParse(_hargaDasarController.text) ?? 0,
        'harga_jual': int.tryParse(_hargaJualController.text) ?? 0,
        'kategori': _selectedKategori,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 217, 231),
        title: Text(
          'Tambah Barang',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaBarangController,
              decoration: const InputDecoration(labelText: 'Nama Barang'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _stokController,
              decoration: const InputDecoration(labelText: 'Stok'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _kodeController,
              decoration: const InputDecoration(labelText: 'Kode'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hargaDasarController,
                    decoration: const InputDecoration(labelText: 'Harga Dasar'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _hargaJualController,
                    decoration: const InputDecoration(labelText: 'Harga Jual'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                var kategoriItems = snapshot.data!.docs.map((doc) {
                  return DropdownMenuItem(
                    value: doc[
                        'name'], // Pastikan 'nama' adalah field yang benar di dalam dokumen
                    child: Text(doc['name']),
                  );
                }).toList();

                return DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items: kategoriItems,
                  onChanged: (value) {
                    setState(() {
                      _selectedKategori = value as String?;
                    });
                  },
                  value: _selectedKategori,
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _tambahBarang,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Color.fromARGB(255, 199, 217, 231),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Text(
                  'Simpan',
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
