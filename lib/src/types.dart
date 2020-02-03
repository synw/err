/// The error channels
enum DeployementMode {
  /// The developpement channel
  dev,

  /// The beta test channel
  beta,

  /// The production channel
  production
}

/// The type of messages
enum ErrType {
  /// Critical errors
  critical,

  /// Normal errors
  error,

  /// Warning level
  warning,

  /// Info level
  info,

  /// Debug level
  debug
}
