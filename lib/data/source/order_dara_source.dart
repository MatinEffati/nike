import 'package:dio/dio.dart';
import 'package:nike_store/data/order.dart';
import 'package:nike_store/data/payment_receipt.dart';

abstract class IOrderDataSource {
  Future<CreateOrderResult> submitOrder(CreateOrderParams params);

  Future<PaymentReceipt> getPaymentReceipt(int orderId);

  Future<List<OrderEntity>> getOrders();
}

class OrderRemoteDataSource implements IOrderDataSource {
  final Dio httpClient;

  OrderRemoteDataSource(this.httpClient);

  @override
  Future<CreateOrderResult> submitOrder(CreateOrderParams params) async {
    final response = await httpClient.post('order/submit', data: {
      'first_name': params.firstName,
      'last_name': params.lastName,
      'mobile': params.phoneNumber,
      'postal_code': params.postalCode,
      'address': params.address,
      'payment_method': params.paymentMethod == PaymentMethod.online
          ? 'online'
          : 'cash_on_delivery',
    });
    return CreateOrderResult.fromJson(response.data);
  }

  @override
  Future<PaymentReceipt> getPaymentReceipt(int orderId) async {
    final response = await httpClient.get('order/checkout?order_id=$orderId');
    return PaymentReceipt.fromJson(response.data);
  }

  @override
  Future<List<OrderEntity>> getOrders() async {
    final response = await httpClient.get('order/list');
    return (response.data as List)
        .map((item) => OrderEntity.fromJson(item))
        .toList();
  }
}