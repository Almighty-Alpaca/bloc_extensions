import 'package:action_bloc/action_bloc.dart';
import 'package:action_bloc_test/action_bloc_test.dart';

class CounterCubit extends ActionCubit<int, int> {
  CounterCubit() : super(0);

  void addAction(int action) => emitAction(action);
}

void main() {
  actionBlocTest<CounterCubit, int, int>(
    'test emit none',
    build: CounterCubit.new,
    expectActions: () => <int>[],
  );

  final testActions = List.generate(20, (i) => i);

  actionBlocTest<CounterCubit, int, int>(
    'test emit in order',
    build: CounterCubit.new,
    act: (bloc) => testActions.forEach(bloc.addAction),
    expectActions: () => testActions,
  );
}
