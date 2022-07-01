import 'package:nike_store/data/product.dart';

class CreateOrderResult {
  final int orderId;
  final String bankGatewayUrl;

  CreateOrderResult.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGatewayUrl = json['bank_gateway_url'];
}

class CreateOrderParams {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String postalCode;
  final String address;
  final PaymentMethod paymentMethod;

  CreateOrderParams(this.firstName, this.lastName, this.phoneNumber,
      this.postalCode, this.address, this.paymentMethod);
}

enum PaymentMethod {
  online,
  cashOnDelivery,
}

class OrderEntity {
  final int id;
  final int payablePrice;
  final List<ProductEntity> products;

  OrderEntity(this.id, this.payablePrice, this.products);

  OrderEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        payablePrice = json['payable'],
        products = (json['order_items'] as List)
            .map(
              (item) => ProductEntity.fromJson(item['product']),
            )
            .toList();
}
