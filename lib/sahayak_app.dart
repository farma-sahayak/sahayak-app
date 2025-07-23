import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/crops/presentation/bloc/crops_bloc.dart';
import 'package:mobile/features/crops/crops.dart' as crops;
import 'package:mobile/features/crops/data/repositories/crops_repository.dart';
import 'package:mobile/features/home/home.dart';
import 'package:mobile/features/market/market.dart';
import 'package:mobile/main.dart';
import 'package:mobile/core/theme/sahayak_theme.dart';

class SahayakApp extends StatelessWidget {
  const SahayakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              MarketBloc(repository: MarketRepository())
                ..add(const LoadMarketPrices()),
        ),
        BlocProvider(
          create: (context) =>
              HomeBloc(repository: HomeRepository())..add(const LoadHomeData()),
        ),
        BlocProvider(
          create: (context) =>
              CropsBloc(repository: CropsRepository())
                ..add(const crops.LoadCrops()),
        ),
      ],
      child: MaterialApp(
        title: 'Sahayak AI',
        theme: getSahayakTheme(),
        home: const MainTabScaffold(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
