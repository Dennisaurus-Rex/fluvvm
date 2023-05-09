import 'package:flutter/material.dart';
import 'package:fluvvm/fluvvm.dart';

void main() {
  runApp(const MyApp());
}

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

enum MyIntent with FluvvmIntent {
  increment,
}

enum MyState with FluvvmState {
  loading,
  content,
}

class MyHomePage extends NofifiedWidget<MyViewmodel> {
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
