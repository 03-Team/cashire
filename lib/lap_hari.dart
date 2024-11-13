import 'package:Cashire/laporan_success.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';  // Import untuk format tanggal
import 'app/modules/home/controllers/home_controller_hari.dart';

class LapHari extends StatelessWidget {
  const LapHari({super.key});

  @override
  Widget build(BuildContext context) {
    return LapHariScreen();
  }
}

class LapHariScreen extends StatelessWidget {
  final HomeControllerHari controller = Get.put(HomeControllerHari());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 217, 231),
        title: Text(
          "Laporan Hari Ini",
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Menampilkan informasi ringkasan
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                      "Total            : Rp ${controller.totalSum.value.toStringAsFixed(0)}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                SizedBox(height: 8),
                Obx(() => Text(
                      "HPP             : Rp ${controller.hppSum.value.toStringAsFixed(0)}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                SizedBox(height: 8),
                Obx(() => Text(
                      "Keuntungan: Rp ${controller.keuntunganSum.value.toStringAsFixed(0)}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
              ],
            ),

            SizedBox(height: 20),

            // Menampilkan daftar transaksi dengan indikator loading
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (controller.transaksis.isEmpty) {
                    return Center(child: Text("Tidak ada data transaksi"));
                  }
                  return ListView.builder(
                    itemCount: controller.transaksis.length,
                    itemBuilder: (context, index) {
                      final transaksi = controller.transaksis[index];  // Mendapatkan tanggal saat ini
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${transaksi['Tanggal']}"), 
                              Text("Total            : Rp ${transaksi['Total']}"),
                              Text("HPP             : Rp ${transaksi['HPP']}"),
                              Text("Keuntungan: Rp ${transaksi['Keuntungan']}"),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.getPDFhari(),
        child: Icon(Icons.print),
      ),
    );
  }
}
