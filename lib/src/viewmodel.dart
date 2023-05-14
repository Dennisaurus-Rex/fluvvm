// ignore_for_file: comment_references

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Viewmodel to be attached/bound to a [NotifiedWidget].
///
/// When calling [setState] the [NotifiedWidget] will be notified
/// and rebuild.
abstract class Viewmodel<S extends FluvvmState, I extends FluvvmIntent>
    extends ChangeNotifier {
  bool get isBound => _isBound;
  bool _isBound = false;

  /// Get the current state.
  S get state {
    final state = _state;
    if (state == null) {
      throw Exception(
        'State is null. Did you forget to set it in onBound?',
      );
    }

    return state;
  }

  /// Do not set the state directly.
  /// Use [setState] instead.
  @nonVirtual
  S? _state;

  /// Get the current context of the [NofifiedWidget].
  @protected
  BuildContext get context => _context;
  late BuildContext _context;

  /// Do initial setup here.
  ///
  /// Called once [bind] has bound the viewmodel to the view.
  ///
  /// Good place to initialize the state.
  @protected
  void onBound();

  /// Called before viewmodel gets disposed.
  ///
  /// Default implementation does nothing.
  ///
  /// Override this method to dispose resources.
  @protected
  void onUnbind() {}

  /// Binds the viewmodel to the view.
  ///
  /// This method is called by the [NofifiedWidget].
  /// Do not call this method directly.
  ///
  /// This method is called only once.
  ///
  /// Stores the [BuildContext] for later use.
  @mustCallSuper
  void bind(BuildContext context) {
    if (_isBound) {
      throw Exception(
        'Viewmodel is already bound.',
      );
    }

    _context = context;
    _isBound = true;
    onBound();
  }

  /// This method is called by the [NofifiedWidget] to raise an intent.
  ///
  /// It is recomended to create an enum with all the intents.
  /// enum with [FluvvmIntent] {}
  ///
  /// Example: [Viewmodel].raiseIntent([FluvvmIntent].NavigateToWidget)
  /// Example: [Viewmodel].raiseIntent([FluvvmIntent].FetchData)
  /// Example: [Viewmodel].raiseIntent([FluvvmIntent].StoreData)
  /// Example: [Viewmodel].raiseIntent([FluvvmIntent].ShowDialog)
  void raiseIntent(I intent, {Object? data});

  /// Viewmodel calls this method to update the state and notify the Widget.
  @protected
  @mustCallSuper
  void setState(S state) {
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    onUnbind();
    _isBound = false;
    super.dispose();
  }
}

/// Use this mixin to create a state enum.
/// `MyState with FluvvmState { ... }`
mixin FluvvmState {}

/// Use this mixin to create an intent enum.
/// `MyIntent with FluvvmIntent { ... }`
mixin FluvvmIntent {}
