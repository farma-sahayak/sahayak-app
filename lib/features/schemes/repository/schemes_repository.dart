import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/scheme.dart';
import '../models/benefits_overview.dart';

class SchemesRepository {
  final String baseUrl;
  final http.Client httpClient;

  SchemesRepository({
    this.baseUrl = 'https://api.sahayak.com',
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  // Get all schemes for a farmer
  Future<List<Scheme>> getSchemes({
    String? farmerId,
    String? state,
    String? crop,
    SchemeCategory? category,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (farmerId != null) queryParams['farmer_id'] = farmerId;
      if (state != null) queryParams['state'] = state;
      if (crop != null) queryParams['crop'] = crop;
      if (category != null) queryParams['category'] = category.toString().split('.').last;

      final uri = Uri.parse('$baseUrl/schemes/discover').replace(queryParameters: queryParams);
      final response = await httpClient.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Scheme.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch schemes: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data for development
      return _getMockSchemes();
    }
  }

  // Get benefits overview for a farmer
  Future<BenefitsOverview> getBenefitsOverview(String farmerId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/schemes/benefits-overview?farmer_id=$farmerId'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return BenefitsOverview.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch benefits overview: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data for development
      return _getMockBenefitsOverview();
    }
  }

  // Check eligibility for a specific scheme
  Future<Map<String, dynamic>> checkEligibility(String farmerId, String schemeId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/schemes/$schemeId/eligibility?farmer_id=$farmerId'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to check eligibility: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data for development
      return {
        'eligible': true,
        'missing': <String>[],
        'confidence': 0.95,
      };
    }
  }

  // Apply for a scheme
  Future<Map<String, dynamic>> applyForScheme(String farmerId, String schemeId) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/schemes/apply'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'farmer_id': farmerId,
          'scheme_id': schemeId,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to apply for scheme: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data for development
      return {
        'status': 'submitted',
        'tracking_id': 'APP${DateTime.now().millisecondsSinceEpoch}',
      };
    }
  }

  // Get notifications for schemes
  Future<List<Map<String, dynamic>>> getNotifications(String farmerId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/schemes/notifications?farmer_id=$farmerId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch notifications: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data for development
      return [];
    }
  }

  // Mock data for development
  List<Scheme> _getMockSchemes() {
    final now = DateTime.now();
    return [
      Scheme(
        id: 'SCM001',
        title: 'PM-KISAN',
        subtitle: 'Ministry of Agriculture',
        description: 'Direct income support to farmers with landholding up to 2 hectares',
        provider: 'Ministry of Agriculture & Farmers Welfare',
        benefitAmount: 6000,
        status: SchemeStatus.eligible,
        category: SchemeCategory.income,
        deadline: DateTime(2024, 3, 31),
        eligibilityCriteria: ['Landholder <2ha', 'Aadhaar Linked'],
        tags: ['Small & marginal', 'Land owner'],
        requiredDocuments: ['Aadhaar Card', 'Land Records', 'Bank Details'],
        brochureUrl: 'https://pmkisan.gov.in/Documents/PMKisan.pdf',
        audioGuideUrl: 'https://pmkisan.gov.in/audio/guide.mp3',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      Scheme(
        id: 'SCM002',
        title: 'Pradhan Mantri Fasal Bima Yojana',
        subtitle: 'Ministry of Agriculture',
        description: 'Crop insurance scheme providing coverage against crop losses due to natural calamities, pests & diseases',
        provider: 'Ministry of Agriculture & Farmers Welfare',
        benefitAmount: 200000,
        status: SchemeStatus.applied,
        category: SchemeCategory.insurance,
        deadline: DateTime(2024, 12, 31),
        eligibilityCriteria: ['All farmers', 'Crop cultivation'],
        tags: ['All farmers', 'Crop insurance'],
        requiredDocuments: ['Aadhaar Card', 'Land Records', 'Sowing Certificate'],
        applicationId: 'APP123456',
        progressPercentage: 65.0,
        brochureUrl: 'https://pmfby.gov.in/Documents/PMFBY.pdf',
        audioGuideUrl: 'https://pmfby.gov.in/audio/guide.mp3',
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now,
      ),
      Scheme(
        id: 'SCM003',
        title: 'Soil Health Card Scheme',
        subtitle: 'Department of Agriculture',
        description: 'Free soil testing and nutrient recommendations for better crop yield',
        provider: 'Department of Agriculture & Cooperation',
        benefitAmount: 0,
        status: SchemeStatus.eligible,
        category: SchemeCategory.subsidy,
        deadline: DateTime(2024, 6, 30),
        eligibilityCriteria: ['All farmers', 'Land ownership'],
        tags: ['All farmers', 'Land owner'],
        requiredDocuments: ['Aadhaar Card', 'Land Records'],
        brochureUrl: 'https://soilhealth.dac.gov.in/Documents/SHC.pdf',
        audioGuideUrl: 'https://soilhealth.dac.gov.in/audio/guide.mp3',
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now,
      ),
      Scheme(
        id: 'SCM004',
        title: 'Kisan Credit Card',
        subtitle: 'Ministry of Agriculture',
        description: 'Credit facility for farmers to meet their agricultural needs',
        provider: 'Ministry of Agriculture & Farmers Welfare',
        benefitAmount: 300000,
        status: SchemeStatus.notEligible,
        category: SchemeCategory.loan,
        deadline: DateTime(2024, 12, 31),
        eligibilityCriteria: ['Land ownership', 'Credit history'],
        tags: ['Credit', 'Agricultural needs'],
        requiredDocuments: ['Aadhaar Card', 'Land Records', 'Income Certificate'],
        brochureUrl: 'https://kcc.gov.in/Documents/KCC.pdf',
        audioGuideUrl: 'https://kcc.gov.in/audio/guide.mp3',
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now,
      ),
      Scheme(
        id: 'SCM005',
        title: 'National Agriculture Market',
        subtitle: 'Ministry of Agriculture',
        description: 'Online trading platform for agricultural commodities',
        provider: 'Ministry of Agriculture & Farmers Welfare',
        benefitAmount: 0,
        status: SchemeStatus.approved,
        category: SchemeCategory.other,
        deadline: DateTime(2024, 12, 31),
        eligibilityCriteria: ['All farmers', 'Digital literacy'],
        tags: ['Digital platform', 'Market access'],
        requiredDocuments: ['Aadhaar Card', 'Mobile Number'],
        applicationId: 'APP789012',
        progressPercentage: 100.0,
        brochureUrl: 'https://enam.gov.in/Documents/eNAM.pdf',
        audioGuideUrl: 'https://enam.gov.in/audio/guide.mp3',
        createdAt: now.subtract(const Duration(days: 90)),
        updatedAt: now,
      ),
    ];
  }

  BenefitsOverview _getMockBenefitsOverview() {
    return const BenefitsOverview(
      totalPotentialBenefit: 16000,
      availableNow: 3,
      eligible: 3,
      applied: 1,
      notEligible: 1,
      approved: 1,
      rejected: 0,
    );
  }

  void dispose() {
    httpClient.close();
  }
}