import '../models/bdo_model.dart' show BdoModel, Bdo;

import '../repository/create_bdo_repository.dart';

class FetchBdos {
  final BdoRepository repository;
  FetchBdos(this.repository);

  Future<List<Bdo>> call(int parentCeoId) {
    return repository.getBdos(parentCeoId);
  }
}
