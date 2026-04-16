import 'package:get_it/get_it.dart';

import '../../data/reducers/waiting_room_reservations_state_reducer.dart';
import '../../data/reducers/waiting_room_room_state_reducer.dart';
import '../../data/repositories/waiting_room_reservations_repository.dart';
import '../../data/repositories/waiting_room_room_repository.dart';
import '../../data/services/waiting_room_socket.dart';
import '../../domain/models/waiting_room_model.dart';
import '../context/waiting_room_entry_data.dart';

void registerWaitingRoomRepositories(
  GetIt scope,
  GetIt rootGetIt, {
  required String roomId,
  required String hostId,
  required String socketId,
  required WaitingRoomEntryData entryData,
  WaitingRoomModel? initialRoom,
  int entryFee = 0,
}) {
  final socket = scope.get<WaitingRoomSocket>();
  final baseRoom =
      initialRoom ?? WaitingRoomModel.initial(roomId: roomId, hostId: hostId);
  final initialRoomState = entryFee > 0
      ? baseRoom.copyWith(entryFee: entryFee)
      : baseRoom;
  final clientStartedWaitingRoom = switch (entryData) {
    WaitingRoomHostEntryData() => true,
    WaitingRoomJoinEntryData() => false,
  };
  scope.registerLazySingleton<WaitingRoomRoomStateReducer>(
    WaitingRoomRoomStateReducer.new,
  );
  scope.registerLazySingleton<WaitingRoomReservationsStateReducer>(
    WaitingRoomReservationsStateReducer.new,
  );
  scope.registerLazySingleton<WaitingRoomRoomRepository>(
    () => WaitingRoomRoomRepository(
      initialRoom: initialRoomState,
      socketId: socketId,
      socket: socket,
      reducer: scope.get<WaitingRoomRoomStateReducer>(),
      clientStartedWaitingRoom: clientStartedWaitingRoom,
    ),
  );
  scope.registerLazySingleton<WaitingRoomReservationsRepository>(
    () => WaitingRoomReservationsRepository(
      roomId: roomId,
      socket: socket,
      reducer: scope.get<WaitingRoomReservationsStateReducer>(),
    ),
  );
}
