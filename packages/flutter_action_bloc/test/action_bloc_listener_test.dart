import 'package:action_bloc/action_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_action_bloc/flutter_action_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class CounterCubit extends ActionCubit<int, int> {
  CounterCubit() : super(0);

  void increment() {
    emit(state + 1);
    emitAction(state);
  }
}

void main() {
  group('ActionBlocListener', () {
    testWidgets('throws AssertionError when child is not specified',
        (tester) async {
      const expected =
          '''ActionBlocListener<CounterCubit, int> used outside of MultiBlocListener must specify a child''';

      await tester.pumpWidget(
        ActionBlocListener<CounterCubit, int>(
          bloc: CounterCubit(),
          listener: (context, action) {},
        ),
      );

      expect(
        tester.takeException(),
        isA<AssertionError>().having((e) => e.message, 'message', expected),
      );
    });

    testWidgets('renders child', (tester) async {
      const targetKey = Key('child');

      await tester.pumpWidget(
        ActionBlocListener<CounterCubit, int>(
          bloc: CounterCubit(),
          listener: (_, __) {},
          child: const SizedBox(key: targetKey),
        ),
      );

      expect(find.byKey(targetKey), findsOneWidget);

      expect(tester.takeException(), equals(null));
    });

    testWidgets('calls listener on single action change', (tester) async {
      final counterCubit = CounterCubit();
      final actions = <int>[];
      const expectedActions = [1];
      await tester.pumpWidget(
        ActionBlocListener<CounterCubit, int>(
          bloc: counterCubit,
          listener: (_, action) {
            actions.add(action);
          },
          child: const SizedBox(),
        ),
      );
      counterCubit.increment();
      await tester.pump();
      expect(actions, expectedActions);

      expect(tester.takeException(), equals(null));
    });

    testWidgets('calls listener on multiple action change', (tester) async {
      final counterCubit = CounterCubit();
      final actions = <int>[];
      const expectedActions = [1, 2];
      await tester.pumpWidget(
        ActionBlocListener<CounterCubit, int>(
          bloc: counterCubit,
          listener: (_, action) {
            actions.add(action);
          },
          child: const SizedBox(),
        ),
      );
      counterCubit.increment();
      await tester.pump();
      counterCubit.increment();
      await tester.pump();
      expect(actions, expectedActions);

      expect(tester.takeException(), equals(null));
    });

    testWidgets(
        'updates when the cubit is changed at runtime to a different cubit '
        'and unsubscribes from old cubit', (tester) async {
      final counterCubit1 = CounterCubit();
      final counterCubit2 = CounterCubit();

      var invocations = 0;
      var latestAction = 0;

      Widget widget(CounterCubit cubit) {
        return ActionBlocListener<CounterCubit, int>(
          bloc: cubit,
          listener: (_, action) {
            invocations++;
            latestAction = action;
          },
          child: const SizedBox(),
        );
      }

      await tester.pumpWidget(widget(counterCubit1));

      counterCubit1.increment();
      await tester.pump();
      expect(invocations, 1);
      expect(latestAction, 1);

      counterCubit1.increment();
      await tester.pump();
      expect(invocations, 2);
      expect(latestAction, 2);

      await tester.pumpWidget(widget(counterCubit2));

      counterCubit2.increment();
      await tester.pump();
      expect(invocations, 3);
      expect(latestAction, 1);

      expect(tester.takeException(), equals(null));
    });
  });
}
