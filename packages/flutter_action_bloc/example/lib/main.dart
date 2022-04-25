import 'package:action_bloc/action_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_action_bloc/flutter_action_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const CounterApp());

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
    }
  }
}

class CounterApp extends StatelessWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterCubit>(
      create: (context) => CounterCubit(),
      child: const MaterialApp(
        home: CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CounterCubit>().increment(),
        child: const Icon(Icons.add),
      ),
      body: ActionBlocListener<CounterCubit, String>(
        listener: (context, action) {
          final snackBar = SnackBar(
            content: Text(action),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          );

          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(snackBar);
        },
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, state) {
            return Center(
              child: Text(
                '$state',
                style: Theme.of(context).textTheme.headline4,
              ),
            );
          },
        ),
      ),
    );
  }
}
