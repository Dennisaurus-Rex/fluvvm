import 'package:flutter/material.dart';
import 'package:fluvvm/fluvvm.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluvvm Demo',
      home: MyHomePage(
        viewmodel: MyViewmodel(),
      ),
    );
  }
}

/// Example implementation of a [Viewmodel]. Used in [MyHomePage].
class MyViewmodel extends Viewmodel<MyState, MyIntent> {
  MyViewmodel();

  String get content => _counter.toString();
  late int _counter;

  @override
  void bind(BuildContext context) {
    _counter = 0;
    setState(MyState.content);
    super.bind(context);
  }

  @override
  void raiseIntent(MyIntent intent, {Object? data}) {
    switch (intent) {
      case MyIntent.increment:
        _counter++;
        setState(MyState.content);
        break;
    }
  }
}

/// Example implementation of [FluvvmIntent].
/// Used by [MyHomePage] to notify [MyViewmodel] about user interactions.
enum MyIntent with FluvvmIntent {
  increment,
}

/// Example implementation of [FluvvmState].
/// Used in [MyViewmodel] to notify [MyHomePage] about changes.
enum MyState with FluvvmState {
  loading,
  content,
}

/// Example implementation of [NotifiedWidget].
/// Interacts with [MyViewmodel] via [MyIntent].
/// Rebuilds when [MyViewmodel] notifies about changes via [MyState].
class MyHomePage extends NotifiedWidget<MyViewmodel> {
  const MyHomePage({super.key, required super.viewmodel});

  @override
  Widget buildOnNotified(BuildContext context, MyViewmodel viewmodel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyWidget'),
      ),
      body: Center(
        child: Text(viewmodel.content),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewmodel.raiseIntent(MyIntent.increment),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
