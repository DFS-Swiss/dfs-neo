import 'dart:convert';

class UserModel {
  final DateTime createdAt;
  final DateTime lastLogin;
  final String? firstName;
  final String? surName;
  final String referalCode;
  final String inputWalletAdress;
  final bool emailConfirmed;
  final String email;
  final String id;
  UserModel({
    required this.createdAt,
    required this.lastLogin,
    this.firstName,
    this.surName,
    required this.referalCode,
    required this.inputWalletAdress,
    required this.emailConfirmed,
    required this.email,
    required this.id,
  });

  UserModel copyWith({
    DateTime? createdAt,
    DateTime? lastLogin,
    String? firstName,
    String? surName,
    String? referalCode,
    String? inputWalletAdress,
    bool? emailConfirmed,
    String? email,
    String? id,
  }) {
    return UserModel(
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      firstName: firstName ?? this.firstName,
      surName: surName ?? this.surName,
      referalCode: referalCode ?? this.referalCode,
      inputWalletAdress: inputWalletAdress ?? this.inputWalletAdress,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
      email: email ?? this.email,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLogin': lastLogin.millisecondsSinceEpoch,
      'firstName': firstName,
      'surName': surName,
      'referalCode': referalCode,
      'inputWalletAdress': inputWalletAdress,
      'emailConfirmed': emailConfirmed,
      'email': email,
      '_id': id,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      createdAt: DateTime.parse(map['createdAt']),
      lastLogin: DateTime.parse(map['lastLogin']),
      firstName: map['firstName'] ?? '',
      surName: map['surName'] ?? '',
      referalCode: map['referalCode'] ?? '',
      inputWalletAdress: map['inputWalletAdress'] ?? '',
      emailConfirmed: map['emailConfirmed'] ?? false,
      email: map['email'] ?? '',
      id: map['_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(createdAt: $createdAt, lastLogin: $lastLogin, firstName: $firstName, surName: $surName, referalCode: $referalCode, inputWalletAdress: $inputWalletAdress, emailConfirmed: $emailConfirmed, email: $email, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.createdAt == createdAt &&
        other.lastLogin == lastLogin &&
        other.firstName == firstName &&
        other.surName == surName &&
        other.referalCode == referalCode &&
        other.inputWalletAdress == inputWalletAdress &&
        other.emailConfirmed == emailConfirmed &&
        other.email == email &&
        other.id == id;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
        lastLogin.hashCode ^
        firstName.hashCode ^
        surName.hashCode ^
        referalCode.hashCode ^
        inputWalletAdress.hashCode ^
        emailConfirmed.hashCode ^
        email.hashCode ^
        id.hashCode;
  }
}
