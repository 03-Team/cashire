import 'package:Cashire/calculator_kasbon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Cashire/dashboard.dart';
import 'package:intl/intl.dart';

class KasbonApps extends StatefulWidget {
  @override
  _KasbonAppsState createState() => _KasbonAppsState();
}

class _KasbonAppsState extends State<KasbonApps> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 217, 231),
        title: Text('Kasbon', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (c) => DashboardApps()),
            );
          },
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('kasbon').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var documents = snapshot.data!.docs;

          if (documents.isEmpty) {
            return Center(child: Text("Tidak ada data kasbon."));
          }

          // Tambahkan log untuk melihat isi documents
          print("Documents: ${documents.map((doc) => doc.data()).toList()}");

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var totalKasbon = documents
              .map((doc) => doc['nominal'] as int)
              .fold(0, (a, b) => a + b);
          var totalTransaksi = documents.length;

          return Stack(
            children: [
              Container(
                height: 50,
                width: Size.infinite.width,
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal:
                        BorderSide(color: Color.fromARGB(255, 199, 217, 231)),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Icon(Icons.sort),
                    ),
                    SizedBox(width: 16),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: Icon(Icons.search),
                    ),
                  ],
                ),
              ),

              // Menampilkan Total Kasbon
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Color.fromARGB(255, 199, 217, 231)),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Kasbon"),
                        Text("Rp $totalKasbon"),
                      ],
                    ),
                  ),
                ),
              ),

              // Menampilkan Total Transaksi
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 200),
                child: Container(
                  height: 50,
                  width: 230,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Color.fromARGB(255, 199, 217, 231)),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: 50, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Total Transaksi"),
                        Text("$totalTransaksi"),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 100, left: 5),
                child: Container(
                  height: 50,
                  width: Size.infinite.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isChecked1,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked1 = value!;
                          });
                        },
                      ),
                      Text('Lunas'),
                      SizedBox(width: 16),
                      Checkbox(
                        value: _isChecked2,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked2 = value!;
                          });
                        },
                      ),
                      Text('Belum Lunas'),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: SingleChildScrollView(
                  child: Column(
                    children: documents.map((doc) {
                      var kasbon = doc.data() as Map<String, dynamic>;
                      var tanggalTransaksi = kasbon['tanggal_sekarang'] != null
                          ? DateFormat('dd-MM-yyyy')
                              .format(kasbon['tanggal_sekarang'].toDate())
                          : 'Tanggal tidak tersedia';
                      var tanggalJatuhTempo = kasbon['tanggal_jatuh_tempo'] !=
                              null
                          ? DateFormat('dd-MM-yyyy')
                              .format(kasbon['tanggal_jatuh_tempo'].toDate())
                          : 'Tanggal tidak tersedia';
                      String statusKasbon = kasbon['keterangan'] == 'Lunas'
                          ? 'Lunas'
                          : 'Belum Lunas';

                      return GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Kalkulatorkasbon(
                                totalKasbon: kasbon['nominal'],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nama dan tombol edit/hapus di pojok kanan atas
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${kasbon['nama']}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (c) => EditKasbonPage(
                                                    kasbon: kasbon,
                                                    docId: doc.id),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () async {
                                            bool? confirmDelete =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      Text("Konfirmasi Hapus"),
                                                  content: Text(
                                                      "Apakah Anda yakin ingin menghapus data ini?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text("Tidak"),
                                                      onPressed: () {
                                                        Navigator.pop(context,
                                                            false); // Menutup dialog
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text("Hapus"),
                                                      onPressed: () {
                                                        Navigator.of(context).pop(
                                                            true); // Konfirmasi hapus
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (confirmDelete == true) {
                                              await FirebaseFirestore.instance
                                                  .collection('kasbon')
                                                  .doc(doc.id)
                                                  .delete();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                // Tanggal jatuh tempo
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("$tanggalTransaksi"),
                                    Text(
                                      "$tanggalJatuhTempo",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                // Status dan Nominal Kasbon sejajar
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "${formatCurrency(kasbon['nominal'])}"),
                                    Text("$statusKasbon",
                                        style: TextStyle(
                                            color: statusKasbon == 'Lunas'
                                                ? Colors.green
                                                : Colors.red)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 500),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 181, 220, 238),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (c) => HutangPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 105),
                      child: Text('Tambah Hutang'),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HutangPage extends StatefulWidget {
  @override
  _HutangPageState createState() => _HutangPageState();
}

class _HutangPageState extends State<HutangPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nominalController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tanggalJatuhTempoController =
      TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  DateTime? selectedTanggalJatuhTempo;

  Future<void> createKasbon(
      String nama,
      int nominal,
      DateTime tanggalJatuhTempo,
      DateTime tanggalSekarang,
      String keterangan) async {
    await _firestore.collection('kasbon').add({
      'nama': nama,
      'nominal': nominal,
      'tanggal_jatuh_tempo': tanggalJatuhTempo,
      'tanggal_sekarang': tanggalSekarang,
      'keterangan': keterangan,
      'status': 'Belum Lunas',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 217, 231),
        title: Text('Kasbon', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (c) => KasbonApps()),
            );
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(45.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nominalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Nominal'),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Nominal tidak boleh kosong';
                  if (int.tryParse(value) == null)
                    return 'Nominal harus berupa angka';
                  return null;
                },
              ),
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Nama tidak boleh kosong';
                  return null;
                },
              ),
              TextFormField(
                controller: tanggalJatuhTempoController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Tanggal Jatuh Tempo'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedTanggalJatuhTempo = pickedDate;
                      tanggalJatuhTempoController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Tanggal jatuh tempo tidak boleh kosong';
                  return null;
                },
              ),
              TextFormField(
                controller: keteranganController,
                decoration: InputDecoration(labelText: 'Keterangan'),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 181, 220, 238),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await createKasbon(
                        namaController.text,
                        int.parse(nominalController.text),
                        selectedTanggalJatuhTempo!,
                        DateTime.now(),
                        keteranganController.text,
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (c) => KasbonApps()),
                      );
                    }
                  },
                  child: Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditKasbonPage extends StatefulWidget {
  final Map<String, dynamic> kasbon;
  final String docId;

  EditKasbonPage({required this.kasbon, required this.docId});

  @override
  _EditKasbonPageState createState() => _EditKasbonPageState();
}

class _EditKasbonPageState extends State<EditKasbonPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nominalController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tanggalJatuhTempoController =
      TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  DateTime? selectedTanggalJatuhTempo;

  @override
  void initState() {
    super.initState();
    nominalController.text = widget.kasbon['nominal'].toString();
    namaController.text = widget.kasbon['nama'];
    tanggalJatuhTempoController.text = DateFormat('yyyy-MM-dd')
        .format(widget.kasbon['tanggal_jatuh_tempo'].toDate());
    keteranganController.text = widget.kasbon['keterangan'] ?? '';
    selectedTanggalJatuhTempo = widget.kasbon['tanggal_jatuh_tempo']?.toDate();
  }

  Future<void> updateKasbon() async {
    await FirebaseFirestore.instance
        .collection('kasbon')
        .doc(widget.docId)
        .update({
      'nama': namaController.text,
      'nominal': int.parse(nominalController.text),
      'tanggal_jatuh_tempo': selectedTanggalJatuhTempo,
      'keterangan': keteranganController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 217, 231),
        title:
            Text('Edit Kasbon', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (c) => KasbonApps()),
            );
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(45.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nominalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Nominal'),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Nominal tidak boleh kosong';
                  if (int.tryParse(value) == null)
                    return 'Nominal harus berupa angka';
                  return null;
                },
              ),
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Nama tidak boleh kosong';
                  return null;
                },
              ),
              TextFormField(
                controller: tanggalJatuhTempoController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Tanggal Jatuh Tempo'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedTanggalJatuhTempo ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedTanggalJatuhTempo = pickedDate;
                      tanggalJatuhTempoController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Tanggal jatuh tempo tidak boleh kosong';
                  return null;
                },
              ),
              TextFormField(
                controller: keteranganController,
                decoration: InputDecoration(labelText: 'Keterangan'),
                readOnly: true, // Menambahkan properti readOnly
                enabled: false,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 181, 220, 238),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await updateKasbon();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (c) => KasbonApps()),
                      );
                    }
                  },
                  child: Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
