import 'package:nike_store/data/common/http_client.dart';
import 'package:nike_store/data/order.dart';
import 'package:nike_store/data/payment_receipt.dart';
import 'package:nike_store/data/source/order_dara_source.dart';

final orderRepository = OrderRepository(OrderRemoteDataSource(httpClient));

abstract class IOrderRepository extends IOrderDataSource {}

class OrderRepository extends IOrderRepository {
  final IOrderDataSource _dataSource;

  OrderRepository(this._dataSource);

  @override
  Future<CreateOrderResult> submitOrder(CreateOrderParams params) =>
      _dataSource.submitOrder(params);

  @override
  Future<PaymentReceipt> getPaymentReceipt(int orderId) => _dataSource.getPaymentReceipt(orderId);
}
