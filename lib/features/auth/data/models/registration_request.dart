class RegistrationRequest {
  final String username;
  final String password;
  final int roleId;
  final int parentCeoId;
  final int bdoId;
  final int departmentId;
  final bool isActive;

  RegistrationRequest({
    required this.username,
    required this.password,
    required this.roleId,
    this.parentCeoId = 0,
    this.bdoId = 0,
    this.departmentId = 0,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'roleId': roleId,
    'parentCeoId': parentCeoId,
    'bdoId': bdoId,
    'departmentId': departmentId,
    'isActive': isActive,
  };
}
