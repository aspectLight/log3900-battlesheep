import 'package:fpdart/fpdart.dart';

extension OptionWhenPresent<T> on Option<T> {
  void whenPresent(void Function(T value) f) {
    fold(() {}, f);
  }
}

extension OptionWhen<T> on Option<T> {
  R when<R>({required R Function() none, required R Function(T value) some}) {
    return fold(none, some);
  }
}

extension OptionOrElse<T> on Option<T> {
  T orElse(T fallback) => fold(() => fallback, (v) => v);
}

extension OptionContains<T> on Option<T> {
  bool contains(T value) => fold(() => false, (v) => v == value);
}

extension OptionAssumePresent<T> on Option<T> {
  T assumePresent() =>
      fold(() => throw StateError('Expected value in current flow'), (v) => v);
}

T requireOption<T>(Option<T> option, {required Exception orElse}) {
  return option.match(() => throw orElse, (value) => value);
}

String requireNonEmptyString(
  Option<String> option, {
  required Exception orElse,
}) {
  return option.match(
    () => throw orElse,
    (value) => value.isEmpty ? throw orElse : value,
  );
}

extension EitherWhen<L, R> on Either<L, R> {
  void when({void Function(L failure)? left, void Function(R value)? right}) {
    fold(
      (l) {
        if (left != null) {
          left(l);
        }
      },
      (r) {
        if (right != null) {
          right(r);
        }
      },
    );
  }
}
