final class HTTPMessages {
  /// General
  static const String ok = 'Ok';
  static const String created = 'Created';
  static const String badRequest = 'BadRequest';
  static const String noContent = 'NoContent';
  static const String forbidden = 'Forbidden';
  static const String unauthorized = 'Unauthorized';
  static const String notFound = 'NotFound';
  static const String conflict = 'Conflict';
  static const String internalServerError = 'InternalServerError';
  static const String unknownError = 'UnknownError';

  /// Informational
  static const String continue_ = 'Continue';
  static const String switchingProtocols = 'SwitchingProtocols';
  static const String processing = 'Processing';
  static const String earlyHints = 'EarlyHints';

  /// Success
  static const String accepted = 'Accepted';
  static const String nonAuthoritativeInfo = 'NonAuthoritativeInfo';
  static const String resetContent = 'ResetContent';
  static const String partialContent = 'PartialContent';
  static const String multiStatus = 'MultiStatus';
  static const String alreadyReported = 'AlreadyReported';
  static const String imUsed = 'IMUsed';

  /// Redirection
  static const String multipleChoices = 'MultipleChoices';
  static const String movedPermanently = 'MovedPermanently';
  static const String found = 'Found';
  static const String seeOther = 'SeeOther';
  static const String notModified = 'NotModified';
  static const String useProxy = 'UseProxy';
  static const String temporaryRedirect = 'TemporaryRedirect';
  static const String permanentRedirect = 'PermanentRedirect';

  /// Client Error
  static const String paymentRequired = 'PaymentRequired';
  static const String methodNotAllowed = 'MethodNotAllowed';
  static const String notAcceptable = 'NotAcceptable';
  static const String proxyAuthRequired = 'ProxyAuthRequired';
  static const String requestTimeout = 'RequestTimeout';
  static const String gone = 'Gone';
  static const String lengthRequired = 'LengthRequired';
  static const String preconditionFailed = 'PreconditionFailed';
  static const String requestEntityTooLarge = 'RequestEntityTooLarge';
  static const String requestURITooLong = 'RequestURITooLong';
  static const String unsupportedMediaType = 'UnsupportedMediaType';
  static const String requestedRangeNotSatisfiable =
      'RequestedRangeNotSatisfiable';
  static const String expectationFailed = 'ExpectationFailed';
  static const String teapot = 'Teapot';
  static const String misdirectedRequest = 'MisdirectedRequest';
  static const String unprocessableEntity = 'UnprocessableEntity';
  static const String locked = 'Locked';
  static const String failedDependency = 'FailedDependency';
  static const String tooEarly = 'TooEarly';
  static const String upgradeRequired = 'UpgradeRequired';
  static const String preconditionRequired = 'PreconditionRequired';
  static const String tooManyRequests = 'TooManyRequests';
  static const String requestHeaderFieldsTooLarge =
      'RequestHeaderFieldsTooLarge';
  static const String unavailableForLegalReasons = 'UnavailableForLegalReasons';

  /// Server Error
  static const String notImplemented = 'NotImplemented';
  static const String badGateway = 'BadGateway';
  static const String serviceUnavailable = 'ServiceUnavailable';
  static const String gatewayTimeout = 'GatewayTimeout';
  static const String httpVersionNotSupported = 'HTTPVersionNotSupported';
  static const String variantAlsoNegotiates = 'VariantAlsoNegotiates';
  static const String insufficientStorage = 'InsufficientStorage';
  static const String loopDetected = 'LoopDetected';
  static const String notExtended = 'NotExtended';
  static const String networkAuthenticationRequired =
      'NetworkAuthenticationRequired';
}
