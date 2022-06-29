import 'package:dio/dio.dart';
import 'package:nike_store/data/banner.dart';
import 'package:nike_store/data/common/http_client.dart';
import 'package:nike_store/data/common/http_response_validator.dart';
import 'package:nike_store/data/repo/banner_repository.dart';


final bannerRepository = BannerRepository(BannerRemoteDataSource(httpClient));

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getAll();
}

class BannerRemoteDataSource
    with HttpResponseValidator
    implements IBannerDataSource {

  final Dio httpClient;

  BannerRemoteDataSource(this.httpClient);

  @override
  Future<List<BannerEntity>> getAll() async {
    final response = await httpClient.get('banner/slider');
    validateResponse(response);
    final List<BannerEntity> banners = [];
    (response.data as List).forEach((element) {
      banners.add(BannerEntity.fromJson(element));
    });
    return banners;
  }
}
