import 'dart:convert';
import 'package:http/http.dart' as http;

class Crop {
  final int id;
  final String name;
  final int health;
  final String nextAction;
  final String? notes;

  Crop({
    required this.id,
    required this.name,
    required this.health,
    required this.nextAction,
    this.notes,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      name: json['name'],
      health: json['health'],
      nextAction: json['next_action'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'health': health,
    'next_action': nextAction,
    'notes': notes,
  };
}

class CropService {
  static const String baseUrl = 'http://localhost:8000'; // Update if needed

  static Future<List<Crop>> getCrops() async {
    final response = await http.get(Uri.parse('$baseUrl/crops'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Crop.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load crops');
    }
  }

  static Future<Crop> addCrop(Crop crop) async {
    final response = await http.post(
      Uri.parse('$baseUrl/crops'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(crop.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Crop.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add crop');
    }
  }
}
