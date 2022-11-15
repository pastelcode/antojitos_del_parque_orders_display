import 'package:antojitos_del_parque_orders_display/orders_bloc/orders_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    focusNode.dispose();

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
    _controller.clear();
    focusNode.requestFocus();
  }

  void _removeOrder({
    required String order,
  }) {
    context.read<OrdersBloc>().add(
          RemoveOrder(
            order: order,
          ),
        );
    focusNode.requestFocus();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(
          context,
        ).colorScheme.surface,
        toolbarHeight: 95,
        leadingWidth: 150,
        leading: SvgPicture.asset(
          'assets/logo.svg',
          color: Theme.of(
            context,
          ).colorScheme.onSurface,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 500,
              child: TextField(
                controller: _controller,
                autofocus: true,
                focusNode: focusNode,
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
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (
              BuildContext context,
            ) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: () {
                    context.read<OrdersBloc>().add(
                          const EraseOrders(),
                        );
                  },
                  child: Row(
                    children: const <Widget>[
                      Icon(
                        Icons.replay,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Reset',
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (
          BuildContext context,
          OrdersState state,
        ) {
          if (state.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    '...',
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                return GestureDetector(
                  onDoubleTap: () {
                    _removeOrder(
                      order: state.orders[index],
                    );
                  },
                  child: Text(
                    state.orders[index],
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
