// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_entry_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppEntryState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AppEntryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppEntryState()';
}


}

/// @nodoc
class $AppEntryStateCopyWith<$Res>  {
$AppEntryStateCopyWith(AppEntryState _, $Res Function(AppEntryState) __);
}


/// Adds pattern-matching-related methods to [AppEntryState].
extension AppEntryStatePatterns on AppEntryState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EntryRestoringSession value)?  restoringSession,TResult Function( EntrySessionUnavailable value)?  sessionUnavailable,TResult Function( EntryOnboarding value)?  onboarding,TResult Function( EntryLogin value)?  login,TResult Function( EntryCheckingAccount value)?  checkingAccount,TResult Function( EntryAccountUnavailable value)?  accountUnavailable,TResult Function( EntrySetupRequired value)?  setupRequired,TResult Function( EntryReady value)?  ready,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EntryRestoringSession() when restoringSession != null:
return restoringSession(_that);case EntrySessionUnavailable() when sessionUnavailable != null:
return sessionUnavailable(_that);case EntryOnboarding() when onboarding != null:
return onboarding(_that);case EntryLogin() when login != null:
return login(_that);case EntryCheckingAccount() when checkingAccount != null:
return checkingAccount(_that);case EntryAccountUnavailable() when accountUnavailable != null:
return accountUnavailable(_that);case EntrySetupRequired() when setupRequired != null:
return setupRequired(_that);case EntryReady() when ready != null:
return ready(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EntryRestoringSession value)  restoringSession,required TResult Function( EntrySessionUnavailable value)  sessionUnavailable,required TResult Function( EntryOnboarding value)  onboarding,required TResult Function( EntryLogin value)  login,required TResult Function( EntryCheckingAccount value)  checkingAccount,required TResult Function( EntryAccountUnavailable value)  accountUnavailable,required TResult Function( EntrySetupRequired value)  setupRequired,required TResult Function( EntryReady value)  ready,}){
final _that = this;
switch (_that) {
case EntryRestoringSession():
return restoringSession(_that);case EntrySessionUnavailable():
return sessionUnavailable(_that);case EntryOnboarding():
return onboarding(_that);case EntryLogin():
return login(_that);case EntryCheckingAccount():
return checkingAccount(_that);case EntryAccountUnavailable():
return accountUnavailable(_that);case EntrySetupRequired():
return setupRequired(_that);case EntryReady():
return ready(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EntryRestoringSession value)?  restoringSession,TResult? Function( EntrySessionUnavailable value)?  sessionUnavailable,TResult? Function( EntryOnboarding value)?  onboarding,TResult? Function( EntryLogin value)?  login,TResult? Function( EntryCheckingAccount value)?  checkingAccount,TResult? Function( EntryAccountUnavailable value)?  accountUnavailable,TResult? Function( EntrySetupRequired value)?  setupRequired,TResult? Function( EntryReady value)?  ready,}){
final _that = this;
switch (_that) {
case EntryRestoringSession() when restoringSession != null:
return restoringSession(_that);case EntrySessionUnavailable() when sessionUnavailable != null:
return sessionUnavailable(_that);case EntryOnboarding() when onboarding != null:
return onboarding(_that);case EntryLogin() when login != null:
return login(_that);case EntryCheckingAccount() when checkingAccount != null:
return checkingAccount(_that);case EntryAccountUnavailable() when accountUnavailable != null:
return accountUnavailable(_that);case EntrySetupRequired() when setupRequired != null:
return setupRequired(_that);case EntryReady() when ready != null:
return ready(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  restoringSession,TResult Function()?  sessionUnavailable,TResult Function()?  onboarding,TResult Function()?  login,TResult Function( EntryAccount account)?  checkingAccount,TResult Function( EntryAccount account)?  accountUnavailable,TResult Function( EntryAccount account)?  setupRequired,TResult Function( EntryAccount account)?  ready,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EntryRestoringSession() when restoringSession != null:
return restoringSession();case EntrySessionUnavailable() when sessionUnavailable != null:
return sessionUnavailable();case EntryOnboarding() when onboarding != null:
return onboarding();case EntryLogin() when login != null:
return login();case EntryCheckingAccount() when checkingAccount != null:
return checkingAccount(_that.account);case EntryAccountUnavailable() when accountUnavailable != null:
return accountUnavailable(_that.account);case EntrySetupRequired() when setupRequired != null:
return setupRequired(_that.account);case EntryReady() when ready != null:
return ready(_that.account);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  restoringSession,required TResult Function()  sessionUnavailable,required TResult Function()  onboarding,required TResult Function()  login,required TResult Function( EntryAccount account)  checkingAccount,required TResult Function( EntryAccount account)  accountUnavailable,required TResult Function( EntryAccount account)  setupRequired,required TResult Function( EntryAccount account)  ready,}) {final _that = this;
switch (_that) {
case EntryRestoringSession():
return restoringSession();case EntrySessionUnavailable():
return sessionUnavailable();case EntryOnboarding():
return onboarding();case EntryLogin():
return login();case EntryCheckingAccount():
return checkingAccount(_that.account);case EntryAccountUnavailable():
return accountUnavailable(_that.account);case EntrySetupRequired():
return setupRequired(_that.account);case EntryReady():
return ready(_that.account);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  restoringSession,TResult? Function()?  sessionUnavailable,TResult? Function()?  onboarding,TResult? Function()?  login,TResult? Function( EntryAccount account)?  checkingAccount,TResult? Function( EntryAccount account)?  accountUnavailable,TResult? Function( EntryAccount account)?  setupRequired,TResult? Function( EntryAccount account)?  ready,}) {final _that = this;
switch (_that) {
case EntryRestoringSession() when restoringSession != null:
return restoringSession();case EntrySessionUnavailable() when sessionUnavailable != null:
return sessionUnavailable();case EntryOnboarding() when onboarding != null:
return onboarding();case EntryLogin() when login != null:
return login();case EntryCheckingAccount() when checkingAccount != null:
return checkingAccount(_that.account);case EntryAccountUnavailable() when accountUnavailable != null:
return accountUnavailable(_that.account);case EntrySetupRequired() when setupRequired != null:
return setupRequired(_that.account);case EntryReady() when ready != null:
return ready(_that.account);case _:
  return null;

}
}

}

