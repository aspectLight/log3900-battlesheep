import 'package:get_it/get_it.dart';

import '../../data/reducers/chat_state_reducer.dart';

void registerChatReducer(GetIt getIt) {
  getIt.registerLazySingleton<ChatStateReducer>(ChatStateReducer.new);
}
