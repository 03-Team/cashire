import 'package:Cashire/barang.dart';
import 'package:Cashire/calculator.dart';
import 'package:flutter/material.dart';
import 'package:Cashire/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: TransaksiApps(),
  ));
}

class TransaksiApps extends StatefulWidget {
  @override
  _TransaksiAppsState createState() => _TransaksiAppsState();
}

class _TransaksiAppsState extends State<TransaksiApps> {
  String? selectedValue;
  List<Map<String, dynamic>> selectedItems = [];
  final CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('barang');
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

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
          'Transaksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (c) => DashboardApps()));
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildItemList(),
          _buildTotalAmount(),
          _buildFloatingActionButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Color.fromARGB(255, 199, 217, 231)),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(Icons.search),
          ),
          const SizedBox(width: 16),
          Icon(Icons.add),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: DropdownButton<String?>(
                value: _selectedCategory,
                icon: Icon(Icons.arrow_drop_down),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items:
                    _categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _selectedCategory == 'semua'
            ? _itemsCollection.snapshots()
            : _itemsCollection
                .where('kategori', isEqualTo: _selectedCategory)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var items =
              snapshot.data!.docs.map((doc) => Item.fromDocument(doc)).toList();

          if (items.isEmpty) {
            return Center(
                child: Text("Tidak Ada Barang Di dalam Kategori Ini"));
          }
          
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var barang = doc.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  onTap: () {
                    addItem(
                        barang['nama'], barang['harga_jual'], barang['kode']);
                  },
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
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildTotalAmount() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Rp ${calculateTotal()}',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            saveTransaction();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransaksiTotal(
                  selectedItems: selectedItems,
                  totalAmount: calculateTotal(),
                ),
              ),
            );
          },
          child: Icon(Icons.add_shopping_cart),
        ),
      ),
    );
  }

  void addItem(String? nama, double? harga_jual, String? kode) {
    int index = selectedItems.indexWhere((item) => item['nama'] == nama);
    if (index != -1) {
      setState(() {
        selectedItems[index]['jumlah_beli']++;
      });
    } else {
      setState(() {
        selectedItems.add({
          'nama': nama,
          'kode': kode,
          'harga_jual': harga_jual,
          'jumlah_beli': 1,
        });
      });
    }
    print("Selected Items: $selectedItems");
  }

  double calculateTotal() {
    double total = 0;
    for (var item in selectedItems) {
      total += (item['harga_jual'] ?? 0) * (item['jumlah_beli'] ?? 1);
    }
    print("Total: $total");
    return total;
  }

  void saveTransaction() async {
    CollectionReference transactions =
        FirebaseFirestore.instance.collection('transactions'); // Koleksi barang
    for (var item in selectedItems) {
      // Simpan transaksi ke Firestore
      await transactions.add({
        'nama': item['nama'],
        'kode': item['kode'],
        'harga_jual': item['harga_jual'],
        'jumlah_beli': item['jumlah_beli'],
        'total': (item['harga_jual'] ?? 0) * (item['jumlah_beli'] ?? 1),
        'tanggal': FieldValue.serverTimestamp(),
      });
    }

    print("Transaction saved!");
  }
}

class TransaksiTotal extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final double totalAmount;

  const TransaksiTotal({
    super.key,
    required this.selectedItems,
    required this.totalAmount,
  });

  @override
  State<TransaksiTotal> createState() => _TransaksiTotalState();
}

class _TransaksiTotalState extends State<TransaksiTotal> {
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
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_box),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (c) => Kalkulator(
                      totalAmount: widget.totalAmount,
                      selectedItems: widget.selectedItems),
                ),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.selectedItems.length,
        itemBuilder: (context, index) {
          var item = widget.selectedItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                item['nama'] ?? 'Tidak ada nama',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kode: ${item['kode'] ?? 'Tidak ada kode'}',
                      style: const TextStyle(fontSize: 14)),
                  Text(
                      'Rp ${item['harga_jual']?.toString() ?? '0'} x ${item['jumlah_beli']}',
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
