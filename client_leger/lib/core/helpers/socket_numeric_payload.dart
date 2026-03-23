int? tryParseSocketWholeNumber(Object? data) {
  if (data == null) return null;
  if (data is int) return data;
  if (data is num) return data.toInt();
  return null;
}
