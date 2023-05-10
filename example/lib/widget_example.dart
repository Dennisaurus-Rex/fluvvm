import 'package:flutter/material.dart';
import 'package:fluvvm/fluvvm.dart';
import 'viewmodel_example.dart';

class MyWidget extends NotifiedWidget<ExampleViewmodel> {
  const MyWidget({super.key, required super.viewmodel});

  @override
  Widget buildOnNotified(BuildContext context, ExampleViewmodel viewmodel) {
    switch (viewmodel.state) {
      case ExampleState.loading:
        return const Center(child: CircularProgressIndicator());
      case ExampleState.content:
        return CustomScrollView(
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
        );
      case ExampleState.error:
        return const Center(child: Text('Error'));
    }
  }
}
