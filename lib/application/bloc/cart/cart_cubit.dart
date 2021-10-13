import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery_app/application/bloc/auth/auth_bloc.dart';
import 'package:food_delivery_app/core/failure.dart';
import 'package:food_delivery_app/domain/entities/cart_item.dart';

import 'package:food_delivery_app/domain/repositories/cart_repository_interface.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_state.dart';
part "cart_cubit.freezed.dart";

class CartCubit extends Cubit<CartState> {
  final CartRepositoryInterface _cartRepo;
  final AuthBloc _authBloc;
  late StreamSubscription authChange;
  CartCubit(this._cartRepo, this._authBloc)
      : super(CartState(items: const [], failure: none(), totalPrice: 0)) {
    authChange = _authBloc.stream.listen((authState) {
      authState.maybeWhen(
        authenticated: (user) async {
          final result = await _cartRepo.getCartitems(user.id);
          result.fold(
              (failure) => emit(state.copyWith(failure: some(failure))),
              (items) => emit(state.copyWith(
                    failure: none(),
                    items: items,
                  )));
        },
        orElse: () {
          emit(state.copyWith(items: const [], failure: none(), totalPrice: 0));
        },
      );
    });
  }

  void addCartItem(CartItem item) {
    _authBloc.state.whenOrNull(
      authenticated: (user) async {
        List<CartItem> items = [...state.items];
        if (state.items.any((element) => element.id == item.id)) {
          final index =
              state.items.indexWhere((element) => element.id == item.id);
          items[index] = items[index]
              .copyWithQuantity(items[index].quantity + item.quantity);
          final result = await _cartRepo.updateCartItem(
              item.id, items[index].quantity, user.id);
          result.fold((failure) => emit(state.copyWith(failure: some(failure))),
              (_) => emit(state.copyWith(items: items)));
        } else {
          items.add(item);
          final result =
              await _cartRepo.addCartItem(item.id, item.quantity, user.id);
          result.fold((failure) => emit(state.copyWith(failure: some(failure))),
              (_) => emit(state.copyWith(items: items)));
        }
      },
    );
  }

  void deleteCartItem(String id) {
    _authBloc.state.whenOrNull(authenticated: (user) async {
      var items = [...state.items];
      if (state.items.any((element) => element.id == id)) {
        items.removeWhere((element) => element.id == id);
        final result = await _cartRepo.deleteCartItem(id, user.id);
        result.fold((failure) => emit(state.copyWith(failure: some(failure))),
            (_) => emit(state.copyWith(items: items)));
      }
    });
  }

  void increaseCartQty(String id) async {
    _authBloc.state.whenOrNull(authenticated: (user) async {
      var items = [...state.items];

      if (state.items.any((element) => element.id == id)) {
        final index = items.indexWhere((element) => element.id == id);

        items[index] = items[index].copyWithQuantity(items[index].quantity + 1);

        final result = await _cartRepo.updateCartItem(
            items[index].id, items[index].quantity, user.id);

        result.fold((failure) => emit(state.copyWith(failure: some(failure))),
            (r) => emit(state.copyWith(items: items)));
      }
    });
  }

  void decreaseCartQty(String id) {
    _authBloc.state.whenOrNull(authenticated: (user) async {
      var items = [...state.items];

      if (state.items.any((element) => element.id == id)) {
        final index = items.indexWhere((element) => element.id == id);

        if (items[index].quantity <= 1) {
          return;
        }
        items[index] = items[index].copyWithQuantity(items[index].quantity - 1);

        final result = await _cartRepo.updateCartItem(
            items[index].id, items[index].quantity, user.id);

        result.fold((failure) => emit(state.copyWith(failure: some(failure))),
            (_) => emit(state.copyWith(items: items)));
      }
    });
  }
}
