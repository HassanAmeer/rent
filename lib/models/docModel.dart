

import 'package:rent/constants/tostring.dart';

class DocDataModel {
   int id;
  String privacyPolicy;
  String shippingPolicy;
  String returnRefundPolicy;
  String termsCondition;
  String contactUs;
  final DateTime createdAt;
  final DateTime updatedAt;

  DocDataModel({
    required this.id,
    this.privacyPolicy = "",
    this.shippingPolicy = "",
    this.returnRefundPolicy = "",
    this.termsCondition = "",
    this.contactUs = "",
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocDataModel.fromJson(Map<String, dynamic> json) {
    return DocDataModel(
      id: json['id'] as int,
      privacyPolicy: json['privacyPolicy'].toString().toNullString(),
      shippingPolicy: json['shippingPolicy'].toString().toNullString(),
      returnRefundPolicy: json['returnRefundPolicy'].toString().toNullString(),
      termsCondition: json['termsCondition'].toString().toNullString(),
      contactUs: json['contactUs'].toString().toNullString(),
      createdAt: DateTime.parse(json['created_at'].toString().toNullString()),
      updatedAt: DateTime.parse(json['updated_at'].toString().toNullString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'privacyPolicy': privacyPolicy,
      'shippingPolicy': shippingPolicy,
      'returnRefundPolicy': returnRefundPolicy,
      'termsCondition': termsCondition,
      'contactUs': contactUs,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}