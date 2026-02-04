
//HIVE MODEL:

import 'package:hive/hive.dart';

part 'service.g.dart'; // generated file

@HiveType(typeId: 0) // each Hive object needs a unique typeId
class Service extends HiveObject {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final String serviceTypeName;

  @HiveField(2)
  final String serviceRecDetail;

  @HiveField(3)
  final String fee;

  @HiveField(4)
  final String time;

  @HiveField(5)
  final String serviceProvider;

  @HiveField(6)
  final String complainListen;

  Service({
    required this.code,
    required this.serviceTypeName,
    required this.serviceRecDetail,
    required this.fee,
    required this.time,
    required this.serviceProvider,
    required this.complainListen,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      code: json['code'] ?? '',
      serviceTypeName: json['service_typename'] ?? '',
      serviceRecDetail: json['service_recdetail'] ?? '',
      fee: json['fee'] ?? '',
      time: json['time'] ?? '',
      serviceProvider: json['service_provider'] ?? '',
      complainListen: json['complain_listen'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'service_typename': serviceTypeName,
      'service_recdetail': serviceRecDetail,
      'fee': fee,
      'time': time,
      'service_provider': serviceProvider,
      'complain_listen': complainListen,
    };
  }
}