// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

B useBloc<B extends BlocBase<dynamic>>() {
  return useContext().read<B>();
}

S useBlocState<B extends BlocBase<S>, S>() {
  return useContext().watch<B>().state;
}

/// Signature for the `selector` function which
/// is responsible for returning a selected value, [T], based on [state].
typedef BlocWidgetSelector<S, T> = T Function(S state);

T useBlocSelector<B extends BlocBase<S>, S, T>(
  BlocWidgetSelector<S, T> selector,
) {
  return useContext().select<B, T>((B bloc) => selector(bloc.state));
}

/// Signature for the `listener` function which takes the `BuildContext` along
/// with the `state` and is responsible for executing in response to
/// `state` changes.
typedef BlocWidgetListener<S> = void Function(BuildContext context, S state);

void useBlocListener<B extends BlocBase<S>, S>(
  BlocWidgetListener<S> listener,
) {
  final context = useContext();
  final bloc = useBloc<B>();

  useEffect(
    () {
      return bloc.stream.listen((state) {
        listener(context, state);
      }).cancel;
    },
    [bloc, listener],
  );
}