/// @nodoc


class EntryRestoringSession extends AppEntryState {
  const EntryRestoringSession(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EntryRestoringSession);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppEntryState.restoringSession()';
}


}




/// @nodoc


class EntrySessionUnavailable extends AppEntryState {
  const EntrySessionUnavailable(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EntrySessionUnavailable);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppEntryState.sessionUnavailable()';
}


}




/// @nodoc


class EntryOnboarding extends AppEntryState {
  const EntryOnboarding(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EntryOnboarding);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppEntryState.onboarding()';
}


}




/// @nodoc


class EntryLogin extends AppEntryState {
  const EntryLogin(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EntryLogin);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppEntryState.login()';
}


}




/// @nodoc


class EntryCheckingAccount extends AppEntryState {
  const EntryCheckingAccount(this.account): super._();
  

 final  EntryAccount account;

/// Create a copy of AppEntryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntryCheckingAccountCopyWith<EntryCheckingAccount> get copyWith => _$EntryCheckingAccountCopyWithImpl<EntryCheckingAccount>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EntryCheckingAccount&&(identical(other.account, account) || other.account == account));
}


@override
int get hashCode {
    return Object.hash(runtimeType,account);
}

@override
String toString() {
    return 'AppEntryState.checkingAccount(account: $account)';
}


}

/// @nodoc
abstract mixin class $EntryCheckingAccountCopyWith<$Res> implements $AppEntryStateCopyWith<$Res> {
  factory $EntryCheckingAccountCopyWith(EntryCheckingAccount value, $Res Function(EntryCheckingAccount) _then) = _$EntryCheckingAccountCopyWithImpl;
@useResult
$Res call({
 EntryAccount account
});




}
/// @nodoc
class _$EntryCheckingAccountCopyWithImpl<$Res>
    implements $EntryCheckingAccountCopyWith<$Res> {
  _$EntryCheckingAccountCopyWithImpl(this._self, this._then);

  final EntryCheckingAccount _self;
  final $Res Function(EntryCheckingAccount) _then;

/// Create a copy of AppEntryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? account = null,}) {
  return _then(EntryCheckingAccount(
null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as EntryAccount,
  ));
}


}

/// @nodoc


