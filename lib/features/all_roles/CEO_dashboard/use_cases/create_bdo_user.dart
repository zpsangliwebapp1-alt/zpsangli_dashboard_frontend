import '../repository/create_bdo_repository.dart';

class CreateBdoUser {
  final BdoRepository repository;
  CreateBdoUser(this.repository);

  Future<Map<String, dynamic>> call(Map<String, dynamic> body) {
    return repository.createBdoUser(body);
  }
}
