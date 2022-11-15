import 'package:antojitos_del_parque_orders_display/orders_bloc/orders_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // |- Set up Hydrated Bloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  // Set up Hydrated Bloc -|

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (
            BuildContext context,
          ) {
            return OrdersBloc();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Orders Display',
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.dark,
        ),
        home: const MainDisplay(),
      ),
    );
  }
}

class MainDisplay extends StatefulWidget {
  const MainDisplay({
    super.key,
  });

  @override
  State<MainDisplay> createState() => _MainDisplayState();
}

class _MainDisplayState extends State<MainDisplay> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _addOrder({
    required String order,
  }) {
    context.read<OrdersBloc>().add(
          AddOrder(
            order: order,
          ),
        );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(
            child: SizedBox(
              width: 500,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (
                        String value,
                      ) {
                        _addOrder(
                          order: value,
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _addOrder(
                        order: _controller.text,
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<OrdersBloc, OrdersState>(
            builder: (
              BuildContext context,
              OrdersState state,
            ) {
              if (state.orders.isEmpty) {
                return const Center(
                  child: Text(
                    '...',
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.orders.length,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    return Text(
                      state.orders[index],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
