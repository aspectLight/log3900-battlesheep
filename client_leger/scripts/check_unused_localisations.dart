// Reports localization keys defined in *_en.arb that are never referenced in lib (as .key or .key()).
// Exits 0 if none unused, 1 otherwise. Run from client_leger: dart run scripts/check_unused_localisations.dart

import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final root = scriptDir.parent;
  final libDir = Directory('${root.path}/lib');
  if (!libDir.existsSync()) {
    stderr.writeln('lib not found at ${libDir.path}');
    exit(1);
  }

  final configs = [
    ('lib/core/localisation', 'core_en.arb', 'core'),
    ('lib/features/authentication/core/localisation', 'auth_en.arb', 'auth'),
    (
      'lib/features/join_game_session/core/localisation',
      'join_game_session_en.arb',
      'join_game_session',
    ),
    (
      'lib/features/waiting_room/core/localisation',
      'waiting_room_en.arb',
      'waiting_room',
    ),
    (
      'lib/features/select_game_session/core/localisation',
      'select_game_session_en.arb',
      'select_game_session',
    ),
    (
      'lib/features/character_creation/core/localisation',
      'character_creation_en.arb',
      'character_creation',
    ),
    (
      'lib/features/game_session/core/localisation',
      'game_session_en.arb',
      'game_session',
    ),
    ('lib/features/chat/core/localisation', 'chat_en.arb', 'chat'),
    (
      'lib/features/statistics/core/localisation',
      'statistics_en.arb',
      'statistics',
    ),
  ];

  final dartFiles = _collectDartFiles(
    libDir,
    root.path,
  ).where((f) => !_isLocalisationDefinition(f)).toList();

  var hasUnused = false;
  for (final c in configs) {
    final arbPath = '${root.path}/${c.$1}/${c.$2}';
    final file = File(arbPath);
    if (!file.existsSync()) {
      stderr.writeln('ARB not found: $arbPath');
      continue;
    }
    final keys = _keysFromArb(file);
    if (keys.isEmpty) continue;
    final unused = _unusedKeys(keys, dartFiles);
    if (unused.isNotEmpty) {
      hasUnused = true;
      stdout.writeln('${c.$3} (${c.$2}):');
      for (final k in unused..sort()) {
        stdout.writeln('  $k');
      }
      stdout.writeln();
    }
  }
  exit(hasUnused ? 1 : 0);
}

List<String> _keysFromArb(File file) {
  final content = file.readAsStringSync();
  final map = jsonDecode(content) as Map<String, dynamic>;
  return map.keys.where((k) => !k.startsWith('@')).toList();
}

bool _isLocalisationDefinition(String path) {
  final name = path.split(Platform.pathSeparator).last;
  return name.endsWith('_localizations.dart') ||
      name.endsWith('_localizations_en.dart') ||
      name.endsWith('_localizations_fr.dart');
}

List<String> _collectDartFiles(Directory dir, String libRoot) {
  final list = <String>[];
  for (final e in dir.listSync(recursive: true)) {
    if (e is File && e.path.endsWith('.dart') && e.path.startsWith(libRoot)) {
      list.add(e.path);
    }
  }
  return list;
}

List<String> _unusedKeys(List<String> keys, List<String> dartFiles) {
  return keys.where((key) => !_isKeyUsed(key, dartFiles)).toList();
}

bool _isKeyUsed(String key, List<String> dartFiles) {
  final getterPattern = RegExp(r'\.' + RegExp.escape(key) + r'\b');
  final methodPattern = RegExp(r'\.' + RegExp.escape(key) + r'\s*\(');
  for (final path in dartFiles) {
    final content = File(path).readAsStringSync();
    if (getterPattern.hasMatch(content) || methodPattern.hasMatch(content)) {
      return true;
    }
  }
  return false;
}
