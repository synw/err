import 'package:hive/hive.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'models/err.dart';

const _sep = "#:#";

/// Serializer to Hive
String serializeToDb(Err err) {
  final buf = StringBuffer()
    ..write(err.date.millisecondsSinceEpoch.toString())
    ..write(_sep + err.message)
    ..write(_sep + EnumToString.parse(err.type))
    ..write(_sep + err.userMessage);
  return buf.toString();
}
