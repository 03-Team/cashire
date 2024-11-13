import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(StockApp());

class StockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StockPage(),
    );
  }
}

class StockPage extends StatefulWidget {
  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final CollectionReference _itemsCollection = FirebaseFirestore.instance.collection('barang');
  final CollectionReference _categoriesCollection = FirebaseFirestore.instance.collection('categories');

  String _selectedCategory = 'semua';
  List<String> _categories = ['semua'];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() async {
    QuerySnapshot querySnapshot = await _categoriesCollection.get();
    List<String> categories = ['semua'];
    for (var doc in querySnapshot.docs) {
      categories.add(doc['name']);
    }
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 217, 231),
        title: Text(
          'Manajemen Stok',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 250),
            child: DropdownButton<String>(
              value: _selectedCategory,
              icon: Icon(Icons.arrow_drop_down),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: _categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _selectedCategory == 'semua'
                  ? _itemsCollection.snapshots()
                  : _itemsCollection.where('kategori', isEqualTo: _selectedCategory).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var items = snapshot.data!.docs.map((doc) => Item.fromDocument(doc)).toList();

                if (items.isEmpty) {
                  return Center(child: Text("Tidak Ada Barang Di dalam Kategori Ini"));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    var barang = doc.data() as Map<String, dynamic>;
                    final item = Item.fromDocument(doc); // Menggunakan model Item untuk setiap data

                    return GestureDetector(
                      onTap: () => _showEditItemDialog(context, item),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(barang['nama'] ?? 'Tidak ada nama',
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                              Text('Stok: ${barang['stok'] ?? '0'}',
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(barang['kode'] ?? 'Tidak ada kode',
                                  style: const TextStyle(fontSize: 14)),
                              Text('Rp ${barang['harga_jual']?.toString() ?? '0'}',
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
          title: Text('Edit Barang'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaBarangController,
                decoration: InputDecoration(
                  labelText: 'Nama Barang',
                ),
              ),
              TextField(
                controller: stokController,
                decoration: InputDecoration(
                  labelText: 'Stok',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: kodeController,
                decoration: InputDecoration(
                  labelText: 'Kode',
                ),
              ),
              TextField(
                controller: hargaJualController,
                decoration: InputDecoration(
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
              child: Text('Batal'),
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
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _updateItem(String itemId, String nama, int stok, String kode, int hargaJual) {
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
