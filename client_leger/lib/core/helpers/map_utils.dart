Map<V, K> invertMap<K, V>(Map<K, V> map) {
  return {for (final e in map.entries) e.value: e.key};
}
