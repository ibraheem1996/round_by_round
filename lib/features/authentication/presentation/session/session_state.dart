import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_state.freezed.dart';

@freezed
abstract class SessionState with _$SessionState {
  const factory SessionState.restoring() = SessionRestoring;
  const factory SessionState.unavailable() = SessionUnavailable;
  const factory SessionState.signedOut() = SessionSignedOut;
  const factory SessionState.signedIn(String uid) = SessionSignedIn;
}
