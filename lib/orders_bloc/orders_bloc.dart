import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends HydratedBloc<OrdersEvent, OrdersState> {
  OrdersBloc()
      : super(
          const OrdersState(
            orders: <String>[],
          ),
        ) {
    on<AddOrder>(
      _addOrder,
    );
    on<RemoveOrder>(
      _removeOrder,
    );
    on<EraseOrders>(
      _eraseOrders,
    );
  }

  final _storageKey = 'orders';

  void _addOrder(
    AddOrder event,
    Emitter<OrdersState> emit,
  ) {
    final containsOrder = state.orders.contains(
      event.order,
    );
    if (containsOrder || event.order.isEmpty) {
      return;
    }
    emit(
      OrdersState(
        orders: <String>[
          ...state.orders,
          event.order,
        ],
      ),
    );
  }

  void _removeOrder(
    RemoveOrder event,
    Emitter<OrdersState> emit,
  ) {
    final filteredList = state.orders.where(
      (
        String element,
      ) {
        return element != event.order;
      },
    ).toList();
    emit(
      OrdersState(
        orders: filteredList,
      ),
    );
  }

  void _eraseOrders(
    EraseOrders event,
    Emitter<OrdersState> emit,
  ) {
    emit(
      const OrdersState(
        orders: <String>[],
      ),
    );
  }

  @override
  OrdersState? fromJson(
    Map<String, dynamic> json,
  ) {
    final orders = (json[_storageKey] as List<String>?) ?? <String>[];
    return OrdersState(
      orders: orders,
    );
  }

  @override
  Map<String, dynamic>? toJson(
    OrdersState state,
  ) {
    return {
      _storageKey: state.orders,
    };
  }
}
