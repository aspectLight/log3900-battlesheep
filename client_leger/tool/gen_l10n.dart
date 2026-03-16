//dart run tool/gen_l10n.dart
import 'dart:io';

const _flutterExecutable = 'flutter';
const _l10nCommand = 'gen-l10n';
const _l10nYamlFilename = 'l10n.yaml';

void main() async {
  final projectDir = Directory.current.path;
  final l10nYamlPath = '$projectDir/$_l10nYamlFilename';
  final l10nYamlFile = File(l10nYamlPath);

  if (!l10nYamlFile.existsSync()) {
    stderr.writeln('$_l10nYamlFilename not found at $l10nYamlPath');
    exitCode = 1;
    return;
  }

  String savedContent;
  try {
    savedContent = l10nYamlFile.readAsStringSync();
  } on Exception catch (e) {
    stderr.writeln('Failed to read $_l10nYamlFilename: $e');
    exitCode = 1;
    return;
  }

  final configs = [
    (
      arbDir: 'lib/core/localisation',
      template: 'core_en.arb',
      outputFile: 'core_localizations.dart',
      outputClass: 'CoreLocalizations',
    ),
    (
      arbDir: 'lib/features/authentication/core/localisation',
      template: 'auth_en.arb',
      outputFile: 'auth_localizations.dart',
      outputClass: 'AuthLocalizations',
    ),
    (
      arbDir: 'lib/features/join_game_session/core/localisation',
      template: 'join_game_session_en.arb',
      outputFile: 'join_game_session_localizations.dart',
      outputClass: 'JoinGameSessionLocalizations',
    ),
    (
      arbDir: 'lib/features/waiting_room/core/localisation',
      template: 'waiting_room_en.arb',
      outputFile: 'waiting_room_localizations.dart',
      outputClass: 'WaitingRoomLocalizations',
    ),
    (
      arbDir: 'lib/features/select_game_session/core/localisation',
      template: 'select_game_session_en.arb',
      outputFile: 'select_game_session_localizations.dart',
      outputClass: 'SelectGameSessionLocalizations',
    ),
    (
      arbDir: 'lib/features/character_creation/core/localisation',
      template: 'character_creation_en.arb',
      outputFile: 'character_creation_localizations.dart',
      outputClass: 'CharacterCreationLocalizations',
    ),
    (
      arbDir: 'lib/features/game_session/core/localisation',
      template: 'game_session_en.arb',
      outputFile: 'game_session_localizations.dart',
      outputClass: 'GameSessionLocalizations',
    ),
    (
      arbDir: 'lib/features/chat/core/localisation',
      template: 'chat_en.arb',
      outputFile: 'chat_localizations.dart',
      outputClass: 'ChatLocalizations',
    ),
    (
      arbDir: 'lib/features/statistics/core/localisation',
      template: 'statistics_en.arb',
      outputFile: 'statistics_localizations.dart',
      outputClass: 'StatisticsLocalizations',
    ),
    (
      arbDir: 'lib/features/profile/core/localisation',
      template: 'profile_en.arb',
      outputFile: 'profile_localizations.dart',
      outputClass: 'ProfileLocalizations',
    ),
  ];

  try {
    for (final c in configs) {
      // Runs sequentially: each iteration overwrites l10n.yaml, so parallelisation would require per-config temp files.
      // YAML is built via string interpolation; arbDir/template/output paths are controlled and do not contain special characters.
      final yamlContent =
          '''
enabled: true
arb-dir: ${c.arbDir}
template-arb-file: ${c.template}
output-dir: ${c.arbDir}
output-localization-file: ${c.outputFile}
output-class: ${c.outputClass}
''';
      await l10nYamlFile.writeAsString(yamlContent);
      final result = await Process.run(
        _flutterExecutable,
        [_l10nCommand],
        workingDirectory: projectDir,
        runInShell: true,
        stdoutEncoding: stdout.encoding,
        stderrEncoding: stderr.encoding,
      );
      if (result.exitCode != 0) {
        stderr.writeln('$_l10nCommand failed for ${c.outputClass}:');
        stderr.write(result.stderr);
        throw _GenL10nException(result.exitCode);
      }
      stdout.writeln('Generated ${c.outputClass}');
    }
    stdout.writeln('All localizations generated.');
  } on _GenL10nException catch (e) {
    exitCode = e.exitCode;
  } finally {
    l10nYamlFile.writeAsStringSync(savedContent);
  }
}

class _GenL10nException implements Exception {
  _GenL10nException(this.exitCode);
  final int exitCode;
}
