// ignore_for_file: comment_references

import 'package:flutter/material.dart';

abstract class Viewmodel<S extends FluvvmState, I extends FluvvmIntent>
    extends ChangeNotifier {
  bool get isBound => _isBound;
  bool _isBound = false;

  /// Get the current state.
  S get state => _state;

  /// The optional inital state of the viewmodel.
  /// [_state] is set to [initialState] if `initialState != null`
  /// when [bind] is called by the [NofifiedWidget].
  S? get initialState;

  /// Set the current state.
  /// Do not set the state directly.
  /// Use [setState] instead.
  @protected
  late S _state;

  /// Get the current context of the [NofifiedWidget].
  @protected
  BuildContext get context => _context;
  late BuildContext _context;

  /// Binds the viewmodel to the view.
  /// Do initial setup here.
  ///
  /// This method is called by the [NofifiedWidget].
  /// Do not call this method directly.
  ///
  /// This method is called only once.
  ///
  /// Stores the [BuildContext] for later use.
  void bind(BuildContext context) {
    _context = context;
    final initialState = this.initialState;
    if (initialState != null) {
      _state = initialState;
    }

    _isBound = true;
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
  void setState(S state) {
    _state = state;
    notifyListeners();
  }
}

mixin FluvvmState {}

mixin FluvvmIntent {}
