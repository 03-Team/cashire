import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:Cashire/kasbon.dart';
import 'package:Cashire/laporan_success.dart';
import 'package:Cashire/manajemen.dart';
import 'package:Cashire/page_profil.dart';
import 'package:Cashire/transaksi.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardApps extends StatefulWidget {

  @override
  State<DashboardApps> createState() => _DashboardAppsState();
}

class _DashboardAppsState extends State<DashboardApps> {
  String userName = '';
  String storeName = 'Cashire';
  @override
  void initState() {
  super.initState();
    _loadUserData();
  }
    Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('userEmail');
    
    if (email != null && email.isNotEmpty) {
      setState(() {
        userName = email.substring(0, 3); // Get the first 3 letters of the email
      });
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/backg.png', height: 310, fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 40, 10, 1),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(" Hellow! " + userName), // Display first 3 letters of the email
                      Text(" Selamat Datang di " + storeName, style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: InkWell(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyProfil(),
                        ),
                      );
                    },
                    child: Image.asset('assets/pp.jpg', height: 60, width: 60,)
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(0, 125, 0, 0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150, left: 20),
            child: Container(
              width: 350.0,
              height: 65.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(
                    width: 1, color: Color.fromARGB(255, 226, 223, 223)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 7, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: Text(
                      'Hari Ini',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat('EEEE, d MMMM y').format(DateTime.now()), // Format tanggal
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 230, left: 20),
            child: Container(
              width: 116,
              height: 65.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(
                    width: 1, color: Color.fromARGB(255, 226, 223, 223)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 7, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        'Transaksi Hari Ini',
                        style:
                            TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 30),
                      child: Text(
                        '0',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 230, left: 140),
            child: Container(
              width: 116,
              height: 65.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(
                    width: 1, color: Color.fromARGB(255, 226, 223, 223)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 7, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1),
                      child: Text(
                        'Transaksi Bulan Ini',
                        style:
                            TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 35),
                      child: Text(
                        '0',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 230, left: 260),
            child: Container(
              width: 116,
              height: 65.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(
                    width: 1, color: const Color.fromARGB(255, 226, 223, 223)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 7, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1),
                      child: Text(
                        'Transaksi Tahun Ini',
                        style:
                            TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 35),
                      child: Text(
                        '0',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 310),
            child: Container(
              child: GridView.count(
                padding: const EdgeInsets.only(top: 20),
                crossAxisCount: 2,
                children: <Widget>[
                  Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => ManajemenApps()));
                        },
                        splashColor: Colors.lightBlueAccent,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Image.asset('assets/manage.png'),
                                  )),
                              Text('Manajemen', style: TextStyle(fontSize: 15))
                            ],
                          ),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                          left: 20, right: 30, bottom: 25)),
                  Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => TransaksiApps()));
                        },
                        splashColor: Colors.lightBlueAccent,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child:
                                        Image.asset('assets/transaction.png'),
                                  )),
                              Text('Transaksi', style: TextStyle(fontSize: 15))
                            ],
                          ),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                          left: 20, right: 30, bottom: 25)),
                  Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (c) => KasbonApps()));
                        },
                        splashColor: Colors.lightBlueAccent,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Image.asset('assets/money.png'),
                                  )),
                              Text('Kasbon', style: TextStyle(fontSize: 15))
                            ],
                          ),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                          left: 20, right: 30, bottom: 25)),
                  Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => LaporanSuccess()));
                        },
                        splashColor: Colors.lightBlueAccent,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Image.asset('assets/report.png'),
                                  )),
                              Text('Laporan', style: TextStyle(fontSize: 15))
                            ],
                          ),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                          left: 20, right: 30, bottom: 25)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
