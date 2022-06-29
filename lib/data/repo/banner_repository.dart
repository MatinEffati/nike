import 'package:nike_store/data/banner.dart';
import 'package:nike_store/data/source/banner_data_source.dart';

abstract class IBannerRepository {
  Future<List<BannerEntity>> getAll();
}

class BannerRepository implements IBannerRepository {
  final BannerRemoteDataSource datasource;

  BannerRepository(this.datasource);

  @override
  Future<List<BannerEntity>> getAll() => datasource.getAll();
}
