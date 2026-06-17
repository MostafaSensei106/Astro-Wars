abstract class Failures {
  const Failures(this.message);
  final String message;
}

class ServerFailure extends Failures {
  const ServerFailure(super.message);
}

class CacheFailure extends Failures {
  const CacheFailure(super.message);
}

class CooldownFailure extends Failures {
  const CooldownFailure(super.message);
}

class NetworkFailure extends Failures {
  const NetworkFailure(super.message);
}

class UnknownFailure extends Failures {
  const UnknownFailure(super.message);
}

class TimeoutFailure extends Failures {
  const TimeoutFailure(super.message);
}

class OfflineFailure extends Failures {
  const OfflineFailure(super.message);
}

class LocalStorageFailure extends Failures {
  const LocalStorageFailure(super.message);
}

final class ParsingFailure extends Failures {
  const ParsingFailure(super.message);
}
