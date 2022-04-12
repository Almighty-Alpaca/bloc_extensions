import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_hooks/flutter_bloc_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
}

void main() {
  group('useBloc()', () {
    testWidgets('does not update widget when Cubit emits state',
        (tester) async {
      final cubit = CounterCubit();

      var builds = 0;

      final widget = MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: HookBuilder(
            builder: (context) {
              final cubit = useBloc<CounterCubit>();

              builds++;

              return Text('${cubit.state}');
            },
          ),
        ),
      );

      await tester.pumpWidget(widget);
      expect(find.text('0'), findsOneWidget);
      expect(builds, equals(1));

      cubit.increment();
      await tester.pumpWidget(widget);
      expect(find.text('0'), findsOneWidget);
      expect(builds, equals(1));

      cubit.increment();
      await tester.pumpWidget(widget);
      expect(find.text('0'), findsOneWidget);
      expect(builds, equals(1));

      expect(tester.takeException(), equals(null));
    });
  });

  group('useBlocState()', () {
    testWidgets('does not update widget when Cubit emits state',
        (tester) async {
      final cubit = CounterCubit();

      final widget = MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: HookBuilder(
            builder: (context) {
              final i = useBlocState<CounterCubit, int>();

              return Text('$i');
            },
          ),
        ),
      );

      await tester.pumpWidget(widget);
      expect(find.text('0'), findsOneWidget);

      cubit.increment();
      await tester.pumpWidget(widget);
      expect(find.text('1'), findsOneWidget);

      cubit.increment();
      await tester.pumpWidget(widget);
      expect(find.text('2'), findsOneWidget);

      expect(tester.takeException(), equals(null));
    });
  });

  group('useBlocSelector()', () {
    testWidgets('does not update widget when Cubit emits unrelated state',
        (tester) async {
      final cubit = CounterCubit();

      var builds = 0;

      final widget = MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: HookBuilder(
            builder: (context) {
              useBlocSelector<CounterCubit, int, int>((cubit) => 0);

              builds++;

              return const SizedBox();
            },
          ),
        ),
      );

      await tester.pumpWidget(widget);
      expect(builds, equals(1));

      cubit.increment();
      await tester.pumpWidget(widget);
      expect(builds, equals(1));

      cubit.increment();
      await tester.pumpWidget(widget);
      expect(builds, equals(1));

      expect(tester.takeException(), equals(null));
    });

    testWidgets('updates widget when Cubit emits unrelated state',
        (tester) async {
      final cubit = CounterCubit();

      final widget = MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: HookBuilder(
            builder: (context) {
              final i =
                  useBlocSelector<CounterCubit, int, int>((state) => state);

              return Text('$i');
            },
          ),
        ),
      );

      await tester.pumpWidget(widget);
      expect(find.text('0'), findsOneWidget);

      cubit.increment();
      await tester.pumpWidget(widget);
      expect(find.text('1'), findsOneWidget);

      cubit.increment();
      await tester.pumpWidget(widget);
      expect(find.text('2'), findsOneWidget);

      expect(tester.takeException(), equals(null));
    });
  });

  group('useBlocListener()', () {
    testWidgets('calls listener when Cubit emits state', (tester) async {
      final cubit = CounterCubit();

      var builds = 0;
      var invocations = 0;

      final widget = MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: HookBuilder(
            builder: (context) {
              useBlocListener<CounterCubit, int>(
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
