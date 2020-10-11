import 'package:flutter/material.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_reader/src/models/scan.dart';
import 'package:qr_reader/src/providers/database_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = DatabaseProvider.databaseProvider;
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Reader'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {},
          )
        ],
      ),
      body: FutureBuilder(
        future: db.findAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String output = "";
            for (Scan scan in snapshot.data) {
              output = output + " " + scan.value;
            }
            return Center(child: Text(output));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQR,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.filter_center_focus),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _scanQR() async {
    var result = await BarcodeScanner.scan();
    if (result != null && result.rawContent != "") {
      Scan scan = Scan(value: result.rawContent);
      DatabaseProvider.databaseProvider.save(scan);
    }
  }
}