class EntryAccountUnavailable extends AppEntryState {
  const EntryAccountUnavailable(this.account): super._();
  

 final  EntryAccount account;

/// Create a copy of AppEntryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntryAccountUnavailableCopyWith<EntryAccountUnavailable> get copyWith => _$EntryAccountUnavailableCopyWithImpl<EntryAccountUnavailable>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EntryAccountUnavailable&&(identical(other.account, account) || other.account == account));
}


@override
int get hashCode {
    return Object.hash(runtimeType,account);
}

@override
String toString() {
    return 'AppEntryState.accountUnavailable(account: $account)';
}


}

/// @nodoc
abstract mixin class $EntryAccountUnavailableCopyWith<$Res> implements $AppEntryStateCopyWith<$Res> {
  factory $EntryAccountUnavailableCopyWith(EntryAccountUnavailable value, $Res Function(EntryAccountUnavailable) _then) = _$EntryAccountUnavailableCopyWithImpl;
@useResult
$Res call({
 EntryAccount account
});




}
/// @nodoc
class _$EntryAccountUnavailableCopyWithImpl<$Res>
    implements $EntryAccountUnavailableCopyWith<$Res> {
  _$EntryAccountUnavailableCopyWithImpl(this._self, this._then);

  final EntryAccountUnavailable _self;
  final $Res Function(EntryAccountUnavailable) _then;

/// Create a copy of AppEntryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? account = null,}) {
  return _then(EntryAccountUnavailable(
null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as EntryAccount,
  ));
}


}

/// @nodoc


class EntrySetupRequired extends AppEntryState {
  const EntrySetupRequired(this.account): super._();
  

 final  EntryAccount account;

/// Create a copy of AppEntryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntrySetupRequiredCopyWith<EntrySetupRequired> get copyWith => _$EntrySetupRequiredCopyWithImpl<EntrySetupRequired>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EntrySetupRequired&&(identical(other.account, account) || other.account == account));
}


@override
int get hashCode {
    return Object.hash(runtimeType,account);
}

@override
String toString() {
    return 'AppEntryState.setupRequired(account: $account)';
}


}

/// @nodoc
abstract mixin class $EntrySetupRequiredCopyWith<$Res> implements $AppEntryStateCopyWith<$Res> {
  factory $EntrySetupRequiredCopyWith(EntrySetupRequired value, $Res Function(EntrySetupRequired) _then) = _$EntrySetupRequiredCopyWithImpl;
@useResult
$Res call({
 EntryAccount account
});




}
/// @nodoc
class _$EntrySetupRequiredCopyWithImpl<$Res>
    implements $EntrySetupRequiredCopyWith<$Res> {
  _$EntrySetupRequiredCopyWithImpl(this._self, this._then);

  final EntrySetupRequired _self;
  final $Res Function(EntrySetupRequired) _then;

/// Create a copy of AppEntryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? account = null,}) {
  return _then(EntrySetupRequired(
null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as EntryAccount,
  ));
}


}

/// @nodoc


class EntryReady extends AppEntryState {
  const EntryReady(this.account): super._();
  

 final  EntryAccount account;

/// Create a copy of AppEntryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntryReadyCopyWith<EntryReady> get copyWith => _$EntryReadyCopyWithImpl<EntryReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EntryReady&&(identical(other.account, account) || other.account == account));
}


@override
int get hashCode {
    return Object.hash(runtimeType,account);
}

@override
String toString() {
    return 'AppEntryState.ready(account: $account)';
}


}

/// @nodoc
abstract mixin class $EntryReadyCopyWith<$Res> implements $AppEntryStateCopyWith<$Res> {
  factory $EntryReadyCopyWith(EntryReady value, $Res Function(EntryReady) _then) = _$EntryReadyCopyWithImpl;
@useResult
$Res call({
 EntryAccount account
});




}
/// @nodoc
class _$EntryReadyCopyWithImpl<$Res>
    implements $EntryReadyCopyWith<$Res> {
  _$EntryReadyCopyWithImpl(this._self, this._then);

  final EntryReady _self;
  final $Res Function(EntryReady) _then;

/// Create a copy of AppEntryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? account = null,}) {
  return _then(EntryReady(
null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as EntryAccount,
  ));
}


}

// dart format on
