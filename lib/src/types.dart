/// Error route destination
enum ErrRoute {
  /// The terminal route
  console,

  /// Route for screen and flash messages
  screen,

  /// Route to nowhere: silently swallow the messages
  blackHole
}

/// The error channels
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
