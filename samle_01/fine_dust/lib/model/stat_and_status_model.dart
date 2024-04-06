import 'package:fine_dust/model/stat_model.dart';
import 'package:fine_dust/model/status_dat.dart';

class StatAndStatusModel {
  final ItemCode itemCode;
  final StatusModel status;
  final StatModel stat;

  StatAndStatusModel({
    required this.itemCode,
    required this.status,
    required this.stat
  });

}