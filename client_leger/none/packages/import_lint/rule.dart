import 'dart:convert' as convert;

class Rules {
  const Rules(this.value);
  final List<Rule> value;
  factory Rules.fromParsedYaml(dynamic parsedYaml) {
    try {
      final encoded = convert.jsonEncode(parsedYaml['rules']);
      final rulesMap = convert.jsonDecode(encoded) as Map<String, dynamic>;

      final ruleNames = rulesMap.keys.toList();

      final result = <Rule>[];
      for (final name in ruleNames) {
        final rule = rulesMap[name];

        final searchFilePathRegExp = RegExp(rule['search_file_path_reg_exp']);

        final notAllowImportRegExps =
            (rule['not_allow_import_reg_exps'] as List<dynamic>)
                .map((e) => RegExp(e.toString()))
                .toList();

        final ignoreImportRegExps =
            (rule['ignore_import_reg_exps'] as List<dynamic>)
                .map((e) => RegExp(e.toString()))
                .toList();

        result.add(
          Rule(
            name: name,
            searchFilePathRegExp: searchFilePathRegExp,
            notAllowImportRegExps: notAllowImportRegExps,
            ignoreImportRegExps: ignoreImportRegExps,
          ),
        );
      }
      return Rules(result);
    } catch (e) {
      throw Exception(
        'Syntax Error: import_analysis_options.yaml file at the root of your project.',
      );
    }
  }
}

class Rule {
  const Rule({
    required this.name,
    required this.searchFilePathRegExp,
    required this.notAllowImportRegExps,
    required this.ignoreImportRegExps,
  });

  final String name;
  final RegExp searchFilePathRegExp;
  final List<RegExp> notAllowImportRegExps;
  final List<RegExp> ignoreImportRegExps;
}
