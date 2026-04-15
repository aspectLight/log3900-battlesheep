import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/exceptions/profile_failure.dart';
import '../models/profile_model.dart';
import '../models/profile_statistics_model.dart';

part 'profile_state.freezed.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState.idle() = ProfileStateIdle;

  const factory ProfileState.loading() = ProfileStateLoading;

  const factory ProfileState.loaded({
    required ProfileModel profile,
    required ProfileStatisticsModel statistics,
  }) = ProfileStateLoaded;

  const factory ProfileState.error(ProfileFailure failure) = ProfileStateError;
}
