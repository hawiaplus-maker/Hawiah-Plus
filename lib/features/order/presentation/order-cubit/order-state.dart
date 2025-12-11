import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:hawiah_client/features/order/presentation/model/single_order_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderSuccess extends OrderState {
  final OrdersModel? ordersModel;
  OrderSuccess({this.ordersModel});
}

class OrderLoading extends OrderState {}

class OrderPaginationLoading extends OrderState {}

class OrderChange extends OrderState {}

class OrderRebuild extends OrderState {}

class OrderError extends OrderState {}

class CurrentOrderEmpty extends OrderState {}

class OldOrderEmpty extends OrderState {}

class Unauthenticated extends OrderState {}

class CurrentOrderLoaded extends OrderState {
  final SingleOrderModel order;
  CurrentOrderLoaded(this.order);
}

class CurrentOrderError extends OrderState {
  final String message;
  CurrentOrderError(this.message);
}

class CurrentOrderLoading extends OrderState {}
