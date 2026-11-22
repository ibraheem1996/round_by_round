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

 double get weight;
/// Create a copy of AccountSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountSetupStateCopyWith<AccountSetupState> get copyWith => _$AccountSetupStateCopyWithImpl<AccountSetupState>(this as AccountSetupState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountSetupState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountSetupState&&(identical(other.weight, _this.weight) || other.weight == _this.weight));
}


@override
int get hashCode {
  final _this = this as AccountSetupState;
  return Object.hash(runtimeType,_this.weight);
}

@override
String toString() {
  final _this = this as AccountSetupState;
  return 'AccountSetupState(weight: ${_this.weight})';
}


}

/// @nodoc
abstract mixin class $AccountSetupStateCopyWith<$Res>  {
  factory $AccountSetupStateCopyWith(AccountSetupState value, $Res Function(AccountSetupState) _then) = _$AccountSetupStateCopyWithImpl;
@useResult
$Res call({
 double weight
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
@pragma('vm:prefer-inline') @override $Res call({Object? weight = null,}) {
  return _then(_self.copyWith(
weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AccountSetupEditing value)?  editing,TResult Function( AccountSetupSaved value)?  saved,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AccountSetupEditing() when editing != null:
return editing(_that);case AccountSetupSaved() when saved != null:
return saved(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AccountSetupEditing value)  editing,required TResult Function( AccountSetupSaved value)  saved,}){
final _that = this;
switch (_that) {
case AccountSetupEditing():
return editing(_that);case AccountSetupSaved():
return saved(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AccountSetupEditing value)?  editing,TResult? Function( AccountSetupSaved value)?  saved,}){
final _that = this;
switch (_that) {
case AccountSetupEditing() when editing != null:
return editing(_that);case AccountSetupSaved() when saved != null:
return saved(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( double weight,  WeightSaveStatus saveStatus)?  editing,TResult Function( double weight)?  saved,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AccountSetupEditing() when editing != null:
return editing(_that.weight,_that.saveStatus);case AccountSetupSaved() when saved != null:
return saved(_that.weight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( double weight,  WeightSaveStatus saveStatus)  editing,required TResult Function( double weight)  saved,}) {final _that = this;
switch (_that) {
case AccountSetupEditing():
return editing(_that.weight,_that.saveStatus);case AccountSetupSaved():
return saved(_that.weight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( double weight,  WeightSaveStatus saveStatus)?  editing,TResult? Function( double weight)?  saved,}) {final _that = this;
switch (_that) {
case AccountSetupEditing() when editing != null:
return editing(_that.weight,_that.saveStatus);case AccountSetupSaved() when saved != null:
return saved(_that.weight);case _:
  return null;

}
}

}

/// @nodoc


class AccountSetupEditing implements AccountSetupState {
  const AccountSetupEditing({required this.weight, required this.saveStatus});
  

@override final  double weight;
 final  WeightSaveStatus saveStatus;

/// Create a copy of AccountSetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
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
@override @useResult
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
@override @pragma('vm:prefer-inline') $Res call({Object? weight = null,Object? saveStatus = null,}) {
  return _then(AccountSetupEditing(
weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as WeightSaveStatus,
  ));
}


}

/// @nodoc


class AccountSetupSaved implements AccountSetupState {
  const AccountSetupSaved(this.weight);
  

@override final  double weight;

/// Create a copy of AccountSetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountSetupSavedCopyWith<AccountSetupSaved> get copyWith => _$AccountSetupSavedCopyWithImpl<AccountSetupSaved>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountSetupSaved&&(identical(other.weight, weight) || other.weight == weight));
}


@override
int get hashCode {
    return Object.hash(runtimeType,weight);
}

@override
String toString() {
    return 'AccountSetupState.saved(weight: $weight)';
}


}

/// @nodoc
abstract mixin class $AccountSetupSavedCopyWith<$Res> implements $AccountSetupStateCopyWith<$Res> {
  factory $AccountSetupSavedCopyWith(AccountSetupSaved value, $Res Function(AccountSetupSaved) _then) = _$AccountSetupSavedCopyWithImpl;
@override @useResult
$Res call({
 double weight
});




}
/// @nodoc
class _$AccountSetupSavedCopyWithImpl<$Res>
    implements $AccountSetupSavedCopyWith<$Res> {
  _$AccountSetupSavedCopyWithImpl(this._self, this._then);

  final AccountSetupSaved _self;
  final $Res Function(AccountSetupSaved) _then;

/// Create a copy of AccountSetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weight = null,}) {
  return _then(AccountSetupSaved(
null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
