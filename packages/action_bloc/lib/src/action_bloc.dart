// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

abstract class ActionStreamable<Action> {
  Stream<Action> get actions;
}

// ignore: one_member_abstracts
abstract class ActionEmittable<Action> {
  @protected
  void emitAction(Action action);
}

abstract class ActionBlocBase<State, Action>
    implements
        BlocBase<State>,
        ActionStreamable<Action>,
        ActionEmittable<Action> {
  @visibleForTesting
  StreamController<Action> get actionController;
}

mixin ActionBlocMixin<State, Action> on BlocBase<State>
    implements ActionBlocBase<State, Action> {
  final _actionController = StreamController<Action>.broadcast();

  @override
  Stream<Action> get actions => _actionController.stream;

  @override
  @visibleForTesting
  StreamController<Action> get actionController => _actionController;

  @override
  @protected
  void emitAction(Action action) => _actionController.add(action);

  @mustCallSuper
  @override
  Future<void> close() async {
    await super.close();
    await _actionController.close();
  }
}

abstract class ActionBloc<Event, State, Action> extends Bloc<Event, State>
    with ActionBlocMixin<State, Action> {
  ActionBloc(State initialState) : super(initialState);
}

abstract class ActionCubit<State, Action> extends Cubit<State>
    with ActionBlocMixin<State, Action> {
  ActionCubit(State initialState) : super(initialState);
}
