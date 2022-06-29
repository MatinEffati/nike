part of 'product_list_bloc.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

class ProductListLoading extends ProductListState {}

class ProductListSuccess extends ProductListState {
  final List<ProductEntity> products;
  final List<String> sortNames;
  final int sort;

  const ProductListSuccess(this.products, this.sort, this.sortNames);

  @override
  // TODO: implement props
  List<Object> get props => [products, sortNames, sort];
}

class ProductListError extends ProductListState {
  final AppException exception;

  const ProductListError(this.exception);

  @override
  List<Object> get props => [exception];
}
