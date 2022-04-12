import 'dart:async';

import 'package:action_bloc/action_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

/// Analog to bloc's BlocListenerSingleChildWidget for [ActionBlocBase]s
mixin ActionBlocListenerSingleChildWidget on SingleChildWidget {}

/// Analog to the [BlocWidgetListener] for [ActionBlocBase]s
typedef ActionBlocWidgetListener<A> = void Function(
  BuildContext context,
  A action,
);

/// {@template bloc_listener}
/// Analog to the [BlocListener] for [ActionBlocBase]s
/// {@endtemplate}
class ActionBlocListener<B extends ActionBlocBase<dynamic, A>, A>
    extends ActionBlocListenerBase<B, A>
    with ActionBlocListenerSingleChildWidget {
  /// {@macro bloc_listener}
  /// {@macro bloc_listener_listen_when}
  const ActionBlocListener({
    Key? key,
    required ActionBlocWidgetListener<A> listener,
    B? bloc,
    Widget? child,
  }) : super(
          key: key,
          child: child,
          listener: listener,
          bloc: bloc,
        );
}

/// {@template bloc_listener_base}
/// Analog to the [BlocListenerBase] for [ActionBlocBase]s
/// {@endtemplate}
abstract class ActionBlocListenerBase<B extends ActionBlocBase<dynamic, A>, A>
    extends SingleChildStatefulWidget {
  /// {@macro bloc_listener_base}
  const ActionBlocListenerBase({
    Key? key,
    required this.listener,
    this.bloc,
    this.child,
  }) : super(key: key, child: child);

  /// The widget which will be rendered as a descendant of the
  /// [ActionBlocListenerBase].
  final Widget? child;

  /// The [bloc] whose `actions` will be listened to.
  /// Whenever a new `action` is emitted, [listener] will be invoked.
  final B? bloc;

  /// The [ActionBlocWidgetListener] which will be called on every new `action`.
  /// This [listener] should be used for any code which needs to execute
  /// in response to a new `action`.
  final ActionBlocWidgetListener<A> listener;

  @override
  SingleChildState<ActionBlocListenerBase<B, A>> createState() =>
      _ActionBlocListenerBaseState<B, A>();
}

class _ActionBlocListenerBaseState<B extends ActionBlocBase<dynamic, A>, A>
    extends SingleChildState<ActionBlocListenerBase<B, A>> {
  StreamSubscription<A>? _subscription;
  late B _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _subscribe();
  }

  @override
  void didUpdateWidget(ActionBlocListenerBase<B, A> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;
    if (oldBloc != currentBloc) {
      if (_subscription != null) {
        _unsubscribe();
        _bloc = currentBloc;
      }
      _subscribe();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.bloc ?? context.read<B>();
    if (_bloc != bloc) {
      if (_subscription != null) {
        _unsubscribe();
        _bloc = bloc;
      }
      _subscribe();
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      child != null,
      '''${widget.runtimeType} used outside of MultiBlocListener must specify a child''',
    );
    if (widget.bloc == null) {
      // Trigger a rebuild if the bloc reference has changed.
      // See https://github.com/felangel/bloc/issues/2127.
      context.select<B, bool>((bloc) => identical(_bloc, bloc));
    }
    return child!;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _subscription = _bloc.actions.listen((state) {
      widget.listener(context, state);
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
