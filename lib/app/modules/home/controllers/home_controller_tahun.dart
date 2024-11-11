import 'dart:io';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class HomeControllerTahun extends GetxController {
  // Data dummy untuk contoh
  final List<Map<String, String>> transaksis = [
    {
      "No Transaksi": "000001",
      "Tanggal": "24-01-2024",
      "Total": "75000",
      "HPP": "50000",
      "Keuntungan": "25000"
    },
    {
      "No Transaksi": "000002",
      "Tanggal": "30-12-2024",
      "Total": "60000",
      "HPP": "50000",
      "Keuntungan": "10000"
    },
    // Tambahkan data lain jika perlu
  ];

  final String totalSum = "135000";
  final String hppSum = "100000";
  final String keuntunganSum = "35000";

  void getPDFtahun() async {
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
              pw.Text("Periode              : Tahun ini"),
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
                  pw.Text(totalSum),
                  pw.SizedBox(width: 20),
                  pw.Text(hppSum),
                  pw.SizedBox(width: 20),
                  pw.Text(keuntunganSum),
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
    final file = File('${dir.path}/mydownload.pdf');

    // Timpa file kosong dengan file pdf
    await file.writeAsBytes(bytes);

    // Open pdf
    await OpenFile.open(file.path);
  }
}
