import 'package:equatable/equatable.dart';
import '../models/scheme.dart';

abstract class SchemesEvent extends Equatable {
  const SchemesEvent();

  @override
  List<Object?> get props => [];
}

class LoadSchemes extends SchemesEvent {
  final String? farmerId;
  final String? state;
  final String? crop;
  final SchemeCategory? category;

  const LoadSchemes({
    this.farmerId,
    this.state,
    this.crop,
    this.category,
  });

  @override
  List<Object?> get props => [farmerId, state, crop, category];
}

class LoadBenefitsOverview extends SchemesEvent {
  final String farmerId;

  const LoadBenefitsOverview({required this.farmerId});

  @override
  List<Object?> get props => [farmerId];
}

class RefreshSchemes extends SchemesEvent {
  final String? farmerId;
  final String? state;
  final String? crop;
  final SchemeCategory? category;

  const RefreshSchemes({
    this.farmerId,
    this.state,
    this.crop,
    this.category,
  });

  @override
  List<Object?> get props => [farmerId, state, crop, category];
}

class ApplyForScheme extends SchemesEvent {
  final String farmerId;
  final String schemeId;

  const ApplyForScheme({
    required this.farmerId,
    required this.schemeId,
  });

  @override
  List<Object?> get props => [farmerId, schemeId];
}

class CheckSchemeEligibility extends SchemesEvent {
  final String farmerId;
  final String schemeId;

  const CheckSchemeEligibility({
    required this.farmerId,
    required this.schemeId,
  });

  @override
  List<Object?> get props => [farmerId, schemeId];
}

class FilterSchemes extends SchemesEvent {
  final SchemeStatus? status;
  final SchemeCategory? category;
  final String? searchQuery;

  const FilterSchemes({
    this.status,
    this.category,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [status, category, searchQuery];
}

class PlayAudioGuide extends SchemesEvent {
  final String audioUrl;

  const PlayAudioGuide({required this.audioUrl});

  @override
  List<Object?> get props => [audioUrl];
}

class DownloadBrochure extends SchemesEvent {
  final String brochureUrl;
  final String schemeName;

  const DownloadBrochure({
    required this.brochureUrl,
    required this.schemeName,
  });

  @override
  List<Object?> get props => [brochureUrl, schemeName];
}

class LoadNotifications extends SchemesEvent {
  final String farmerId;

  const LoadNotifications({required this.farmerId});

  @override
  List<Object?> get props => [farmerId];
}