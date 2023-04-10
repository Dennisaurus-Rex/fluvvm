import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluvvm/src/viewmodel.dart';
import 'package:provider/provider.dart';

/// A widget that is notified when the viewmodel changes.
abstract class NofifiedWidget<T extends Viewmodel> extends StatelessWidget {
  const NofifiedWidget({super.key, required this.viewmodel});
  final T viewmodel;

  void _bind(BuildContext context, T viewmodel) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      viewmodel.bind(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => viewmodel,
      builder: (context, child) => Consumer<T>(
        builder: (context, viewmodel, child) {
          if (!viewmodel.isBound) {
            _bind(context, viewmodel);
            return const SizedBox.shrink();
          }
          return buildOnNotified(context, viewmodel);
        },
      ),
    );
  }

  Widget buildOnNotified(BuildContext context, T viewmodel);
}
