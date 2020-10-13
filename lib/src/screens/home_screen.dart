import 'package:flutter/material.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_reader/src/blocs/scan_bloc.dart';
import 'package:qr_reader/src/models/scan.dart';
import 'package:qr_reader/src/utils/functions_utils.dart';

class HomeScreen extends StatelessWidget {
  final ScanBloc scanBloc = ScanBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Reader'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              scanBloc.deleteAllScans();
            },
          )
        ],
      ),
      body: _createScansList(),
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
      scanBloc.addScan(scan);
    }
  }

  Widget _createScansList() {
    return StreamBuilder(
      stream: scanBloc.getScanStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final List<Scan> scans = snapshot.data;

        if (scans.length == 0) {
          return Center(
            child: Text("No existe información"),
          );
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) =>
                  {scanBloc.deleteScan(scans[index].id)},
              child: ListTile(
                leading: Icon(
                  Icons.event_note,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(scans[index].value),
                trailing: scans[index].value.contains("http")
                    ? Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
                onTap: () => FunctionUtils.navigateToUrl(scans[index]),
              ),
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
