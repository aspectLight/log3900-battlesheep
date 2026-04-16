import 'rule.dart';

class Issues {
  const Issues(
    this.value,
  );

  final List<Issue> value;

  factory Issues.ofRuleAndLines({
    required Rule rule,
    required String filePath,
    required List<String> lines,
  }) {
    final issues = <Issue>[];
    for (final regExp in rule.notAllowImportRegExps) {
      final issueLines = <IssueLine>[];
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];

        final isIgnore = rule.ignoreImportRegExps
            .map((e) => e.hasMatch(line))
            .contains(true);

        if (regExp.hasMatch(line) && !isIgnore) {
          issueLines.add(IssueLine(i + 1, line));
        }
      }
      if (issueLines.isNotEmpty) {
        issues.add(Issue(rule, filePath, issueLines));
      }
    }
    return Issues(issues);
  }
}

class Issue {
  const Issue(
    this.rule,
    this.filePath,
    this.lines,
  );

  final Rule rule;
  final String filePath;
  final List<IssueLine> lines;
}

class IssueLine {
  const IssueLine(
    this.number,
    this.value,
  );

  final int number;
  final String value;
}
