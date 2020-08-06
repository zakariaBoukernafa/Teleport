class Users {
  final String username;
  final String email;
  final String profilePicture;
  final String phoneNumber;
  final String robotId;
  final String userId;
  final bool isEmailVerified;

  Users(
      {this.username,
      this.email,
      this.profilePicture,
      this.phoneNumber,
      this.robotId,
        this.userId,
      this.isEmailVerified});

  factory Users.fromMap(Map data) {
    data = data ?? {};

    return Users(
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        profilePicture: data["profilePicture"] ?? '',
        phoneNumber: data["phoneNumber"] ?? '',
        robotId: data['robotId'] ?? '',
        userId: data['userId'] ?? '',
        isEmailVerified: data['isEmailVerified'] ?? false);
  }
}
