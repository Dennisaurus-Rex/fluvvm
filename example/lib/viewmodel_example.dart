import 'dart:async';

import 'package:fluvvm/fluvvm.dart';
import 'repository_example.dart';

class ExampleViewmodel extends Viewmodel<ExampleState, ExampleIntent> {
  ExampleViewmodel();

  final _repository = ExampleRepository();

  List<Object> get content => _content;
  List<Object> _content = [];

  @override
  void raiseIntent(ExampleIntent intent, {Object? data}) {
    switch (intent) {
      case ExampleIntent.fetchData:
        setState(ExampleState.loading);
        unawaited(_fetchData());
        break;
      case ExampleIntent.storeData:
        setState(ExampleState.loading);
        unawaited(_storeData(data));
        break;
      case ExampleIntent.navigateToWidget:
        // Navigate to a new widget and pass data if needed.
        break;
    }
  }

  Future<void> _fetchData() async {
    try {
      final map = await _repository.fetchRequest.fire();
      _content = _modifyDataBeforeServingToWidget(map);
      setState(ExampleState.content);
    } catch (e) {
      setState(ExampleState.error);
    }
  }

  Future<void> _storeData(Object? data) async {
    final thisData = data;
    if (thisData == null) {
      setState(ExampleState.error);
      return;
    }

    try {
      final map = await _repository.store(thisData);
      _modifyDataBeforeServingToWidget(map);
      setState(ExampleState.content);
    } catch (e) {
      setState(ExampleState.error);
    }
  }

  List<Object> _modifyDataBeforeServingToWidget(Map map) {
    return [];
  }

  @override
  ExampleState get initialState => ExampleState.loading;
}

enum ExampleState with FluvvmState {
  loading,
  content,
  error,
}

enum ExampleIntent with FluvvmIntent {
  fetchData,
  storeData,
  navigateToWidget,
}
