import 'package:flutter/foundation.dart';

class Community {
  final String id;
  final String name;
  final String banner;
  final String profilePic;
  final List<String> members;
  final List<String> admins;
  Community({
    required this.id,
    required this.name,
    required this.banner,
    required this.profilePic,
    required this.members,
    required this.admins,
  });

  Community copyWith({
    String? id,
    String? name,
    String? banner,
    String? profilePic,
    List<String>? members,
    List<String>? admins,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      banner: banner ?? this.banner,
      profilePic: profilePic ?? this.profilePic,
      members: members ?? this.members,
      admins: admins ?? this.admins,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'banner': banner,
      'profilePic': profilePic,
      'members': members,
      'admins': admins,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] as String,
      name: map['name'] as String,
      banner: map['banner'] as String,
      profilePic: map['profilePic'] as String,
      members: List<String>.from((map['members'])),
      admins: List<String>.from((map['admins'])),
    );
  }


  @override
  String toString() {
    return 'Community(id: $id, name: $name, banner: $banner, profilePic: $profilePic, members: $members, admins: $admins)';
  }

  @override
  bool operator ==(covariant Community other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.banner == banner &&
      other.profilePic == profilePic &&
      listEquals(other.members, members) &&
      listEquals(other.admins, admins);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      banner.hashCode ^
      profilePic.hashCode ^
      members.hashCode ^
      admins.hashCode;
  }
}
