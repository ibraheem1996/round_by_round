import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_entry_state.freezed.dart';

enum EntryDestination { startup, onboarding, login, accountSetup, ready }

@freezed
abstract class AppEntryState with _$AppEntryState {
  const AppEntryState._();

  const factory AppEntryState.restoringSession() = EntryRestoringSession;
  const factory AppEntryState.sessionUnavailable() = EntrySessionUnavailable;
  const factory AppEntryState.onboarding() = EntryOnboarding;
  const factory AppEntryState.login() = EntryLogin;
  const factory AppEntryState.checkingAccount(String uid) =
      EntryCheckingAccount;
  const factory AppEntryState.accountUnavailable(String uid) =
      EntryAccountUnavailable;
  const factory AppEntryState.setupRequired(String uid) = EntrySetupRequired;
  const factory AppEntryState.ready(String uid) = EntryReady;

  EntryDestination get destination => switch (this) {
    EntryOnboarding() => EntryDestination.onboarding,
    EntryLogin() => EntryDestination.login,
    EntrySetupRequired() => EntryDestination.accountSetup,
    EntryReady() => EntryDestination.ready,
    _ => EntryDestination.startup,
  };

  String? get activeUid => switch (this) {
    EntryCheckingAccount(:final uid) ||
    EntryAccountUnavailable(:final uid) ||
    EntrySetupRequired(:final uid) ||
    EntryReady(:final uid) => uid,
    _ => null,
  };
}
