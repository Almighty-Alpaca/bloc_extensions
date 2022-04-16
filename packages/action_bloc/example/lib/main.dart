import 'package:action_bloc/action_bloc.dart';

// A cubit that counts up and emits FizzBuzz as actions
class CounterCubit extends ActionCubit<int, String> {
  CounterCubit() : super(0);

  void increment() {
    emit(state + 1);

    if (state % 15 == 0) {
      emitAction('FizzBuzz');
    } else if (state % 5 == 0) {
      emitAction('Buzz');
    } else if (state % 3 == 0) {
      emitAction('Fizz');
    } else {
      emitAction('$state');
    }
  }
}

Future<void> run(int limit) async {
  final cubit = CounterCubit();

  final actionSubscription = cubit.actions.listen(print);

  for (var i = 0; i < limit; i++) {
    cubit.increment();

    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  await actionSubscription.cancel();
  await cubit.close();
}
