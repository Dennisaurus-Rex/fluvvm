import 'package:flutter/material.dart';
import 'package:fluvvm/fluvvm.dart';
import 'viewmodel_example.dart';

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
