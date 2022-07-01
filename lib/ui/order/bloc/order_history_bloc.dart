import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store/common/exception.dart';
import 'package:nike_store/data/order.dart';
import 'package:nike_store/data/repo/order_repository.dart';

part 'order_history_event.dart';

part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final IOrderRepository _repository;

  OrderHistoryBloc(this._repository) : super(OrderHistoryLoading()) {
    on<OrderHistoryEvent>((event, emit) async {
      if (event is OrderHistoryStarted) {
        try {
          emit(OrderHistoryLoading());
          final orders = await _repository.getOrders();
          emit(OrderHistorySuccess(orders));
        } catch (e) {
          emit(OrderHistoryError(AppException()));
        }
      }
    });
  }
}
