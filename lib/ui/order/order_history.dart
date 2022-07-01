import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/exception.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/repo/order_repository.dart';
import 'package:nike_store/ui/order/bloc/order_history_bloc.dart';
import 'package:nike_store/ui/widgets/error.dart';
import 'package:nike_store/ui/widgets/image.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderHistoryBloc(orderRepository)..add(OrderHistoryStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سوابق سفارش'),
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistorySuccess) {
              final orders = state.orders;
              return ListView.builder(
                physics: defaultScrollPhysics,
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Theme.of(context).dividerColor, width: 1),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('شناسه سفارش'),
                              Text(order.id.toString()),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('مبلغ'),
                              Text(order.payablePrice.withPriceLabel),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        SizedBox(
                          height: 132,
                          child: ListView.builder(
                            physics: defaultScrollPhysics,
                            scrollDirection: Axis.horizontal,
                            itemCount: order.products.length,
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            itemBuilder: (context, index) {
                              return Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.only(left: 4,right: 4),
                                child: ImageLoadingService(borderRadius: BorderRadius.circular(8),imageUrl:order.products[index].imageUrl),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            } else if (state is OrderHistoryError) {
              return AppErrorWidget(
                  exception: AppException(), onPressed: () {});
            } else {
              return AppErrorWidget(
                  exception: AppException(), onPressed: () {});
            }
          },
        ),
      ),
    );
  }
}
