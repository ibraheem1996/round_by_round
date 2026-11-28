// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExerciseDefinition {

 String get exerciseId; ExerciseSource get source; String? get nameAr; String? get nameEn; List<String> get aliases; ExerciseActivity get activity; ExerciseTrackingType get trackingType; ExerciseGroup get group; Equipment? get equipment; int get sortOrder;
/// Create a copy of ExerciseDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseDefinitionCopyWith<ExerciseDefinition> get copyWith => _$ExerciseDefinitionCopyWithImpl<ExerciseDefinition>(this as ExerciseDefinition, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExerciseDefinition;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseDefinition&&(identical(other.exerciseId, _this.exerciseId) || other.exerciseId == _this.exerciseId)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.nameAr, _this.nameAr) || other.nameAr == _this.nameAr)&&(identical(other.nameEn, _this.nameEn) || other.nameEn == _this.nameEn)&&const DeepCollectionEquality().equals(other.aliases, _this.aliases)&&(identical(other.activity, _this.activity) || other.activity == _this.activity)&&(identical(other.trackingType, _this.trackingType) || other.trackingType == _this.trackingType)&&(identical(other.group, _this.group) || other.group == _this.group)&&(identical(other.equipment, _this.equipment) || other.equipment == _this.equipment)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder));
}


@override
int get hashCode {
  final _this = this as ExerciseDefinition;
  return Object.hash(runtimeType,_this.exerciseId,_this.source,_this.nameAr,_this.nameEn,const DeepCollectionEquality().hash(_this.aliases),_this.activity,_this.trackingType,_this.group,_this.equipment,_this.sortOrder);
}

@override
String toString() {
  final _this = this as ExerciseDefinition;
  return 'ExerciseDefinition(exerciseId: ${_this.exerciseId}, source: ${_this.source}, nameAr: ${_this.nameAr}, nameEn: ${_this.nameEn}, aliases: ${_this.aliases}, activity: ${_this.activity}, trackingType: ${_this.trackingType}, group: ${_this.group}, equipment: ${_this.equipment}, sortOrder: ${_this.sortOrder})';
}


}

