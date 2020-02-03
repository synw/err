import 'models.dart';

/// The logger
///
/// Responsible for storing the historical log data
class ErrLogger {
  /// Default constructor
  ErrLogger();

  final List<Err> _errs = [];

  /// The list of errors
  List<Err> get errs => _errs;

  /// Log an error
  void add(Err err) => _errs.add(err);
}
