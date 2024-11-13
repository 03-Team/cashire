import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';


class HomeControllerHari extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Map<String, String>> transaksis = [];
  final RxDouble totalSum = 0.0.obs;
  final RxDouble hppSum = 0.0.obs;
  final RxDouble keuntunganSum = 0.0.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('transactions').get();

      double total = 0;
      double hpp = 0;
      double keuntungan = 0;

      List<Future<void>> futures = [];

      for (var doc in snapshot.docs) {
        futures.add(() async {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          double hargaJual = data['harga_jual'] ?? 0;
          int jumlahBeli = data['jumlah_beli'] ?? 0;

          Timestamp timestamp = data['tanggal'];
          DateTime date = timestamp.toDate();
          String formattedDate = DateFormat('dd-MM-yyyy').format(date);

          double subtotal = hargaJual * jumlahBeli;
          double hppSubtotal = hargaJual / 2;
          double profit = subtotal - hppSubtotal;

          total += subtotal;
          hpp += hppSubtotal;
          keuntungan += profit;

          transaksis.add({
            "No Transaksi": data['id'] ?? '',
            "Tanggal": formattedDate,
            "Total": subtotal.toStringAsFixed(0),
            "HPP": hppSubtotal.toStringAsFixed(0),
            "Keuntungan": profit.toStringAsFixed(0),
          });
        }());
      }

      await Future.wait(futures);

      totalSum.value = total;
      hppSum.value = hpp;
      keuntunganSum.value = keuntungan;
    } catch (e) {
      print("Error fetching transactions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void getPDFhari() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header laporan
              pw.Align(
                alignment: pw.Alignment.topRight,
                child: pw.Text("Halaman : 1 dari 1"),
              ),
              pw.SizedBox(height: 8),
              pw.Text("Nama Toko       : Toko Jaya Kusuma"),
              pw.SizedBox(height: 8),
              pw.Text("Nama Laporan  : Laporan Transaksi"),
              pw.SizedBox(height: 8),
              pw.Text("Periode              : Hari ini"),
              pw.SizedBox(height: 10),

              // Tabel data transaksi
              pw.Table.fromTextArray(
                headers: [
                  "No Transaksi",
                  "Tanggal",
                  "Total",
                  "HPP",
                  "Keuntungan"
                ],
                data: transaksis
                    .map((transaksi) => [
                          transaksi["No Transaksi"],
                          transaksi["Tanggal"],
                          transaksi["Total"],
                          transaksi["HPP"],
                          transaksi["Keuntungan"],
                        ])
                    .toList(),
                cellAlignment: pw.Alignment.center,
                cellStyle: pw.TextStyle(fontSize: 10),
                headerStyle:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                border: pw.TableBorder.all(),
              ),

              // Total footer
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text("Total : ",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(totalSum.value.toStringAsFixed(0)),
                  pw.SizedBox(width: 20),
                  pw.Text(hppSum.value.toStringAsFixed(0)),
                  pw.SizedBox(width: 20),
                  pw.Text(keuntunganSum.value.toStringAsFixed(0)),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Untuk menyimpan
    final bytes = await pdf.save();

    // Buat file kosong di direktori
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/laporan_bulanan.pdf');

    // Timpa file kosong dengan file pdf
    await file.writeAsBytes(bytes);

    // Buka PDF
    final result = await OpenFile.open(file.path);
    if (result.type != ResultType.done) {
      print("Error opening PDF: ${result.message}");
    }
  }
}
