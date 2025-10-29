//
// import '../controller/bdo_remote_data_source.dart' show BdoRemoteDataSource;
// import '../models/bdo_model.dart';
// import '../repository/create_bdo_repository.dart';
//
// class BdoRepositoryImpl implements BdoRepository {
//   final BdoRemoteDataSource remoteDataSource;
//
//   BdoRepositoryImpl(this.remoteDataSource);
//
//   @override
//   Future<List<BdoModel>> getBdos(int parentCeoId) =>
//       remoteDataSource.fetchBdos(parentCeoId: parentCeoId);
//
//   @override
//   Future<BdoModel> createBlock({
//     required String name,
//     required String token,
//     required int userId,
//   }) =>
//       remoteDataSource.createBlock(name: name, token: token, userId: userId);
//
//   @override
//   Future<Map<String, dynamic>> createBdoUser(Map<String, dynamic> body) =>
//       remoteDataSource.createBdoUser(body);
// }
