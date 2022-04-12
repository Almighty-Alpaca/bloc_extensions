import 'package:action_bloc/action_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_action_bloc/src/action_bloc_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/// {@template multi_bloc_listener}
/// Analog to the [MultiBlocListener] for [ActionBlocBase]s
/// {@endtemplate}
class MultiActionBlocListener extends MultiProvider {
  /// {@macro multi_bloc_listener}
  MultiActionBlocListener({
    Key? key,
    required List<ActionBlocListenerSingleChildWidget> listeners,
    required Widget child,
  }) : super(key: key, providers: listeners, child: child);
}
