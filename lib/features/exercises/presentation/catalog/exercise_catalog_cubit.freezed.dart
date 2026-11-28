// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_catalog_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExerciseCatalogState {

 bool get loading; bool get failed; String get search; Set<ExerciseGroup> get groups; Set<Equipment> get equipment; List<ExerciseDefinition> get results;
/// Create a copy of ExerciseCatalogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseCatalogStateCopyWith<ExerciseCatalogState> get copyWith => _$ExerciseCatalogStateCopyWithImpl<ExerciseCatalogState>(this as ExerciseCatalogState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExerciseCatalogState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseCatalogState&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.failed, _this.failed) || other.failed == _this.failed)&&(identical(other.search, _this.search) || other.search == _this.search)&&const DeepCollectionEquality().equals(other.groups, _this.groups)&&const DeepCollectionEquality().equals(other.equipment, _this.equipment)&&const DeepCollectionEquality().equals(other.results, _this.results));
}


@override
int get hashCode {
  final _this = this as ExerciseCatalogState;
  return Object.hash(runtimeType,_this.loading,_this.failed,_this.search,const DeepCollectionEquality().hash(_this.groups),const DeepCollectionEquality().hash(_this.equipment),const DeepCollectionEquality().hash(_this.results));
}

@override
String toString() {
  final _this = this as ExerciseCatalogState;
  return 'ExerciseCatalogState(loading: ${_this.loading}, failed: ${_this.failed}, search: ${_this.search}, groups: ${_this.groups}, equipment: ${_this.equipment}, results: ${_this.results})';
}


}

/// @nodoc
abstract mixin class $ExerciseCatalogStateCopyWith<$Res>  {
  factory $ExerciseCatalogStateCopyWith(ExerciseCatalogState value, $Res Function(ExerciseCatalogState) _then) = _$ExerciseCatalogStateCopyWithImpl;
@useResult
$Res call({
 bool loading, bool failed, String search, Set<ExerciseGroup> groups, Set<Equipment> equipment, List<ExerciseDefinition> results
});




}
/// @nodoc
class _$ExerciseCatalogStateCopyWithImpl<$Res>
    implements $ExerciseCatalogStateCopyWith<$Res> {
  _$ExerciseCatalogStateCopyWithImpl(this._self, this._then);

  final ExerciseCatalogState _self;
  final $Res Function(ExerciseCatalogState) _then;

/// Create a copy of ExerciseCatalogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? failed = null,Object? search = null,Object? groups = null,Object? equipment = null,Object? results = null,}) {
  return _then(ExerciseCatalogState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as Set<ExerciseGroup>,equipment: null == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as Set<Equipment>,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<ExerciseDefinition>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseCatalogState].
extension ExerciseCatalogStatePatterns on ExerciseCatalogState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseCatalogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseCatalogState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseCatalogState value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseCatalogState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseCatalogState value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseCatalogState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool failed,  String search,  Set<ExerciseGroup> groups,  Set<Equipment> equipment,  List<ExerciseDefinition> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseCatalogState() when $default != null:
return $default(_that.loading,_that.failed,_that.search,_that.groups,_that.equipment,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool failed,  String search,  Set<ExerciseGroup> groups,  Set<Equipment> equipment,  List<ExerciseDefinition> results)  $default,) {final _that = this;
switch (_that) {
case _ExerciseCatalogState():
return $default(_that.loading,_that.failed,_that.search,_that.groups,_that.equipment,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool failed,  String search,  Set<ExerciseGroup> groups,  Set<Equipment> equipment,  List<ExerciseDefinition> results)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseCatalogState() when $default != null:
return $default(_that.loading,_that.failed,_that.search,_that.groups,_that.equipment,_that.results);case _:
  return null;

}
}

}

/// @nodoc


class _ExerciseCatalogState extends ExerciseCatalogState {
  const _ExerciseCatalogState({this.loading = true, this.failed = false, this.search = '',  Set<ExerciseGroup> groups = const {},  Set<Equipment> equipment = const {},  List<ExerciseDefinition> results = const []}): _groups = groups,_equipment = equipment,_results = results,super._();
  

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool failed;
@override@JsonKey() final  String search;
 final  Set<ExerciseGroup> _groups;
@override@JsonKey() Set<ExerciseGroup> get groups {
  if (_groups is EqualUnmodifiableSetView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_groups);
}

 final  Set<Equipment> _equipment;
@override@JsonKey() Set<Equipment> get equipment {
  if (_equipment is EqualUnmodifiableSetView) return _equipment;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_equipment);
}

 final  List<ExerciseDefinition> _results;
@override@JsonKey() List<ExerciseDefinition> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of ExerciseCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseCatalogStateCopyWith<_ExerciseCatalogState> get copyWith => __$ExerciseCatalogStateCopyWithImpl<_ExerciseCatalogState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseCatalogState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.search, search) || other.search == search)&&const DeepCollectionEquality().equals(other.groups, _groups)&&const DeepCollectionEquality().equals(other.equipment, _equipment)&&const DeepCollectionEquality().equals(other.results, _results));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loading,failed,search,const DeepCollectionEquality().hash(_groups),const DeepCollectionEquality().hash(_equipment),const DeepCollectionEquality().hash(_results));
}

@override
String toString() {
    return 'ExerciseCatalogState(loading: $loading, failed: $failed, search: $search, groups: $groups, equipment: $equipment, results: $results)';
}


}

/// @nodoc
abstract mixin class _$ExerciseCatalogStateCopyWith<$Res> implements $ExerciseCatalogStateCopyWith<$Res> {
  factory _$ExerciseCatalogStateCopyWith(_ExerciseCatalogState value, $Res Function(_ExerciseCatalogState) _then) = __$ExerciseCatalogStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool failed, String search, Set<ExerciseGroup> groups, Set<Equipment> equipment, List<ExerciseDefinition> results
});




}
/// @nodoc
class __$ExerciseCatalogStateCopyWithImpl<$Res>
    implements _$ExerciseCatalogStateCopyWith<$Res> {
  __$ExerciseCatalogStateCopyWithImpl(this._self, this._then);

  final _ExerciseCatalogState _self;
  final $Res Function(_ExerciseCatalogState) _then;

/// Create a copy of ExerciseCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? failed = null,Object? search = null,Object? groups = null,Object? equipment = null,Object? results = null,}) {
  return _then(_ExerciseCatalogState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as Set<ExerciseGroup>,equipment: null == equipment ? _self._equipment : equipment // ignore: cast_nullable_to_non_nullable
as Set<Equipment>,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<ExerciseDefinition>,
  ));
}


}

// dart format on
