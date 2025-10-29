import '../models/bdo_model.dart';

import '../repository/create_bdo_repository.dart';

class CreateBlock {
  final BdoRepository repository;
  CreateBlock(this.repository);

  Future<Bdo> call(String name, String token, int userId) {
    return repository.createBlock(name: name, token: token, userId: userId);
  }
}
