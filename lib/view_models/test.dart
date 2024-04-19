import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// Future<void> main() async {
//   // await dotenv.load();
//   runApp(MyApp());
// }

// class Note {
//   final double latitude;
//   final double longitude;
//   String noteText;
//
//   Note(this.latitude, this.longitude, this.noteText);
// }

// Generate and store the UUID on the user's device
final String appId = const Uuid().v4(); // Generate a new UUID

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getInitialCameraPosition();
  }

  Future<void> _getInitialCameraPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      LatLng initialCameraPosition = LatLng(position.latitude, position.longitude);
      mapController?.moveCamera(CameraUpdate.newLatLngZoom(initialCameraPosition, 17.5));
    } catch (e) {
      print('Error getting initial camera position: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Notes'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        onTap: _addNoteMarker,
        markers: _markers,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0), // Default initial position
          zoom: 17.5,
        ),
      ),
    );
  }

  void _addNoteMarker(LatLng latLng) {
    showDialog(
      context: context,
      builder: (context) => NoteInputDialog(),
    ).then((noteText) {
      if (noteText != null) {
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(latLng.toString()),
              position: latLng,
              onTap: () => _showNoteDetails(latLng, noteText),
            ),
          );
        });

        // Make the API call to create a Note object in the background
        _createNoteOnServerInBackground(latLng.latitude, latLng.longitude, noteText).then((response) {
          // Handle the response if needed (e.g., print success message or update UI)
          print('Note created successfully');
        }).catchError((error) {
          // Handle errors if the API call fails (e.g., show an error message or handle retry logic)
          print('Failed to create note: $error');
        });
      }
    });
  }

  void _showNoteDetails(LatLng latLng, String noteText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Note Details'),
        content: Text(
          'Latitude: ${latLng.latitude}\nLongitude: ${latLng.longitude}\n\nNote: $noteText',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _createNoteOnServerInBackground(double latitude, double longitude, String noteText) {
    final response = http.post(
      Uri.parse('http://127.0.0.1:8000/notes/'), // Replace with your API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "taker": "phone-app",
        "message": noteText,
        "latitude": latitude,
        "longitude": longitude,
      }),
    );

    return response.then((response) {
      if (response.statusCode == 201) {
        // If the API call is successful, return here
        return;
      } else {
        // If the API call fails, throw an exception to be caught by the catchError block
        throw Exception('Failed to create note. Status code: ${response.statusCode}');
      }
    }).catchError((e) {
      // If any error occurs during the API call, throw an exception to be caught by the catchError block
      throw Exception('Error creating note: $e');
    });
  }
}

class NoteInputDialog extends StatefulWidget {
  @override
  _NoteInputDialogState createState() => _NoteInputDialogState();
}

class _NoteInputDialogState extends State<NoteInputDialog> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Note'),
      content: TextField(
        controller: _textEditingController,
        decoration: const InputDecoration(labelText: 'Enter your note'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String noteText = _textEditingController.text;
            Navigator.of(context).pop(noteText);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
