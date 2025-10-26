class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final DateTime? createdAt;

  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.createdAt,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
        uid: map['uid'] as String,
        email: map['email'] as String?,
        displayName: map['displayName'] as String?,
        photoUrl: map['photoUrl'] as String?,
        createdAt: map['createdAt'] is int
            ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
            : map['createdAt'] as DateTime?,
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'createdAt': (createdAt ?? DateTime.now()).toUtc().millisecondsSinceEpoch,
      };
}
