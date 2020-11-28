import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:postgres/postgres.dart';

void main() => runApp(
      MaterialApp(
        home: Scan(),
        title: "MonoFYI",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );

void db(List<String> arguments) async {
  final conn = PostgreSQLConnection(
    'localhost',
    5435,
    'QR-Project',
    username: 'postgres',
    password: 'User@290',
  );
  await conn.open();
  print('Connected successfully');
  var results = await conn.query('SELECT * FROM product_table');
  await conn.close();
}

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  String barcode = "None";

  @override
  void initState() {
    super.initState();
  }

  Future scan() async {
    String result = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);
    setState(() {
      this.barcode = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "MonoFYI",
            style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          centerTitle: true,
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: scan,
                  child: const Text("START SCAN"),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 19.0, vertical: 8.0),
                child: Text(
                  "Code: " + barcode,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ));
  }
}
