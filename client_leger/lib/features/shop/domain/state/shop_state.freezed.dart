// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ShopState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<ShopItemModel> catalogue,
      List<ShopCatalogItemId> purchasedItems,
      int balance,
    )
    loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
      List<ShopItemModel> catalogue,
      List<ShopCatalogItemId> purchasedItems,
      int balance,
    )?
    loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
      List<ShopItemModel> catalogue,
      List<ShopCatalogItemId> purchasedItems,
      int balance,
    )?
    loaded,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShopStateLoading value) loading,
    required TResult Function(ShopStateLoaded value) loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShopStateLoading value)? loading,
    TResult? Function(ShopStateLoaded value)? loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShopStateLoading value)? loading,
    TResult Function(ShopStateLoaded value)? loaded,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopStateCopyWith<$Res> {
  factory $ShopStateCopyWith(ShopState value, $Res Function(ShopState) then) =
      _$ShopStateCopyWithImpl<$Res, ShopState>;
}

/// @nodoc
class _$ShopStateCopyWithImpl<$Res, $Val extends ShopState>
    implements $ShopStateCopyWith<$Res> {
  _$ShopStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShopState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ShopStateLoadingImplCopyWith<$Res> {
  factory _$$ShopStateLoadingImplCopyWith(
    _$ShopStateLoadingImpl value,
    $Res Function(_$ShopStateLoadingImpl) then,
  ) = __$$ShopStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ShopStateLoadingImplCopyWithImpl<$Res>
    extends _$ShopStateCopyWithImpl<$Res, _$ShopStateLoadingImpl>
    implements _$$ShopStateLoadingImplCopyWith<$Res> {
  __$$ShopStateLoadingImplCopyWithImpl(
    _$ShopStateLoadingImpl _value,
    $Res Function(_$ShopStateLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShopState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ShopStateLoadingImpl implements ShopStateLoading {
  const _$ShopStateLoadingImpl();

  @override
  String toString() {
    return 'ShopState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ShopStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<ShopItemModel> catalogue,
      List<ShopCatalogItemId> purchasedItems,
      int balance,
    )
    loaded,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
      List<ShopItemModel> catalogue,
      List<ShopCatalogItemId> purchasedItems,
      int balance,
    )?
    loaded,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
      List<ShopItemModel> catalogue,
      List<ShopCatalogItemId> purchasedItems,
      int balance,
    )?
    loaded,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShopStateLoading value) loading,
    required TResult Function(ShopStateLoaded value) loaded,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShopStateLoading value)? loading,
    TResult? Function(ShopStateLoaded value)? loaded,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShopStateLoading value)? loading,
    TResult Function(ShopStateLoaded value)? loaded,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ShopStateLoading implements ShopState {
  const factory ShopStateLoading() = _$ShopStateLoadingImpl;
}

/// @nodoc
abstract class _$$ShopStateLoadedImplCopyWith<$Res> {
  factory _$$ShopStateLoadedImplCopyWith(
    _$ShopStateLoadedImpl value,
    $Res Function(_$ShopStateLoadedImpl) then,
  ) = __$$ShopStateLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<ShopItemModel> catalogue,
    List<ShopCatalogItemId> purchasedItems,
    int balance,
  });
}

/// @nodoc
class __$$ShopStateLoadedImplCopyWithImpl<$Res>
    extends _$ShopStateCopyWithImpl<$Res, _$ShopStateLoadedImpl>
    implements _$$ShopStateLoadedImplCopyWith<$Res> {
  __$$ShopStateLoadedImplCopyWithImpl(
    _$ShopStateLoadedImpl _value,
    $Res Function(_$ShopStateLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShopState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? catalogue = null,
    Object? purchasedItems = null,
    Object? balance = null,
  }) {
    return _then(
      _$ShopStateLoadedImpl(
        catalogue: null == catalogue
            ? _value._catalogue
            : catalogue // ignore: cast_nullable_to_non_nullable
                  as List<ShopItemModel>,
        purchasedItems: null == purchasedItems
            ? _value._purchasedItems
            : purchasedItems // ignore: cast_nullable_to_non_nullable
                  as List<ShopCatalogItemId>,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$ShopStateLoadedImpl implements ShopStateLoaded {
  const _$ShopStateLoadedImpl({
    required final List<ShopItemModel> catalogue,
    required final List<ShopCatalogItemId> purchasedItems,
    required this.balance,
  }) : _catalogue = catalogue,
       _purchasedItems = purchasedItems;

  final List<ShopItemModel> _catalogue;
  @override
  List<ShopItemModel> get catalogue {
    if (_catalogue is EqualUnmodifiableListView) return _catalogue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_catalogue);
  }

  final List<ShopCatalogItemId> _purchasedItems;
  @override
  List<ShopCatalogItemId> get purchasedItems {
    if (_purchasedItems is EqualUnmodifiableListView) return _purchasedItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_purchasedItems);
  }

  @override
  final int balance;

  @override
  String toString() {
    return 'ShopState.loaded(catalogue: $catalogue, purchasedItems: $purchasedItems, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopStateLoadedImpl &&
            const DeepCollectionEquality().equals(
              other._catalogue,
              _catalogue,
            ) &&
            const DeepCollectionEquality().equals(
              other._purchasedItems,
              _purchasedItems,
            ) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_catalogue),
    const DeepCollectionEquality().hash(_purchasedItems),
    balance,
  );

  /// Create a copy of ShopState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopStateLoadedImplCopyWith<_$ShopStateLoadedImpl> get copyWith =>
      __$$ShopStateLoadedImplCopyWithImpl<_$ShopStateLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<ShopItemModel> catalogue,
      List<ShopCatalogItemId> purchasedItems,
      int balance,
    )
    loaded,
  }) {
    return loaded(catalogue, purchasedItems, balance);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
      List<ShopItemModel> catalogue,
      List<ShopCatalogItemId> purchasedItems,
      int balance,
    )?
    loaded,
  }) {
    return loaded?.call(catalogue, purchasedItems, balance);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
      List<ShopItemModel> catalogue,
      List<ShopCatalogItemId> purchasedItems,
      int balance,
    )?
    loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(catalogue, purchasedItems, balance);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShopStateLoading value) loading,
    required TResult Function(ShopStateLoaded value) loaded,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShopStateLoading value)? loading,
    TResult? Function(ShopStateLoaded value)? loaded,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShopStateLoading value)? loading,
    TResult Function(ShopStateLoaded value)? loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ShopStateLoaded implements ShopState {
  const factory ShopStateLoaded({
    required final List<ShopItemModel> catalogue,
    required final List<ShopCatalogItemId> purchasedItems,
    required final int balance,
  }) = _$ShopStateLoadedImpl;

  List<ShopItemModel> get catalogue;
  List<ShopCatalogItemId> get purchasedItems;
  int get balance;

  /// Create a copy of ShopState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShopStateLoadedImplCopyWith<_$ShopStateLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
