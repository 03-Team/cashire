import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cashire/tambah_barang.dart';

void main() {
  runApp(MaterialApp(
    home: BarangKosong(),
  ));
}

class BarangKosong extends StatefulWidget {
  @override
  _BarangKosongState createState() => _BarangKosongState();

  static map(Map<String, dynamic> Function(dynamic item) param0) {}
}

class _BarangKosongState extends State<BarangKosong> {
  final CollectionReference _itemsCollection =
  FirebaseFirestore.instance.collection('barang');
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 199, 217, 231),
        title:
            const Text('Barang', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Cari nama atau kode barang',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('barang').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) return emptyState();

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    var barang = doc.data() as Map<String, dynamic>;
                    final item = Item.fromDocument(
                        doc); // Menggunakan model Item untuk setiap data
                    return GestureDetector(
                      onTap: () => _showEditItemDialog(context, item),
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(barang['nama'] ?? 'Tidak ada nama',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text('Stok: ${barang['stok'] ?? '0'}',
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(barang['kode'] ?? 'Tidak ada kode',
                                  style: const TextStyle(fontSize: 14)),
                              Text(
                                  'Rp ${barang['harga_jual']?.toString() ?? '0'}',
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahBarangPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.warning, size: 50, color: Colors.orange),
          SizedBox(height: 10),
          Text('Database kosong, silakan tambah barang',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

void _showEditItemDialog(BuildContext context, Item item) {
  TextEditingController namaBarangController = TextEditingController(text: item.nama);
  TextEditingController stokController = TextEditingController(text: item.stok.toString());
  TextEditingController kodeController = TextEditingController(text: item.kode);
  TextEditingController hargaJualController = TextEditingController(text: item.hargaJual.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Edit Barang'),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
               onPressed: () async {
                // Menampilkan dialog konfirmasi hapus
                bool? confirmDelete = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Konfirmasi Hapus"),
                      content:
                          Text("Apakah Anda yakin ingin menghapus data ini?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Tidak"),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (c) =>
                                        BarangKosong())); // Menutup dialog dan tidak menghapus
                          },
                        ),
                        TextButton(
                          child: Text("Hapus"),
                          onPressed: () {
                            Navigator.of(context).pop(
                                true); // Menutup dialog dan mengonfirmasi hapus
                          },
                        ),
                      ],
                    );
                  },
                );

                // Jika pengguna mengonfirmasi hapus
                if (confirmDelete == true) {
                  await FirebaseFirestore.instance
                      .collection('barang')
                      .doc(item.id)
                      .delete();
                }
              },
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaBarangController,
              decoration: const InputDecoration(
                labelText: 'Nama Barang',
              ),
            ),
            TextField(
              controller: stokController,
              decoration: const InputDecoration(
                labelText: 'Stok',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: kodeController,
              decoration: const InputDecoration(
                labelText: 'Kode',
              ),
            ),
            TextField(
              controller: hargaJualController,
              decoration: const InputDecoration(
                labelText: 'Harga Jual',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('BATAL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 181, 220, 238),
                ),
            onPressed: () {
              _updateItem(
                item.id,
                namaBarangController.text,
                int.parse(stokController.text),
                kodeController.text,
                int.parse(hargaJualController.text),
              );
              Navigator.pop(context);
            },
            child: const Text('SIMPAN'),
          ),
        ],
      );
    },
  );
}

  void _deleteItem(String itemId) {
    _itemsCollection.doc(itemId).delete();
  }

  void _updateItem(
      String itemId, String nama, int stok, String kode, int hargaJual) {
    _itemsCollection.doc(itemId).update({
      'nama': nama,
      'stok': stok,
      'kode': kode,
      'harga_jual': hargaJual,
    });
  }
}

class Item {
  final String id;
  final String nama;
  final int stok;
  final String kode;
  final int hargaJual;

  Item({
    required this.id,
    required this.nama,
    required this.stok,
    required this.kode,
    required this.hargaJual,
  });

  factory Item.fromDocument(DocumentSnapshot doc) {
    return Item(
      id: doc.id,
      nama: doc['nama'] ?? 'No Name',
      stok: doc['stok'] ?? 0,
      kode: doc['kode'] ?? 'Unknown',
      hargaJual: doc['harga_jual'] ?? 0,
    );
  }
}
