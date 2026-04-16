int? tryParseSocketWholeNumber(Object? data) {
  if (data == null) return null;
  if (data is int) return data;
  if (data is num) return data.toInt();
  return null;
}

/// Parses ints from socket maps where values may be [num], [String], etc.
int? tryParseSocketInt(Object? raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  if (raw is num) return raw.toInt();
  if (raw is String) return int.tryParse(raw.trim());
  return null;
}
