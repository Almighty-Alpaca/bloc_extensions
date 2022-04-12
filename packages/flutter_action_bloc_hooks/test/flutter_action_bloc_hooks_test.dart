import 'package:action_bloc/action_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_action_bloc_hooks/flutter_action_bloc_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';

class CounterCubit extends ActionCubit<int, int> {
  CounterCubit() : super(0);

  void increment() {
    emit(state + 1);
    emitAction(state);
  }
}

void main() {
  group('useBlocActionListener()', () {
    testWidgets('calls listener when Cubit emits state', (tester) async {
      final cubit = CounterCubit();

      var builds = 0;
      var invocations = 0;

      final widget = MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: HookBuilder(
            builder: (context) {
              useBlocActionListener<CounterCubit, int>(
                (context, state) {
                  invocations++;
                },
              );

              builds++;

              return const SizedBox();
            },
          ),
        ),
      );

      await tester.pumpWidget(widget);
      expect(invocations, equals(0));
      expect(builds, equals(1));

      cubit.increment();
      await tester.pumpWidget(widget);
      expect(builds, equals(1));

      cubit.increment();
      await tester.pumpWidget(widget);
      expect(builds, equals(1));

      expect(tester.takeException(), equals(null));
    });
  });
}
