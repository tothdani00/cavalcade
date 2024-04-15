class Reply {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String username;
  final String profilePic;
  final String parentCommentId;
  Reply({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.username,
    required this.profilePic,
    required this.parentCommentId,
  });

  Reply copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? username,
    String? profilePic,
    String? parentCommentId,
  }) {
    return Reply(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      parentCommentId: parentCommentId ?? this.parentCommentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'username': username,
      'profilePic': profilePic,
      'parentCommentId': parentCommentId,
    };
  }

  factory Reply.fromMap(Map<String, dynamic> map) {
    return Reply(
      id: map['id'] as String,
      text: map['text'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      postId: map['postId'] as String,
      username: map['username'] as String,
      profilePic: map['profilePic'] as String,
      parentCommentId: map['parentCommentId'] as String,
    );
  }
  @override
  String toString() {
    return 'Reply(id: $id, text: $text, createdAt: $createdAt, postId: $postId, username: $username, profilePic: $profilePic, parentCommentId: $parentCommentId)';
  }

  @override
  bool operator ==(covariant Reply other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.text == text &&
      other.createdAt == createdAt &&
      other.postId == postId &&
      other.username == username &&
      other.profilePic == profilePic &&
      other.parentCommentId == parentCommentId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      text.hashCode ^
      createdAt.hashCode ^
      postId.hashCode ^
      username.hashCode ^
      profilePic.hashCode ^
      parentCommentId.hashCode;
  }
}
