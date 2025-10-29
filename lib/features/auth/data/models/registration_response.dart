class RegistrationResponse {
  final int userId;
  final String username;

  RegistrationResponse({
    required this.userId,
    required this.username,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
    );
  }
}
