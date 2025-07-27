import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'data/models/disease_analysis_response.dart';

class DiseaseDetectionService {
  static const String baseUrl = 'http://0.0.0.0:8050';
  static const String analyzeEndpoint = '/api/crop-disease/analyze';

  final ImagePicker _picker = ImagePicker();

  /// Capture image from camera
  Future<File?> captureImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to capture image: $e');
    }
  }

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  /// Analyze plant disease using the API
  Future<String> analyzeDisease(File imageFile) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$analyzeEndpoint'),
      );

      // Add image file to request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      // Send request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      print(responseData);

      if (response.statusCode == 200) {
        // Parse JSON response
        final jsonResponse = json.decode(responseData);
        final analysisResponse = DiseaseAnalysisResponse.fromJson(jsonResponse);
        
        // Return formatted analysis
        return analysisResponse.formattedAnalysis;
      } else {
        throw Exception('API request failed with status: ${response.statusCode}, response: $responseData');
      }
    } catch (e) {
      throw Exception('Failed to analyze disease: $e');
    }
  }
} 