final class Http {
  static const int statusCodeOk = 200;
  static const int statusCodeCreated = 201;
  static const int statusCodeNoContent = 204;

  // Informational
  static const int statusCodeContinue = 100;
  static const int statusCodeSwitchingProtocols = 101;
  static const int statusCodeProcessing = 102;
  static const int statusCodeEarlyHints = 103;

  // Success
  static const int statusCodeAccepted = 202;
  static const int statusCodeNonAuthoritativeInfo = 203;
  static const int statusCodeResetContent = 205;
  static const int statusCodePartialContent = 206;
  static const int statusCodeMultiStatus = 207;
  static const int statusCodeAlreadyReported = 208;
  static const int statusCodeIMUsed = 226;

  // Redirection
  static const int statusCodeMultipleChoices = 300;
  static const int statusCodeMovedPermanently = 301;
  static const int statusCodeFound = 302;
  static const int statusCodeSeeOther = 303;
  static const int statusCodeNotModified = 304;
  static const int statusCodeUseProxy = 305;
  static const int statusCodeTemporaryRedirect = 307;
  static const int statusCodePermanentRedirect = 308;

  // Client Error
  static const int statusCodeBadRequest = 400;
  static const int statusCodeUnauthorized = 401;
  static const int statusCodePaymentRequired = 402;
  static const int statusCodeForbidden = 403;
  static const int statusCodeNotFound = 404;
  static const int statusCodeMethodNotAllowed = 405;
  static const int statusCodeNotAcceptable = 406;
  static const int statusCodeProxyAuthRequired = 407;
  static const int statusCodeRequestTimeout = 408;
  static const int statusCodeConflict = 409;
  static const int statusCodeGone = 410;
  static const int statusCodeLengthRequired = 411;
  static const int statusCodePreconditionFailed = 412;
  static const int statusCodeRequestEntityTooLarge = 413;
  static const int statusCodeRequestURITooLong = 414;
  static const int statusCodeUnsupportedMediaType = 415;
  static const int statusCodeRequestedRangeNotSatisfiable = 416;
  static const int statusCodeExpectationFailed = 417;
  static const int statusCodeTeapot = 418;
  static const int statusCodeMisdirectedRequest = 421;
  static const int statusCodeUnprocessableEntity = 422;
  static const int statusCodeLocked = 423;
  static const int statusCodeFailedDependency = 424;
  static const int statusCodeTooEarly = 425;
  static const int statusCodeUpgradeRequired = 426;
  static const int statusCodePreconditionRequired = 428;
  static const int statusCodeTooManyRequests = 429;
  static const int statusCodeRequestHeaderFieldsTooLarge = 431;
  static const int statusCodeUnavailableForLegalReasons = 451;

  // Server Error
  static const int statusCodeInternalServerError = 500;
  static const int statusCodeNotImplemented = 501;
  static const int statusCodeBadGateway = 502;
  static const int statusCodeServiceUnavailable = 503;
  static const int statusCodeGatewayTimeout = 504;
  static const int statusCodeHTTPVersionNotSupported = 505;
  static const int statusCodeVariantAlsoNegotiates = 506;
  static const int statusCodeInsufficientStorage = 507;
  static const int statusCodeLoopDetected = 508;
  static const int statusCodeNotExtended = 510;
  static const int statusCodeNetworkAuthenticationRequired = 511;
}
