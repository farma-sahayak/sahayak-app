import 'package:flutter_bloc/flutter_bloc.dart';
import 'market_event.dart';
import 'market_state.dart';
import '../repositories/market_repository.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final MarketRepository repository;

  MarketBloc({required this.repository}) : super(MarketInitial()) {
    on<LoadMarketPrices>(_onLoadMarketPrices);
    on<SearchCropPrices>(_onSearchCropPrices);
    on<LoadHistoricalPrices>(_onLoadHistoricalPrices);
    on<LoadMarketInsights>(_onLoadMarketInsights);
    on<RefreshMarketData>(_onRefreshMarketData);
    on<SubscribeToPriceAlert>(_onSubscribeToPriceAlert);
  }

  Future<void> _onLoadMarketPrices(
    LoadMarketPrices event,
    Emitter<MarketState> emit,
  ) async {
    try {
      emit(MarketLoading());
      
      final currentPrices = await repository.getCurrentPrices(region: event.region);
      final insights = await repository.getMarketInsights();
      
      emit(MarketLoaded(
        currentPrices: currentPrices,
        insights: insights,
      ));
    } catch (e) {
      emit(MarketError('Failed to load market prices: ${e.toString()}'));
    }
  }

  Future<void> _onSearchCropPrices(
    SearchCropPrices event,
    Emitter<MarketState> emit,
  ) async {
    try {
      if (state is MarketLoaded) {
        final currentState = state as MarketLoaded;
        emit(currentState.copyWith(isSearching: true));
        
        final searchResults = await repository.searchCropPrices(event.query);
        
        emit(currentState.copyWith(
          searchResults: searchResults,
          isSearching: false,
        ));
      }
    } catch (e) {
      emit(MarketError('Failed to search crop prices: ${e.toString()}'));
    }
  }

  Future<void> _onLoadHistoricalPrices(
    LoadHistoricalPrices event,
    Emitter<MarketState> emit,
  ) async {
    try {
      if (state is MarketLoaded) {
        final currentState = state as MarketLoaded;
        
        final historicalPrices = await repository.getHistoricalPrices(
          crop: event.crop,
          region: event.region,
          days: event.days,
        );
        
        emit(currentState.copyWith(
          historicalPrices: historicalPrices,
          selectedCrop: event.crop,
        ));
      }
    } catch (e) {
      emit(MarketError('Failed to load historical prices: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMarketInsights(
    LoadMarketInsights event,
    Emitter<MarketState> emit,
  ) async {
    try {
      final insights = await repository.getMarketInsights();
      
      if (state is MarketLoaded) {
        final currentState = state as MarketLoaded;
        emit(currentState.copyWith(insights: insights));
      } else {
        emit(MarketLoaded(insights: insights));
      }
    } catch (e) {
      emit(MarketError('Failed to load market insights: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshMarketData(
    RefreshMarketData event,
    Emitter<MarketState> emit,
  ) async {
    try {
      final currentPrices = await repository.getCurrentPrices();
      final insights = await repository.getMarketInsights();
      
      if (state is MarketLoaded) {
        final currentState = state as MarketLoaded;
        emit(currentState.copyWith(
          currentPrices: currentPrices,
          insights: insights,
        ));
      } else {
        emit(MarketLoaded(
          currentPrices: currentPrices,
          insights: insights,
        ));
      }
    } catch (e) {
      emit(MarketError('Failed to refresh market data: ${e.toString()}'));
    }
  }

  Future<void> _onSubscribeToPriceAlert(
    SubscribeToPriceAlert event,
    Emitter<MarketState> emit,
  ) async {
    try {
      final success = await repository.subscribeToPriceAlert(
        farmerId: event.farmerId,
        crop: event.crop,
        threshold: event.threshold,
        condition: event.condition,
      );
      
      if (success) {
        emit(MarketAlertSubscribed('Successfully subscribed to price alerts for ${event.crop}'));
      } else {
        emit(const MarketError('Failed to subscribe to price alerts'));
      }
    } catch (e) {
      emit(MarketError('Error subscribing to price alerts: ${e.toString()}'));
    }
  }
}