class DiseaseAnalysisResponse {
  final String status;
  final String message;
  final DiseaseAnalysisData data;

  DiseaseAnalysisResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DiseaseAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return DiseaseAnalysisResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: DiseaseAnalysisData.fromJson(json['data'] ?? {}),
    );
  }

  String get formattedAnalysis {
    final disease = data.analysis.disease;
    final remedy = data.analysis.remedy;
    
    return '''🦠 Disease: ${disease.name}
📉 Severity: ${disease.severity}
💊 Remedy: ${remedy.steps}
📅 Recheck in: ${remedy.recheckDays} days
💰 Estimated cost: ₹${remedy.estimatedCost}''';
  }
}

class DiseaseAnalysisData {
  final UploadInfo uploadInfo;
  final Analysis analysis;

  DiseaseAnalysisData({
    required this.uploadInfo,
    required this.analysis,
  });

  factory DiseaseAnalysisData.fromJson(Map<String, dynamic> json) {
    return DiseaseAnalysisData(
      uploadInfo: UploadInfo.fromJson(json['upload_info'] ?? {}),
      analysis: Analysis.fromJson(json['analysis'] ?? {}),
    );
  }
}

class UploadInfo {
  final String imagePath;
  final String firestorePath;
  final String filename;
  final int fileSize;
  final String contentType;

  UploadInfo({
    required this.imagePath,
    required this.firestorePath,
    required this.filename,
    required this.fileSize,
    required this.contentType,
  });

  factory UploadInfo.fromJson(Map<String, dynamic> json) {
    return UploadInfo(
      imagePath: json['image_path'] ?? '',
      firestorePath: json['firestore_path'] ?? '',
      filename: json['filename'] ?? '',
      fileSize: json['file_size'] ?? 0,
      contentType: json['content_type'] ?? '',
    );
  }
}

class Analysis {
  final Disease disease;
  final Remedy remedy;

  Analysis({
    required this.disease,
    required this.remedy,
  });

  factory Analysis.fromJson(Map<String, dynamic> json) {
    return Analysis(
      disease: Disease.fromJson(json['disease'] ?? {}),
      remedy: Remedy.fromJson(json['remedy'] ?? {}),
    );
  }
}

class Disease {
  final String name;
  final String severity;

  Disease({
    required this.name,
    required this.severity,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      name: json['name'] ?? '',
      severity: json['severity'] ?? '',
    );
  }
}

class Remedy {
  final String steps;
  final int recheckDays;
  final int estimatedCost;

  Remedy({
    required this.steps,
    required this.recheckDays,
    required this.estimatedCost,
  });

  factory Remedy.fromJson(Map<String, dynamic> json) {
    return Remedy(
      steps: json['steps'] ?? '',
      recheckDays: json['recheck_days'] ?? 0,
      estimatedCost: json['estimated_cost'] ?? 0,
    );
  }
} 