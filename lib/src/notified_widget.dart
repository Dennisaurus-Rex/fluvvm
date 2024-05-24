import 'package:flutter/material.dart';
import 'package:fluvvm/src/viewmodel.dart';
import 'package:provider/provider.dart';

/// A widget that is notified when the viewmodel changes.
abstract class NotifiedWidget<T extends Viewmodel> extends StatelessWidget {
  const NotifiedWidget({
    super.key,
    required this.viewmodel,
    this.keepAlive = false,
  });

  /// The viewmodel that is bound to this widget.
  ///
  /// State changes of this viewmodel will trigger a rebuild of this widget.
  /// And the [buildOnNotified] method will be called.
  final T viewmodel;

  /// Whether to keep the state of this widget alive.
  ///
  /// If set to true, the state of this widget will be kept alive
  /// inside for example a [TabBarView] or [PageView]
  ///
  /// Default is `keepAlive = false`
  final bool keepAlive;

  void _bind(T viewmodel, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewmodel.bind(context);
    });
  }

  /// Don't override this method.
  /// Use [buildOnNotified] instead.
  @override
  Widget build(BuildContext context) {
    if (keepAlive) {
      return _buildKeepAlive(context);
    } else {
      return _build(context);
    }
  }

  /// This method is called when the viewmodel changes.
  ///
  /// Use this method to build the widget based on the State
  /// provided by the viewmodel.
  Widget buildOnNotified(BuildContext context, T viewmodel);

  Widget _buildKeepAlive(BuildContext context) =>
      ChangeNotifierProvider<T>.value(
        key: super.key,
        value: viewmodel,
        builder: (context, child) => Consumer<T>(
          builder: (context, viewmodel, child) {
            if (!viewmodel.isBound) {
              _bind(viewmodel, context);
              return const SizedBox.shrink();
            }
            return buildOnNotified(context, viewmodel);
          },
        ),
      );

  Widget _build(BuildContext context) => ChangeNotifierProvider<T>(
        key: super.key,
        create: (context) => viewmodel,
        builder: (context, child) => Consumer<T>(
          builder: (context, viewmodel, child) {
            if (!viewmodel.isBound) {
              _bind(viewmodel, context);
              return const SizedBox.shrink();
            }
            return buildOnNotified(context, viewmodel);
          },
        ),
      );
}
