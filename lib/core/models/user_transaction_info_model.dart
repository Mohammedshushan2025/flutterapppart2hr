// lib/core/models/user_transaction_info_model.dart

import 'dart:convert';

UserTransactionInfo userTransactionInfoFromJson(String str) => UserTransactionInfo.fromJson(json.decode(str));

class UserTransactionInfo {
  final List<UserTransactionInfoItem> items;

  UserTransactionInfo({ required this.items });

  factory UserTransactionInfo.fromJson(Map<String, dynamic> json) => UserTransactionInfo(
    items: List<UserTransactionInfoItem>.from(json["items"].map((x) => UserTransactionInfoItem.fromJson(x))),
  );
}

class UserTransactionInfoItem {
  final int? usersCode;
  final int? lastVcncSeq;
  final int? lastLoanSeq;
  final int? lastEndsrvSeq;
  // ... باقي الحقول يمكن إضافتها عند الحاجة

  UserTransactionInfoItem({
    this.usersCode,
    this.lastVcncSeq,
    this.lastLoanSeq,
    this.lastEndsrvSeq,
  });

  factory UserTransactionInfoItem.fromJson(Map<String, dynamic> json) => UserTransactionInfoItem(
    usersCode: json["UsersCode"],
    lastVcncSeq: json["LastVcncSeq"],
    lastLoanSeq: json["LastLoanSeq"],
    lastEndsrvSeq: json["LastEndsrvSeq"],
  );
}