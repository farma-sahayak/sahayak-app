import 'package:equatable/equatable.dart';

abstract class MarketEvent extends Equatable {
  const MarketEvent();

  @override
  List<Object?> get props => [];
}

class LoadMarketPrices extends MarketEvent {
  final String? region;

  const LoadMarketPrices({this.region});

  @override
  List<Object?> get props => [region];
}

class SearchCropPrices extends MarketEvent {
  final String query;

  const SearchCropPrices(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadHistoricalPrices extends MarketEvent {
  final String crop;
  final String? region;
  final int days;

  const LoadHistoricalPrices({
    required this.crop,
    this.region,
    this.days = 7,
  });

  @override
  List<Object?> get props => [crop, region, days];
}

class LoadMarketInsights extends MarketEvent {
  const LoadMarketInsights();
}

class RefreshMarketData extends MarketEvent {
  const RefreshMarketData();
}

class SubscribeToPriceAlert extends MarketEvent {
  final String farmerId;
  final String crop;
  final double threshold;
  final String condition;

  const SubscribeToPriceAlert({
    required this.farmerId,
    required this.crop,
    required this.threshold,
    required this.condition,
  });

  @override
  List<Object?> get props => [farmerId, crop, threshold, condition];
}