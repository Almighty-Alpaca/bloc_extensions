# action_bloc

Extends [bloc][package:bloc:pub] with a second stream for actions (one time events that aren't part of the state)

This package is built to work with:

- [action_bloc_test][package:action_bloc_test:pub] - A test package for this package
- [flutter_action_bloc][package:flutter_action_bloc:pub] - A package for using this package in a Flutter app
- [flutter_action_bloc_hooks][package:flutter_action_bloc_hooks:pub] - A package for using this package together with [flutter_hooks][package:flutter_hooks:pub]
- [flutter_bloc_hooks][package:flutter_bloc_hooks:pub] - A package for using [bloc][package:bloc:pub] together with [flutter_hooks][package:flutter_hooks:pub]

 ## Installation

```shell
dart pub add action_bloc
```

## Example

See [./example][package:action_bloc_example:github] for an example of how to use this package.

<!-- links -->

[package:action_bloc_example:github]: https://github.com/Almighty-Alpaca/bloc_extensions/tree/master/packages/action_bloc/example
[package:action_bloc_test:pub]: https://pub.dev/packages/action_bloc_test
[package:bloc:pub]: https://pub.dev/packages/bloc
[package:flutter_action_bloc:pub]: https://pub.dev/packages/flutter_action_bloc
[package:flutter_action_bloc_hooks:pub]: https://pub.dev/packages/flutter_action_bloc_hooks
[package:flutter_bloc_hooks:pub]: https://pub.dev/packages/flutter_bloc_hooks
[package:flutter_hooks:pub]: https://pub.dev/packages/flutter_hooks
