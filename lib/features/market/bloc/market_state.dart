import 'package:equatable/equatable.dart';
import '../models/market_price.dart';
import '../models/market_insight.dart';

abstract class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object?> get props => [];
}

class MarketInitial extends MarketState {}

class MarketLoading extends MarketState {}

class MarketLoaded extends MarketState {
  final List<MarketPrice> currentPrices;
  final List<MarketPrice> searchResults;
  final List<MarketPrice> historicalPrices;
  final List<MarketInsight> insights;
  final String? selectedCrop;
  final bool isSearching;

  const MarketLoaded({
    this.currentPrices = const [],
    this.searchResults = const [],
    this.historicalPrices = const [],
    this.insights = const [],
    this.selectedCrop,
    this.isSearching = false,
  });

  MarketLoaded copyWith({
    List<MarketPrice>? currentPrices,
    List<MarketPrice>? searchResults,
    List<MarketPrice>? historicalPrices,
    List<MarketInsight>? insights,
    String? selectedCrop,
    bool? isSearching,
  }) {
    return MarketLoaded(
      currentPrices: currentPrices ?? this.currentPrices,
      searchResults: searchResults ?? this.searchResults,
      historicalPrices: historicalPrices ?? this.historicalPrices,
      insights: insights ?? this.insights,
      selectedCrop: selectedCrop ?? this.selectedCrop,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [
    currentPrices,
    searchResults,
    historicalPrices,
    insights,
    selectedCrop,
    isSearching,
  ];
}

class MarketError extends MarketState {
  final String message;

  const MarketError(this.message);

  @override
  List<Object?> get props => [message];
}

class MarketAlertSubscribed extends MarketState {
  final String message;

  const MarketAlertSubscribed(this.message);

  @override
  List<Object?> get props => [message];
}