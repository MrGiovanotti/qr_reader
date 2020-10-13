import 'dart:async';

import 'package:qr_reader/src/models/scan.dart';
import 'package:qr_reader/src/providers/database_provider.dart';

class ScanBloc {
  static ScanBloc _scanBloc;

  ScanBloc._() {
    getAllScans();
  }

  factory ScanBloc() {
    if (_scanBloc == null) {
      _scanBloc = ScanBloc._();
    }
    return _scanBloc;
  }

  final _scanStreamController = StreamController<List<Scan>>.broadcast();

  Stream<List<Scan>> get getScanStream => _scanStreamController.stream;

  void dispose() {
    _scanStreamController.close();
  }

  addScan(Scan scan) async {
    await DatabaseProvider.getInstance().save(scan);
    getAllScans();
  }

  deleteScan(int id) async {
    await DatabaseProvider.getInstance().delete(id);
    getAllScans();
  }

  deleteAllScans() async {
    await DatabaseProvider.getInstance().deleteAll();
    getAllScans();
  }

  getAllScans() async {
    _scanStreamController.sink
        .add(await DatabaseProvider.getInstance().findAll());
  }
}
