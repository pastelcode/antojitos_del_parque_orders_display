part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class AddOrder extends OrdersEvent {
  const AddOrder({
    required this.order,
  });

  final String order;

  @override
  List<Object> get props => [
        order,
      ];
}

class RemoveOrder extends OrdersEvent {
  const RemoveOrder({
    required this.order,
  });

  final String order;

  @override
  List<Object> get props => [
        order,
      ];
}

class EraseOrders extends OrdersEvent {
  const EraseOrders();
}
