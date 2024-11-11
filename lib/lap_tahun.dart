import 'package:Cashire/laporan_success.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/home/controllers/home_controller_tahun.dart';

class LapTahun extends StatelessWidget {
  const LapTahun({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: laptahun(),
    );
  }
}

class laptahun extends StatelessWidget {
  final HomeControllerTahun controller = Get.put(HomeControllerTahun());
  final List<Map<String, String>> transaksis = [
    {
      'time': '15:36:07',
      'date': '24 Jan 2024',
      'income': 'Rp 75.000',
      'profit': 'Rp 25.000'
    },
    {
      'time': '14:36:07',
      'date': '30 Des 2024',
      'income': 'Rp 60.000',
      'profit': 'Rp 10.000'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 217, 231),
        title: Text(
          "Laporan Tahun Ini",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (c) => LaporanSuccess()));
            }),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(bottom: 80),
            itemCount: transaksis.length,
            itemBuilder: (context, index) {
              final transaksi = transaksis[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateTime.now()
                              .toLocal()
                              .toString()
                              .substring(11, 16), // Menampilkan jam dan menit
                          style: TextStyle(fontSize: 12.0),
                        ),
                        Text(
                          DateTime.now().toLocal().toString().substring(
                              0, 10), // Menampilkan tanggal (YYYY-MM-DD)
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Pendapatan:\n${transaksi['income']}'),
                        SizedBox(height: 4),
                        Text('Keuntungan:\n ${transaksi['profit']}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.getPDFtahun(),
        child: Icon(Icons.print),
      ),
    );
  }
}
