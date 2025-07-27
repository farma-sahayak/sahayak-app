# Disease Detection Integration

## Overview
The disease detection feature has been successfully integrated into the Sahayak app. This feature allows users to capture or select plant images and analyze them for disease detection using a backend API.

## Features Implemented

### 1. Image Capture and Selection
- **Camera Capture**: Users can take photos directly using the device camera
- **Gallery Selection**: Users can select existing images from their photo gallery
- **Image Preview**: Selected images are displayed in the UI before analysis

### 2. API Integration
- **Backend Endpoint**: `http://0.0.0.0:8050/api/crop-disease/analyze`
- **Request Format**: Multipart form data with image file
- **Response Handling**: Displays raw response string as-is

### 3. User Interface
- **Modern UI**: Clean, intuitive interface following the app's design system
- **Loading States**: Shows progress indicators during analysis
- **Error Handling**: Displays user-friendly error messages
- **Results Display**: Shows the complete API response in a readable text format with monospace font

## Technical Implementation

### Files Created/Modified

1. **`lib/disease_detection_service.dart`**
   - Handles image capture and API communication
   - Methods: `captureImage()`, `pickImageFromGallery()`, `analyzeDisease()`
   - Returns raw string response from API

2. **`lib/disease_detection_page.dart`**
   - Main UI component (converted from StatelessWidget to StatefulWidget)
   - Integrated image capture, API calls, and result display
   - Displays raw response in a selectable text container

3. **Android Permissions** (`android/app/src/main/AndroidManifest.xml`)
   - Added camera, internet, and storage permissions

4. **iOS Permissions** (`ios/Runner/Info.plist`)
   - Added camera and photo library usage descriptions

### Dependencies Used
- `image_picker: ^1.1.2` - For camera and gallery access
- `http: ^1.0.0` - For API communication

## Usage Instructions

### For Users
1. Navigate to the "Disease" tab in the bottom navigation
2. Tap the camera area or the "Add Photo" button
3. Choose between camera or gallery
4. Select or capture an image
5. Tap "Analyze Disease" to send the image for analysis
6. View the complete analysis result in the text box

### For Developers
1. The backend API should be running on `http://0.0.0.0:8050`
2. The API expects a POST request with multipart form data
3. The image field should be named "image"
4. The API should return a plain text response with disease information

## API Endpoint Details

### Request
```bash
curl -X POST "http://0.0.0.0:8050/api/crop-disease/analyze" \
  -F "image=@plant_disease.jpg"
```

### Response Format
The API should return a plain text response with disease information, for example:
```
🦠 Disease: Septoria leaf spot
📉 Severity: high
💊 Remedy: - Immediately remove and destroy all heavily infected leaves and stems to reduce the source of inoculum. Clean up all fallen debris from around the base of the plants.
•⁠  ⁠Apply a broad-spectrum systemic fungicide containing active ingredients like Azoxystrobin or Propiconazole. For severe infections, repeat the application every 7-14 days as per the product label.
•⁠  ⁠After treatment, apply a layer of organic mulch around the plant base to create a barrier that prevents fungal spores from splashing from the soil onto the leaves.
📅 Recheck in: 10 days
💰 Estimated cost: ₹650
```

## Error Handling
- Network errors are caught and displayed to users
- Invalid images are handled gracefully
- API errors show appropriate error messages
- Loading states prevent multiple simultaneous requests

## Future Enhancements
- Voice description feature (UI already prepared)
- Sample photos gallery
- Audio guide for better image capture
- Offline mode with cached results
- Multiple image analysis
- Disease history tracking

## Testing
The integration has been tested with:
- ✅ App compilation and build
- ✅ Permission handling
- ✅ UI responsiveness
- ✅ Error scenarios

To test the full functionality, ensure the backend API is running on the specified endpoint. 