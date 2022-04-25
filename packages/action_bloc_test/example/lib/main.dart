import 'package:action_bloc/action_bloc.dart';
import 'package:action_bloc_test/action_bloc_test.dart';

class TestCubit extends ActionCubit<int, int> {
  TestCubit() : super(0);

  void increment() {
    emit(state + 1);

    if (state % 3 == 0) {
      emitAction(state);
    }
  }
}

void main() {
  actionBlocTest<TestCubit, int, int>(
    'test emit none',
    build: TestCubit.new,
    expectActions: () => <int>[],
  );

  const times = 30;

  actionBlocTest<TestCubit, int, int>(
    'test emit in order',
    build: TestCubit.new,
    act: (bloc) {
      for (var i = 0; i < times; i++) {
        bloc.increment();
      }
    },
    expect: () => <int>[for (var i = 1; i <= times; i++) i],
    expectActions: () => <int>[for (var i = 3; i <= times; i += 3) i],
  );
}
