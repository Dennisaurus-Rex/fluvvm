import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluvvm/src/viewmodel.dart';
import 'package:provider/provider.dart';

/// A widget that is notified when the viewmodel changes.
abstract class NotifiedWidget<T extends Viewmodel> extends StatelessWidget {
  const NotifiedWidget({super.key, required this.viewmodel});
  final T viewmodel;

  void _bind(BuildContext context, T viewmodel) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      viewmodel.bind(context);
    });
  }

  /// Don't override this method.
  /// Use [buildOnNotified] instead.
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

  /// This method is called when the viewmodel changes.
  ///
  /// Use this method to build the widget based on the State
  /// provided by the viewmodel.
  Widget buildOnNotified(BuildContext context, T viewmodel);
}
