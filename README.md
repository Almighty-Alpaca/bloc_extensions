# Bloc Extensions

---

A collections of packages providing additional functionality for working with [bloc](https://github.com/felangel/bloc).

## Index

- [Packages](#packages)
- [Bloc Hooks](#bloc-hooks)
- [Action Blocs](#action-blocs)
- [Contributing](#contributing)

## Packages

| **Package**                                                    | Version                                                                   |
|----------------------------------------------------------------|---------------------------------------------------------------------------|
| [action_bloc][package_action_bloc]                             | [![pub][shield_action_bloc]][pub_action_bloc]                             |
| [action_bloc_test][package_action_bloc_test]                   | [![pub][shield_action_bloc_test]][pub_action_bloc_test]                   |
| [flutter_action_bloc][package_flutter_action_bloc]             | [![pub][shield_flutter_action_bloc]][pub_flutter_action_bloc]             |
| [flutter_action_bloc_hooks][package_flutter_action_bloc_hooks] | [![pub][shield_flutter_action_bloc_hooks]][pub_flutter_action_bloc_hooks] |
| [flutter_bloc_hooks][package_flutter_bloc_hooks]               | [![pub][shield_flutter_bloc_hooks]][pub_flutter_bloc_hooks]               |

## Bloc Hooks

Bloc hooks provide an easy way to use blocs from `HookWidget`s and other hooks without needing to access the current `BuildContext` or unnecessary deep nesting using `BlocBuilder`s
and `BlocListener`s.

### Example

```dart
class CounterText extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final counter = useBlocState<CounterCubit, int>();

    return Text('$counter');
  }
}
```

## Action Blocs

`ActionBloc`s are bloc with an additional stream for actions (side effects). When using sealed classes (for example with freezed) as state side effects cannot easily be modeled
inside the state. Examples for such side effects include showing error messages or navigating to another screen.

### Example

```dart
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

class CounterText extends HookWidget {
  const CounterText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counter = useBlocState<CounterCubit, int>();

    useBlocActionListener<CounterCubit, String>((context, action) {
      final snackBar = SnackBar(
        content: Text(action),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    return Text('$counter');
  }
}
```

## Contributing

This repository uses [melos][pub_melos] for managing all packages. To get started first install melos and then run it's `bootstrap` command.

```shell
dart pub global activate melos

melos bootstrap 
```

More information about melos can be found on <https://melos.invertase.dev>. All available scripts can be seen in [`melos.yaml`](melos.yaml).

<!-- package paths -->

[package_action_bloc]:               packages/action_bloc

[package_action_bloc_test]:          packages/action_bloc_test

[package_flutter_action_bloc]:       packages/flutter_action_bloc

[package_flutter_action_bloc_hooks]: packages/flutter_action_bloc_hooks

[package_flutter_bloc_hooks]:        packages/flutter_bloc_hooks

<!-- shields -->

[shield_action_bloc]:               https://img.shields.io/pub/v/action_bloc.svg?label=action_bloc

[shield_action_bloc_test]:          https://img.shields.io/pub/v/action_bloc_test.svg?label=action_bloc_test

[shield_flutter_action_bloc]:       https://img.shields.io/pub/v/flutter_action_bloc.svg?label=flutter_action_bloc

[shield_flutter_action_bloc_hooks]: https://img.shields.io/pub/v/flutter_action_bloc_hooks.svg?label=flutter_action_bloc_hooks

[shield_flutter_bloc_hooks]:        https://img.shields.io/pub/v/flutter_bloc_hooks.svg?label=flutter_bloc_hooks

<!-- pub.dev links -->

[pub_action_bloc]:               https://pub.dev/packages/action_bloc

[pub_action_bloc_test]:          https://pub.dev/packages/action_bloc_test

[pub_flutter_action_bloc]:       https://pub.dev/packages/flutter_action_bloc

[pub_flutter_action_bloc_hooks]: https://pub.dev/packages/flutter_action_bloc_hooks

[pub_flutter_bloc_hooks]:        https://pub.dev/packages/flutter_bloc_hooks

[pub_melos]: https://pub.dev/packages/melos
