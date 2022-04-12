import 'dart:async';

import 'package:action_bloc/action_bloc.dart';
import 'package:action_bloc_test/action_bloc_test.dart';
import 'package:test/test.dart';

class CounterCubit extends ActionCubit<int, int> {
  CounterCubit() : super(0);

  void increment() {
    emit(state + 1);
    emitAction(state);
  }
}

void main() {
  group('actionBlocTest', () {
    group('CounterCubit', () {
      actionBlocTest<CounterCubit, int, int>(
        'supports matchers (contains)',
        build: CounterCubit.new,
        act: (bloc) => bloc.increment(),
        expect: () => contains(1),
        expectActions: () => contains(1),
      );

      actionBlocTest<CounterCubit, int, int>(
        'supports matchers (containsAll)',
        build: CounterCubit.new,
        act: (bloc) => bloc
          ..increment()
          ..increment(),
        expect: () => containsAll(<int>[2, 1]),
        expectActions: () => containsAll(<int>[2, 1]),
      );

      actionBlocTest<CounterCubit, int, int>(
        'supports matchers (containsAllInOrder)',
        build: CounterCubit.new,
        act: (bloc) => bloc
          ..increment()
          ..increment(),
        expect: () => containsAllInOrder(<int>[1, 2]),
        expectActions: () => containsAllInOrder(<int>[1, 2]),
      );

      actionBlocTest<CounterCubit, int, int>(
        'emits [] when nothing is added',
        build: CounterCubit.new,
        expect: () => const <int>[],
        expectActions: () => const <int>[],
      );

      actionBlocTest<CounterCubit, int, int>(
        'emits [1] when CounterEvent.increment is added',
        build: CounterCubit.new,
        act: (bloc) => bloc.increment(),
        expect: () => const <int>[1],
        expectActions: () => const <int>[1],
      );

      actionBlocTest<CounterCubit, int, int>(
        'emits [1] when CounterEvent.increment is added with async act',
        build: CounterCubit.new,
        act: (bloc) async {
          await Future<void>.delayed(const Duration(seconds: 1));
          bloc.increment();
        },
        expect: () => const <int>[1],
        expectActions: () => const <int>[1],
      );

      actionBlocTest<CounterCubit, int, int>(
        'emits [1, 2] when CounterEvent.increment is called multiple times '
        'with async act',
        build: CounterCubit.new,
        act: (bloc) async {
          bloc.increment();
          await Future<void>.delayed(const Duration(milliseconds: 10));
          bloc.increment();
        },
        expect: () => const <int>[1, 2],
        expectActions: () => const <int>[1, 2],
      );

      actionBlocTest<CounterCubit, int, int>(
        'emits [2] when CounterEvent.increment is added twice and skip: 1',
        build: CounterCubit.new,
        act: (bloc) => bloc
          ..increment()
          ..increment(),
        skip: 1,
        expect: () => const <int>[2],
        expectActions: () => const <int>[1, 2],
      );

      actionBlocTest<CounterCubit, int, int>(
        'emits [11] when CounterEvent.increment is added and emitted 10',
        build: CounterCubit.new,
        seed: () => 10,
        act: (bloc) => bloc.increment(),
        expect: () => const <int>[11],
        expectActions: () => const <int>[11],
      );

      actionBlocTest<CounterCubit, int, int>(
        'emits [11] when CounterEvent.increment is added and seed 10',
        build: CounterCubit.new,
        seed: () => 10,
        act: (bloc) => bloc.increment(),
        expect: () => const <int>[11],
        expectActions: () => const <int>[11],
      );

      // test('fails immediately when expectation is incorrect', () async {
      //   const expectedError = 'Expected: [2]\n'
      //       '  Actual: [1]\n'
      //       '   Which: at location [0] is <1> instead of <2>\n'
      //       '\n'
      //       '==== diff ========================================\n'
      //       '\n'
      //       '''\x1B[90m[\x1B[0m\x1B[31m[-2-]\x1B[0m\x1B[32m{+1+}\x1B[0m\x1B[90m]\x1B[0m\n'''
      //       '\n'
      //       '==== end diff ====================================\n';
      //   late Object actualError;
      //   final completer = Completer<void>();
      //   await runZonedGuarded(() async {
      //     unawaited(
      //       testBloc<CounterCubit, int>(
      //         build: CounterCubit.new,
      //         act: (bloc) => bloc.increment(),
      //         expect: () => const <int>[2],
      //       ).then((_) => completer.complete()),
      //     );
      //     await completer.future;
      //   }, (Object error, _) {
      //     actualError = error;
      //     if (!completer.isCompleted) completer.complete();
      //   });
      //   expect((actualError as TestFailure).message, expectedError);
      // });
      //
      //   test(
      //       'fails immediately when '
      //       'uncaught exception occurs within bloc', () async {
      //     late Object actualError;
      //     final completer = Completer<void>();
      //     await runZonedGuarded(() async {
      //       unawaited(testBloc<ErrorCounterCubit, int>(
      //         build: () => ErrorCounterCubit(),
      //         act: (bloc) => bloc.increment(),
      //         expect: () => const <int>[1],
      //       ).then((_) => completer.complete()));
      //       await completer.future;
      //     }, (Object error, _) {
      //       actualError = error;
      //       if (!completer.isCompleted) completer.complete();
      //     });
      //     expect(actualError, isA<ErrorCounterCubitError>());
      //   });
      //
      //   test('fails immediately when exception occurs in act', () async {
      //     final exception = Exception('oops');
      //     late Object actualError;
      //     final completer = Completer<void>();
      //     await runZonedGuarded(() async {
      //       unawaited(testBloc<ErrorCounterCubit, int>(
      //         build: () => ErrorCounterCubit(),
      //         act: (_) => throw exception,
      //         expect: () => const <int>[1],
      //       ).then((_) => completer.complete()));
      //       await completer.future;
      //     }, (Object error, _) {
      //       actualError = error;
      //       if (!completer.isCompleted) completer.complete();
      //     });
      //     expect(actualError, exception);
      //   });
    });
  });
}
