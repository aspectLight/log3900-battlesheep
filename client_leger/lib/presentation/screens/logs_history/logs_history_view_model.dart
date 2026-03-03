import 'package:flutter/foundation.dart';

import '../../../domain/entities/logs_history_item.dart';
import '../../../domain/interfaces/repositories/logs_history_repository.dart';

class LogsHistoryViewModel extends ChangeNotifier {
  final LogsHistoryRepository _repository;

  List<LogsHistoryItem> items = [];
  bool isLoading = true;
  String? errorMessage;

  LogsHistoryViewModel(this._repository);

  Future<void> loadHistory() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _repository.getLoginHistory().run();

    result.fold(
      (failure) => errorMessage = failure.message,
      (data) => items = data,
    );

    isLoading = false;
    notifyListeners();
  }
}
