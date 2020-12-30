import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'package:crypto_bloc/models/coin_model.dart';
import 'package:crypto_bloc/repositories/crypto_repository.dart';
import 'package:crypto_bloc/blocs/crypto/crypto_state.dart';

part 'crypto_event.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository _cryptoRepository;
  // check if cryptoReposutory is not null
  CryptoBloc({@required CryptoRepository cryptoRepository})
      : assert(cryptoRepository != null),
        _cryptoRepository = cryptoRepository,
        super(null);

  // CryptoBloc() : super(CryptoInitial());
  // @override
  CryptoState get initialState => CryptoInitial();

  @override
  Stream<CryptoState> mapEventToState(
    CryptoEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is RefreshCoins) {
      // pass empty list of coins since we just need to get first page of coins
      // empty list will ignore previous whatever coin lists and initialize
      yield* _getCoins(coins: []);
    } else if (event is LoadMoreCoins) {
      yield* _mapLoadMoreCoinsToState(event);
    }
  }

  Stream<CryptoState> _getCoins({List<Coin> coins, int page = 0}) async* {
    // request coins - always default coin list
    try {
      List<Coin> newCoinsList =
          coins + await _cryptoRepository.getTopCoins(page: page);
      yield CryptoLoaded(coins: newCoinsList);
    } catch (err) {
      yield CryptoError();
    }
  }

  Stream<CryptoState> _mapAppStartedToState() async* {
    yield CryptoLoading();
    yield* _getCoins(coins: []);
  }

  Stream<CryptoState> _mapLoadMoreCoinsToState(LoadMoreCoins event) async* {
    // current total coins divided by total page number
    final int nextPage = event.coins.length ~/ CryptoRepository.perPage;
    yield* _getCoins(coins: event.coins, page: nextPage);
  }
}
