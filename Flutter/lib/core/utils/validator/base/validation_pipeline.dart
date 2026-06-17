final class ValidationPipeline<E> {
  const ValidationPipeline(this.value);

  final String value;

  E? evaluate() => null;

  ValidationPipeline<E> required(E error) {
    if (value.isEmpty) return _ErrorPipeline<E>(error);
    return this;
  }

  ValidationPipeline<E> matches(RegExp regExp, E error) {
    if (!regExp.hasMatch(value)) return _ErrorPipeline<E>(error);
    return this;
  }

  ValidationPipeline<E> notMatches(RegExp regExp, E error) {
    if (regExp.hasMatch(value)) return _ErrorPipeline<E>(error);
    return this;
  }

  ValidationPipeline<E> minLength(int length, E error) {
    if (value.length < length) return _ErrorPipeline<E>(error);
    return this;
  }

  ValidationPipeline<E> maxLength(int length, E error) {
    if (value.length > length) return _ErrorPipeline<E>(error);
    return this;
  }

  ValidationPipeline<E> contains(String substring, E error) {
    if (!value.contains(substring)) return _ErrorPipeline<E>(error);
    return this;
  }

  ValidationPipeline<E> isLowerCase(E error) {
    if (value.toLowerCase() != value) return _ErrorPipeline<E>(error);
    return this;
  }

  ValidationPipeline<E> isUpperCase(E error) {
    if (value.toUpperCase() != value) return _ErrorPipeline<E>(error);
    return this;
  }

  ValidationPipeline<E> equals(String other, E error) {
    if (value != other) return _ErrorPipeline<E>(error);
    return this;
  }
}

final class _ErrorPipeline<E> extends ValidationPipeline<E> {
  const _ErrorPipeline(this.error) : super('');

  final E error;

  @override
  E? evaluate() => error;

  @override
  ValidationPipeline<E> required(E error) => this;

  @override
  ValidationPipeline<E> matches(RegExp regExp, E error) => this;

  @override
  ValidationPipeline<E> notMatches(RegExp regExp, E error) => this;

  @override
  ValidationPipeline<E> minLength(int length, E error) => this;

  @override
  ValidationPipeline<E> maxLength(int length, E error) => this;

  @override
  ValidationPipeline<E> contains(String substring, E error) => this;

  @override
  ValidationPipeline<E> isLowerCase(E error) => this;

  @override
  ValidationPipeline<E> isUpperCase(E error) => this;

  @override
  ValidationPipeline<E> equals(String other, E error) => this;
}
