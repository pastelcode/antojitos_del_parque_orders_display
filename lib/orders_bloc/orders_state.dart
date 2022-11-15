part of 'orders_bloc.dart';

class OrdersState extends Equatable {
  const OrdersState({
    required this.orders,
  });

  final List<String> orders;

  @override
  List<Object> get props => [
        orders,
      ];
}