/// @nodoc
abstract mixin class $ExerciseDefinitionCopyWith<$Res>  {
  factory $ExerciseDefinitionCopyWith(ExerciseDefinition value, $Res Function(ExerciseDefinition) _then) = _$ExerciseDefinitionCopyWithImpl;
@useResult
$Res call({
 String exerciseId, ExerciseSource source, String? nameAr, String? nameEn, List<String> aliases, ExerciseActivity activity, ExerciseTrackingType trackingType, ExerciseGroup group, Equipment? equipment, int sortOrder
});




}
/// @nodoc
class _$ExerciseDefinitionCopyWithImpl<$Res>
    implements $ExerciseDefinitionCopyWith<$Res> {
  _$ExerciseDefinitionCopyWithImpl(this._self, this._then);

  final ExerciseDefinition _self;
  final $Res Function(ExerciseDefinition) _then;

/// Create a copy of ExerciseDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseId = null,Object? source = null,Object? nameAr = freezed,Object? nameEn = freezed,Object? aliases = null,Object? activity = null,Object? trackingType = null,Object? group = null,Object? equipment = freezed,Object? sortOrder = null,}) {
  return _then(ExerciseDefinition(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ExerciseSource,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,aliases: null == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ExerciseActivity,trackingType: null == trackingType ? _self.trackingType : trackingType // ignore: cast_nullable_to_non_nullable
as ExerciseTrackingType,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as ExerciseGroup,equipment: freezed == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as Equipment?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseDefinition].
extension ExerciseDefinitionPatterns on ExerciseDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseDefinition value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String exerciseId,  ExerciseSource source,  String? nameAr,  String? nameEn,  List<String> aliases,  ExerciseActivity activity,  ExerciseTrackingType trackingType,  ExerciseGroup group,  Equipment? equipment,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseDefinition() when $default != null:
return $default(_that.exerciseId,_that.source,_that.nameAr,_that.nameEn,_that.aliases,_that.activity,_that.trackingType,_that.group,_that.equipment,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String exerciseId,  ExerciseSource source,  String? nameAr,  String? nameEn,  List<String> aliases,  ExerciseActivity activity,  ExerciseTrackingType trackingType,  ExerciseGroup group,  Equipment? equipment,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _ExerciseDefinition():
return $default(_that.exerciseId,_that.source,_that.nameAr,_that.nameEn,_that.aliases,_that.activity,_that.trackingType,_that.group,_that.equipment,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String exerciseId,  ExerciseSource source,  String? nameAr,  String? nameEn,  List<String> aliases,  ExerciseActivity activity,  ExerciseTrackingType trackingType,  ExerciseGroup group,  Equipment? equipment,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseDefinition() when $default != null:
return $default(_that.exerciseId,_that.source,_that.nameAr,_that.nameEn,_that.aliases,_that.activity,_that.trackingType,_that.group,_that.equipment,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc


class _ExerciseDefinition extends ExerciseDefinition {
  const _ExerciseDefinition({required this.exerciseId, required this.source, this.nameAr, this.nameEn, required  List<String> aliases, required this.activity, required this.trackingType, required this.group, this.equipment, required this.sortOrder}): _aliases = aliases,super._();
  

@override final  String exerciseId;
@override final  ExerciseSource source;
@override final  String? nameAr;
@override final  String? nameEn;
 final  List<String> _aliases;
@override List<String> get aliases {
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aliases);
}

@override final  ExerciseActivity activity;
@override final  ExerciseTrackingType trackingType;
@override final  ExerciseGroup group;
@override final  Equipment? equipment;
@override final  int sortOrder;

/// Create a copy of ExerciseDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseDefinitionCopyWith<_ExerciseDefinition> get copyWith => __$ExerciseDefinitionCopyWithImpl<_ExerciseDefinition>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseDefinition&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.source, source) || other.source == source)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&const DeepCollectionEquality().equals(other.aliases, _aliases)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.trackingType, trackingType) || other.trackingType == trackingType)&&(identical(other.group, group) || other.group == group)&&(identical(other.equipment, equipment) || other.equipment == equipment)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode {
    return Object.hash(runtimeType,exerciseId,source,nameAr,nameEn,const DeepCollectionEquality().hash(_aliases),activity,trackingType,group,equipment,sortOrder);
}

@override
String toString() {
    return 'ExerciseDefinition(exerciseId: $exerciseId, source: $source, nameAr: $nameAr, nameEn: $nameEn, aliases: $aliases, activity: $activity, trackingType: $trackingType, group: $group, equipment: $equipment, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$ExerciseDefinitionCopyWith<$Res> implements $ExerciseDefinitionCopyWith<$Res> {
  factory _$ExerciseDefinitionCopyWith(_ExerciseDefinition value, $Res Function(_ExerciseDefinition) _then) = __$ExerciseDefinitionCopyWithImpl;
@override @useResult
$Res call({
 String exerciseId, ExerciseSource source, String? nameAr, String? nameEn, List<String> aliases, ExerciseActivity activity, ExerciseTrackingType trackingType, ExerciseGroup group, Equipment? equipment, int sortOrder
});




}
/// @nodoc
class __$ExerciseDefinitionCopyWithImpl<$Res>
    implements _$ExerciseDefinitionCopyWith<$Res> {
  __$ExerciseDefinitionCopyWithImpl(this._self, this._then);

  final _ExerciseDefinition _self;
  final $Res Function(_ExerciseDefinition) _then;

/// Create a copy of ExerciseDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseId = null,Object? source = null,Object? nameAr = freezed,Object? nameEn = freezed,Object? aliases = null,Object? activity = null,Object? trackingType = null,Object? group = null,Object? equipment = freezed,Object? sortOrder = null,}) {
  return _then(_ExerciseDefinition(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ExerciseSource,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,aliases: null == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ExerciseActivity,trackingType: null == trackingType ? _self.trackingType : trackingType // ignore: cast_nullable_to_non_nullable
as ExerciseTrackingType,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as ExerciseGroup,equipment: freezed == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as Equipment?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
