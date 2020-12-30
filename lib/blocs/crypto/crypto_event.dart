part of 'crypto_bloc.dart';

abstract class CryptoEvent extends Equatable {
  const CryptoEvent();

  @override
  List<Object> get props => [];
}

// Take place when app first starts
class AppStarted extends CryptoEvent {}

// Take place when refreshing the app
class RefreshCoins extends CryptoEvent {}

// Take place when load coins - hit the bottom of scroll view
class LoadMoreCoins extends CryptoEvent {
  // to keep track of coins we already have
  final List<Coin> coins;
  const LoadMoreCoins({this.coins});

  @override
  List<Object> get props => [coins];

  @override
  String toString() {
    return 'LoadMoreCoins { coins: $coins }';
  }
}
