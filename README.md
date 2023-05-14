# fluvvm

## Introduction

Fluvvm is a lightweight library that removes some boilerplate code from your Flutter apps that is using `provider` and the `MVVM` architecture. Also includes a `NetworkRequest` class that makes it a piece of cake to make network requests.

## Why?

I really enjoy working with Flutter and the amazing library known as `provider` in combanation with my favorite arcitechture `MVVM`. However, I found myself writing the same code over and over again and that the MVVM pattern wasn't a given. So I decided to create a library that removes some of the boilerplate code and makes a clearer destinction between the network, business and ui layers.

## How to use

### 1. Create a `Repository`

```dart
class MyRepository {
  String baseUrl = 'https://example.com';
  String path = '/api/v1/data';

  late NetworkRequest fetchRequest = NetworkRequest(
    baseUrl: baseUrl,
    path: path,
    query: {'id': '1'},
  );

  Future<Map<String, dynamic>> store(Object data) async {
    try {
      final request = NetworkRequest(
        baseUrl: baseUrl,
        path: path,
        method: NetworkMethod.post,
      );
      return await request.fire(body: data);
    } catch (e) {
      rethrow;
    }
  }
}
```

### 2. Create a `ViewModel` with a `FluvvmState` and `FluvvmIntent`

```dart
class MyViewmodel extends Viewmodel<ExampleState, ExampleIntent> {
  final _repository = ExampleRepository();

  List<Object> get content => _content;
  List<Object> _content = [];

  @override
  void onBound() {
    setState(ExampleState.loading);
    unawaited(_fetchData());
  }

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
}

enum ExampleState implements FluvvmState {
  loading,
  content,
  error;
}

enum ExampleIntent with FluvvmIntent {
  fetchData,
  storeData,
  navigateToWidget,
}
```

### 3. Create a `Widget` that extends `NotifiedWidget`

```dart
class MyWidget extends NotifiedWidget<ExampleViewmodel> {
  const MyWidget({super.key, required super.viewmodel});

  @override
  Widget buildOnNotified(BuildContext context, ExampleViewmodel viewmodel) {
    return switch (viewmodel.state) {
      ExampleState.loading => const Center(child: CircularProgressIndicator()),
      ExampleState.content => CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text('MyWidget'),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ListTile(
                  title: Text(viewmodel.content[index].toString()),
                  onTap: () => viewmodel.raiseIntent(
                    ExampleIntent.storeData,
                    data: {'newData': index},
                  ),
                ),
                childCount: viewmodel.content.length,
              ),
            ),
          ],
        ),
      ExampleState.error => const Center(child: Text('Error'))
    };
  }
}
```

## NetworkRequest

### Get

```dart
/// Simple get request.
Future<Map<String, dynamic>> get(
  String id,
  Map<String, String>? headers,
) async {
  try {
    final request = NetworkRequest(
      baseUrl: 'https://example.com',
      path: '/api/v1/data',
      query: {'id': id},
    );
    return await request.fire(headers: headers);
  } catch (e) {
    rethrow;
  }
}

/// Simple get with map request.
Future<MyResponseModel> getWithMap(String id) async {
  try {
    final request = NetworkRequest(
      baseUrl: 'https://example.com',
      path: '/api/v1/data',
      query: {'id': id},
    );
    return await request.fireAndMap(MyResponseModel.fromJson);
  } catch (e) {
    rethrow;
  }
}
```

### Post

```dart
Future<Map<String, dynamic>> post(Object data) async {
  try {
    final request = NetworkRequest(
      baseUrl: 'https://example.com',
      path: '/api/v1/data',
      method: NetworkMethod.post,
    );
    return await request.fire(body: data);
  } catch (e) {
    rethrow;
  }
}
```

### Put

```dart
Future<Map<String, dynamic>> put(Object data) async {
  try {
    final request = NetworkRequest(
      baseUrl: 'https://example.com',
      path: '/api/v1/data',
      method: NetworkMethod.put,
    );
    return await request.fire(body: data);
  } catch (e) {
    rethrow;
  }
}
```

### Delete

```dart
/// Simple delete request.
Future<Map<String, dynamic>> delete(String id, Object? data) async {
  try {
    final request = NetworkRequest(
      baseUrl: 'https://example.com',
      path: '/api/v1/data',
      method: NetworkMethod.delete,
      query: {'id': id},
    );
    return await request.fire(body: data);
  } catch (e) {
    rethrow;
  }
}
```
