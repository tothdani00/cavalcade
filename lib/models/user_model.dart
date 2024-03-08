import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String email;
  final String profilePicture;
  final String banner;
  final String uid;
  final bool isAuthenticated;
  final int points;
  final List<String> awards;
  UserModel({
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.banner,
    required this.uid,
    required this.isAuthenticated,
    required this.points,
    required this.awards,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? profilePicture,
    String? banner,
    String? uid,
    bool? isAuthenticated,
    int? points,
    List<String>? awards,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      banner: banner ?? this.banner,
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      points: points ?? this.points,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'banner': banner,
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'points': points,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      profilePicture: map['profilePicture'] as String,
      banner: map['banner'] as String,
      uid: map['uid'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      points: map['points'] as int,
      awards: List<String>.from((map['awards'])),
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, profilePicture: $profilePicture, banner: $banner, uid: $uid, isAuthenticated: $isAuthenticated, points: $points, awards: $awards)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.email == email &&
      other.profilePicture == profilePicture &&
      other.banner == banner &&
      other.uid == uid &&
      other.isAuthenticated == isAuthenticated &&
      other.points == points &&
      listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return name.hashCode ^
      email.hashCode ^
      profilePicture.hashCode ^
      banner.hashCode ^
      uid.hashCode ^
      isAuthenticated.hashCode ^
      points.hashCode ^
      awards.hashCode;
  }
}
