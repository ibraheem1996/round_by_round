// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_setup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountSetupState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountSetupState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountSetupState()';
}


}

/// @nodoc
class $AccountSetupStateCopyWith<$Res>  {
$AccountSetupStateCopyWith(AccountSetupState _, $Res Function(AccountSetupState) __);
}


/// Adds pattern-matching-related methods to [AccountSetupState].
extension AccountSetupStatePatterns on AccountSetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AccountSetupChecking value)?  checking,TResult Function( AccountSetupUnavailable value)?  unavailable,TResult Function( AccountSetupEditing value)?  editing,TResult Function( AccountSetupReady value)?  ready,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AccountSetupChecking() when checking != null:
return checking(_that);case AccountSetupUnavailable() when unavailable != null:
return unavailable(_that);case AccountSetupEditing() when editing != null:
return editing(_that);case AccountSetupReady() when ready != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AccountSetupChecking value)  checking,required TResult Function( AccountSetupUnavailable value)  unavailable,required TResult Function( AccountSetupEditing value)  editing,required TResult Function( AccountSetupReady value)  ready,}){
final _that = this;
switch (_that) {
case AccountSetupChecking():
return checking(_that);case AccountSetupUnavailable():
return unavailable(_that);case AccountSetupEditing():
return editing(_that);case AccountSetupReady():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AccountSetupChecking value)?  checking,TResult? Function( AccountSetupUnavailable value)?  unavailable,TResult? Function( AccountSetupEditing value)?  editing,TResult? Function( AccountSetupReady value)?  ready,}){
final _that = this;
switch (_that) {
case AccountSetupChecking() when checking != null:
return checking(_that);case AccountSetupUnavailable() when unavailable != null:
return unavailable(_that);case AccountSetupEditing() when editing != null:
return editing(_that);case AccountSetupReady() when ready != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  checking,TResult Function()?  unavailable,TResult Function( double weight,  WeightSaveStatus saveStatus)?  editing,TResult Function( AccountProfile profile)?  ready,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AccountSetupChecking() when checking != null:
return checking();case AccountSetupUnavailable() when unavailable != null:
return unavailable();case AccountSetupEditing() when editing != null:
return editing(_that.weight,_that.saveStatus);case AccountSetupReady() when ready != null:
return ready(_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  checking,required TResult Function()  unavailable,required TResult Function( double weight,  WeightSaveStatus saveStatus)  editing,required TResult Function( AccountProfile profile)  ready,}) {final _that = this;
switch (_that) {
case AccountSetupChecking():
return checking();case AccountSetupUnavailable():
return unavailable();case AccountSetupEditing():
return editing(_that.weight,_that.saveStatus);case AccountSetupReady():
return ready(_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  checking,TResult? Function()?  unavailable,TResult? Function( double weight,  WeightSaveStatus saveStatus)?  editing,TResult? Function( AccountProfile profile)?  ready,}) {final _that = this;
switch (_that) {
case AccountSetupChecking() when checking != null:
return checking();case AccountSetupUnavailable() when unavailable != null:
return unavailable();case AccountSetupEditing() when editing != null:
return editing(_that.weight,_that.saveStatus);case AccountSetupReady() when ready != null:
return ready(_that.profile);case _:
  return null;

}
}

}

/// @nodoc


class AccountSetupChecking implements AccountSetupState {
  const AccountSetupChecking();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountSetupChecking);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountSetupState.checking()';
}


}




/// @nodoc


class AccountSetupUnavailable implements AccountSetupState {
  const AccountSetupUnavailable();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountSetupUnavailable);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AccountSetupState.unavailable()';
}


}




/// @nodoc


class AccountSetupEditing implements AccountSetupState {
  const AccountSetupEditing({required this.weight, required this.saveStatus});
  

 final  double weight;
 final  WeightSaveStatus saveStatus;

/// Create a copy of AccountSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountSetupEditingCopyWith<AccountSetupEditing> get copyWith => _$AccountSetupEditingCopyWithImpl<AccountSetupEditing>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountSetupEditing&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.saveStatus, saveStatus) || other.saveStatus == saveStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,weight,saveStatus);
}

@override
String toString() {
    return 'AccountSetupState.editing(weight: $weight, saveStatus: $saveStatus)';
}


}

/// @nodoc
abstract mixin class $AccountSetupEditingCopyWith<$Res> implements $AccountSetupStateCopyWith<$Res> {
  factory $AccountSetupEditingCopyWith(AccountSetupEditing value, $Res Function(AccountSetupEditing) _then) = _$AccountSetupEditingCopyWithImpl;
@useResult
$Res call({
 double weight, WeightSaveStatus saveStatus
});




}
/// @nodoc
class _$AccountSetupEditingCopyWithImpl<$Res>
    implements $AccountSetupEditingCopyWith<$Res> {
  _$AccountSetupEditingCopyWithImpl(this._self, this._then);

  final AccountSetupEditing _self;
  final $Res Function(AccountSetupEditing) _then;

/// Create a copy of AccountSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weight = null,Object? saveStatus = null,}) {
  return _then(AccountSetupEditing(
weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as WeightSaveStatus,
  ));
}


}

/// @nodoc


class AccountSetupReady implements AccountSetupState {
  const AccountSetupReady(this.profile);
  

 final  AccountProfile profile;

/// Create a copy of AccountSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountSetupReadyCopyWith<AccountSetupReady> get copyWith => _$AccountSetupReadyCopyWithImpl<AccountSetupReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountSetupReady&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode {
    return Object.hash(runtimeType,profile);
}

@override
String toString() {
    return 'AccountSetupState.ready(profile: $profile)';
}


}

/// @nodoc
abstract mixin class $AccountSetupReadyCopyWith<$Res> implements $AccountSetupStateCopyWith<$Res> {
  factory $AccountSetupReadyCopyWith(AccountSetupReady value, $Res Function(AccountSetupReady) _then) = _$AccountSetupReadyCopyWithImpl;
@useResult
$Res call({
 AccountProfile profile
});


$AccountProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$AccountSetupReadyCopyWithImpl<$Res>
    implements $AccountSetupReadyCopyWith<$Res> {
  _$AccountSetupReadyCopyWithImpl(this._self, this._then);

  final AccountSetupReady _self;
  final $Res Function(AccountSetupReady) _then;

/// Create a copy of AccountSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? profile = null,}) {
  return _then(AccountSetupReady(
null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as AccountProfile,
  ));
}

/// Create a copy of AccountSetupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountProfileCopyWith<$Res> get profile {
  
  return $AccountProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
