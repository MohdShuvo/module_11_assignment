import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PhotoListScreen(),
    );
  }
}

class PhotoListScreen extends StatefulWidget {
  @override
  _PhotoListScreenState createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {
  List<dynamic> photos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

    if (response.statusCode == 200) {
      setState(() {
        photos = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery App'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return ListTile(
            title: Text(photo['title']),
            leading: Image.network(photo['thumbnailUrl']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoDetailScreen(photo: photo),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PhotoDetailScreen extends StatelessWidget {
  final Map<String, dynamic> photo;

  PhotoDetailScreen({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(photo['url']),
          Text('Title: ${photo['title']}'),
          Text('ID: ${photo['id']}'),
        ],
      ),
    );
  }
}
