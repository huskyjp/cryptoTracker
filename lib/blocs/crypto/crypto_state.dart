import 'package:crypto_bloc/models/coin_model.dart';
import 'package:equatable/equatable.dart';

abstract class CryptoState extends Equatable {
  const CryptoState();

  @override
  List<Object> get props => [];
}

// Initial state - first app is loaded
class CryptoInitial extends CryptoState {}

// Fetching coins - data from API
class CryptoLoading extends CryptoState {}

// Return state once retrieved coins
class CryptoLoaded extends CryptoState {
  final List<Coin> coins;
  const CryptoLoaded({this.coins});

  @override
  // props: compare two instances are equal
  List<Object> get props => [coins];

  @override
  String toString() => 'CryptoLoaded { coins: $coins }';
}

// API request error handling
class CryptoError extends CryptoState {}
