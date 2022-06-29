import 'package:dio/dio.dart';
import 'package:nike_store/data/add_to_cart_response.dart';
import 'package:nike_store/data/cart_response.dart';
import 'package:nike_store/data/common/http_response_validator.dart';

abstract class ICartDataSource {
  Future<AddToCartResponse> add(int productId);

  Future<AddToCartResponse> changeCount(int cartItemId, int count);

  Future<void> delete(int cartIemId);

  Future<int> count();

  Future<CartResponse> getAll();
}

class CartRemoteDataSource extends ICartDataSource with HttpResponseValidator {
  final Dio httpClient;

  CartRemoteDataSource(this.httpClient);

  @override
  Future<AddToCartResponse> add(int productId) async {
    final response = await httpClient.post(
      'cart/add',
      data: {
        "product_id": productId,
      },
    );
    validateResponse(response);
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) async {
    final response = await httpClient.post('cart/changeCount', data: {
      "cart_item_id": cartItemId,
      "count": count,
    });
   //validateResponse(response.data);
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<int> count() async {
    final response = await httpClient.get('cart/count');
    validateResponse(response);
    return response.data['count'];
  }

  @override
  Future<void> delete(int cartIemId) async {
    await httpClient.post('cart/remove', data: {'cart_item_id': cartIemId});
  }

  @override
  Future<CartResponse> getAll() async {
    final response = await httpClient.get('cart/list');
    return CartResponse.fromJson(response.data);
  }
}
