import 'dart:convert';

class UserBalanceDatapoint {
  final String reference;
  final String uid;
  final double newBalance;
  final double oldBalance;
  final double difference;
  final DateTime time;
  final String type;
  final String userId;
  final String transactionId;

  UserBalanceDatapoint({
    required this.reference,
    required this.uid,
    required this.newBalance,
    required this.oldBalance,
    required this.difference,
    required this.time,
    required this.type,
    required this.userId,
    required this.transactionId,
  });

  UserBalanceDatapoint copyWith({
    String? reference,
    String? uid,
    double? newBalance,
    double? oldBalance,
    double? difference,
    DateTime? time,
    String? type,
    String? userId,
    String? transactionId,
  }) {
    return UserBalanceDatapoint(
      reference: reference ?? this.reference,
      uid: uid ?? this.uid,
      newBalance: newBalance ?? this.newBalance,
      oldBalance: oldBalance ?? this.oldBalance,
      difference: difference ?? this.difference,
      time: time ?? this.time,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reference': reference,
      'uid': uid,
      'newBalance': newBalance,
      'oldBalance': oldBalance,
      'difference': difference,
      'time': time.millisecondsSinceEpoch,
      'type': type,
      'userId': userId,
      'transactionId': transactionId,
    };
  }

  factory UserBalanceDatapoint.fromMap(Map<String, dynamic> map) {
    return UserBalanceDatapoint(
      reference: map['reference'] ?? '',
      uid: map['uid'] ?? '',
      newBalance: map['newBalance']?.toDouble() ?? 0.0,
      oldBalance: map['oldBalance']?.toDouble() ?? 0.0,
      difference: map['difference']?.toDouble() ?? 0.0,
      time: DateTime.parse(map['time']),
      type: map['type'] ?? '',
      userId: map['userId'] ?? '',
      transactionId: map['transactionId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserBalanceDatapoint.fromJson(String source) =>
      UserBalanceDatapoint.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserBalanceDatapoint(reference: $reference, uid: $uid, newBalance: $newBalance, oldBalance: $oldBalance, difference: $difference, time: $time, type: $type, userId: $userId, transactionId: $transactionId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserBalanceDatapoint &&
        other.reference == reference &&
        other.uid == uid &&
        other.newBalance == newBalance &&
        other.oldBalance == oldBalance &&
        other.difference == difference &&
        other.time == time &&
        other.type == type &&
        other.userId == userId &&
        other.transactionId == transactionId;
  }

  @override
  int get hashCode {
    return reference.hashCode ^
        uid.hashCode ^
        newBalance.hashCode ^
        oldBalance.hashCode ^
        difference.hashCode ^
        time.hashCode ^
        type.hashCode ^
        userId.hashCode ^
        transactionId.hashCode;
  }
}
