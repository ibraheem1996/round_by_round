// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_setup_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountSetupState {

 double get weight; WeightSaveStatus get saveStatus;
/// Create a copy of AccountSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountSetupStateCopyWith<AccountSetupState> get copyWith => _$AccountSetupStateCopyWithImpl<AccountSetupState>(this as AccountSetupState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountSetupState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountSetupState&&(identical(other.weight, _this.weight) || other.weight == _this.weight)&&(identical(other.saveStatus, _this.saveStatus) || other.saveStatus == _this.saveStatus));
}


@override
int get hashCode {
  final _this = this as AccountSetupState;
  return Object.hash(runtimeType,_this.weight,_this.saveStatus);
}

@override
String toString() {
  final _this = this as AccountSetupState;
  return 'AccountSetupState(weight: ${_this.weight}, saveStatus: ${_this.saveStatus})';
}


}

/// @nodoc
abstract mixin class $AccountSetupStateCopyWith<$Res>  {
  factory $AccountSetupStateCopyWith(AccountSetupState value, $Res Function(AccountSetupState) _then) = _$AccountSetupStateCopyWithImpl;
@useResult
$Res call({
 double weight, WeightSaveStatus saveStatus
});




}
/// @nodoc
class _$AccountSetupStateCopyWithImpl<$Res>
    implements $AccountSetupStateCopyWith<$Res> {
  _$AccountSetupStateCopyWithImpl(this._self, this._then);

  final AccountSetupState _self;
  final $Res Function(AccountSetupState) _then;

/// Create a copy of AccountSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weight = null,Object? saveStatus = null,}) {
  return _then(AccountSetupState(
weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as WeightSaveStatus,
  ));
}

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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountSetupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountSetupState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountSetupState value)  $default,){
final _that = this;
switch (_that) {
case _AccountSetupState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountSetupState value)?  $default,){
final _that = this;
switch (_that) {
case _AccountSetupState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double weight,  WeightSaveStatus saveStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountSetupState() when $default != null:
return $default(_that.weight,_that.saveStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double weight,  WeightSaveStatus saveStatus)  $default,) {final _that = this;
switch (_that) {
case _AccountSetupState():
return $default(_that.weight,_that.saveStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double weight,  WeightSaveStatus saveStatus)?  $default,) {final _that = this;
switch (_that) {
case _AccountSetupState() when $default != null:
return $default(_that.weight,_that.saveStatus);case _:
  return null;

}
}

}

/// @nodoc


class _AccountSetupState implements AccountSetupState {
  const _AccountSetupState({required this.weight, this.saveStatus = WeightSaveStatus.idle});
  

@override final  double weight;
@override@JsonKey() final  WeightSaveStatus saveStatus;

/// Create a copy of AccountSetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountSetupStateCopyWith<_AccountSetupState> get copyWith => __$AccountSetupStateCopyWithImpl<_AccountSetupState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountSetupState&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.saveStatus, saveStatus) || other.saveStatus == saveStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,weight,saveStatus);
}

@override
String toString() {
    return 'AccountSetupState(weight: $weight, saveStatus: $saveStatus)';
}


}

/// @nodoc
abstract mixin class _$AccountSetupStateCopyWith<$Res> implements $AccountSetupStateCopyWith<$Res> {
  factory _$AccountSetupStateCopyWith(_AccountSetupState value, $Res Function(_AccountSetupState) _then) = __$AccountSetupStateCopyWithImpl;
@override @useResult
$Res call({
 double weight, WeightSaveStatus saveStatus
});




}
/// @nodoc
class __$AccountSetupStateCopyWithImpl<$Res>
    implements _$AccountSetupStateCopyWith<$Res> {
  __$AccountSetupStateCopyWithImpl(this._self, this._then);

  final _AccountSetupState _self;
  final $Res Function(_AccountSetupState) _then;

/// Create a copy of AccountSetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weight = null,Object? saveStatus = null,}) {
  return _then(_AccountSetupState(
weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as WeightSaveStatus,
  ));
}


}

// dart format on
