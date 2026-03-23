import 'package:get_it/get_it.dart';

class CharacterCreationScopeHolder {
  GetIt? _scope;
  GetIt? get scope => _scope;

  void setScope(GetIt scope) {
    _scope = scope;
  }

  void clearScope() {
    _scope = null;
  }
}
