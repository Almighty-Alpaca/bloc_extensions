// ignore_for_file: public_member_api_docs

import 'package:action_bloc/action_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_hooks/flutter_bloc_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef ActionBlocWidgetListener<A> = void Function(
  BuildContext context,
  A action,
);

void useBlocActionListener<B extends ActionBlocBase<dynamic, A>, A>(
  ActionBlocWidgetListener<A> listener,
) {
  final context = useContext();
  final bloc = useBloc<B>();

  useEffect(
    () {
      return bloc.actions.listen((state) {
        listener(context, state);
      }).cancel;
    },
    [bloc, listener],
  );
}
