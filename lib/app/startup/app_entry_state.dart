import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_entry_state.freezed.dart';

enum EntryDestination { startup, onboarding, login, accountSetup, ready }

/// Distinguishes separate visits to the same account, even after A → B → A.
typedef EntryAccount = ({String uid, Object lifetime});

@freezed
abstract class AppEntryState with _$AppEntryState {
  const AppEntryState._();

  const factory AppEntryState.restoringSession() = EntryRestoringSession;
  const factory AppEntryState.sessionUnavailable() = EntrySessionUnavailable;
  const factory AppEntryState.onboarding() = EntryOnboarding;
  const factory AppEntryState.login() = EntryLogin;
  const factory AppEntryState.checkingAccount(EntryAccount account) =
      EntryCheckingAccount;
  const factory AppEntryState.accountUnavailable(EntryAccount account) =
      EntryAccountUnavailable;
  const factory AppEntryState.setupRequired(EntryAccount account) =
      EntrySetupRequired;
  const factory AppEntryState.ready(EntryAccount account) = EntryReady;

  EntryDestination get destination => switch (this) {
    EntryOnboarding() => EntryDestination.onboarding,
    EntryLogin() => EntryDestination.login,
    EntrySetupRequired() => EntryDestination.accountSetup,
    EntryReady() => EntryDestination.ready,
    _ => EntryDestination.startup,
  };

  EntryAccount? get activeAccount => switch (this) {
    EntryCheckingAccount(:final account) ||
    EntryAccountUnavailable(:final account) ||
    EntrySetupRequired(:final account) ||
    EntryReady(:final account) => account,
    _ => null,
  };
}
