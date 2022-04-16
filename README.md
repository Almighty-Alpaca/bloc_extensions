# Bloc Extensions

[![License: MIT][license:mit:shield]][license:mit:link]
[![GitHub Workflow Status][package:bloc_extensions:shield]][package:bloc_extensions:github]
[![melos][package:melos:shield]](#contributing)
[![style: very good analysis][package:very_good_analysis:shield]][package:very_good_analysis:pub]

---

A collections of packages providing additional functionality for working with [bloc][package:bloc:pub].

## Index

- [Packages](#packages)
- [Bloc Hooks](#bloc-hooks)
- [Action Blocs](#action-blocs)
- [Contributing](#contributing)

## Packages

| **Package**                                                           | Version                                                                                   |
|-----------------------------------------------------------------------|-------------------------------------------------------------------------------------------|
| [action_bloc][package:action_bloc:source]                             | [![pub][package:action_bloc:shield]][package:action_bloc:pub]                             |
| [action_bloc_test][package:action_bloc_test:source]                   | [![pub][package:action_bloc_test:shield]][package:action_bloc_test:pub]                   |
| [flutter_action_bloc][package:flutter_action_bloc:source]             | [![pub][package:flutter_action_bloc:shield]][package:flutter_action_bloc:pub]             |
| [flutter_action_bloc_hooks][package:flutter_action_bloc_hooks:source] | [![pub][package:flutter_action_bloc_hooks:shield]][package:flutter_action_bloc_hooks:pub] |
| [flutter_bloc_hooks][package:flutter_bloc_hooks:source]               | [![pub][package:flutter_bloc_hooks:shield]][package:flutter_bloc_hooks:pub]               |

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

This repository uses [melos][package:melos:pub] for managing all packages. To get started first install melos and then run its `bootstrap` command.

```shell
dart pub global activate melos

melos bootstrap 
```

More information about melos can be found on <https://melos.invertase.dev>. All available scripts can be seen in [`melos.yaml`](melos.yaml).

<!-- links -->

[license:mit:link]:                         https://choosealicense.com/licenses/mit/
[license:mit:shield]:                       https://img.shields.io/badge/license-MIT-purple?style=flat-square
[package:action_bloc:pub]:                  https://pub.dev/packages/action_bloc
[package:action_bloc:shield]:               https://img.shields.io/pub/v/action_bloc.svg?label=action_bloc&style=flat-square
[package:action_bloc:source]:               ./packages/action_bloc
[package:action_bloc_test:pub]:             https://pub.dev/packages/action_bloc_test
[package:action_bloc_test:shield]:          https://img.shields.io/pub/v/action_bloc_test.svg?label=action_bloc_test&style=flat-square
[package:action_bloc_test:source]:          ./packages/action_bloc_test
[package:bloc:pub]:                         https://pub.dev/packages/bloc
[package:bloc_extensions:github]:           https://github.com/Almighty-Alpaca/bloc_extensions
[package:bloc_extensions:shield]:           https://img.shields.io/github/workflow/status/Almighty-Alpaca/bloc_extensions/Build?style=flat-square
[package:flutter_action_bloc:pub]:          https://pub.dev/packages/flutter_action_bloc
[package:flutter_action_bloc:shield]:       https://img.shields.io/pub/v/flutter_action_bloc.svg?label=flutter_action_bloc&style=flat-square
[package:flutter_action_bloc:source]:       ./packages/flutter_action_bloc
[package:flutter_action_bloc_hooks:pub]:    https://pub.dev/packages/flutter_action_bloc_hooks
[package:flutter_action_bloc_hooks:shield]: https://img.shields.io/pub/v/flutter_action_bloc_hooks.svg?label=flutter_action_bloc_hooks&style=flat-square
[package:flutter_action_bloc_hooks:source]: ./packages/flutter_action_bloc_hooks
[package:flutter_bloc_hooks:pub]:           https://pub.dev/packages/flutter_bloc_hooks
[package:flutter_bloc_hooks:shield]:        https://img.shields.io/pub/v/flutter_bloc_hooks.svg?label=flutter_bloc_hooks&style=flat-square
[package:flutter_bloc_hooks:source]:        ./packages/flutter_bloc_hooks
[package:melos:pub]:                        https://pub.dev/packages/melos
[package:melos:shield]:                     https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square
[package:very_good_analysis:pub]:           https://pub.dev/packages/very_good_analysis
[package:very_good_analysis:shield]:        https://img.shields.io/badge/style-very_good_analysis-B22C89.svg?style=flat-square
