import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = 'MPbk0sB2A6PhnZwCOhapHZXbWVx2irSUASLqhgLwbpgERjtXqbb8Ijio';

void main() {
  runApp(PexelsImageSearchApp());
}

class PexelsImageSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PEXELS SEARCH',
      home: PexelsImageSearchPage(),
    );
  }
}

class PexelsImageSearchPage extends StatefulWidget {
  @override
  _PexelsImageSearchPageState createState() => _PexelsImageSearchPageState();
}

class _PexelsImageSearchPageState extends State<PexelsImageSearchPage> {
  var images = [];

  @override
  void initState() {
    super.initState();
    fetchImages('voiture');
  }

  Future<void> fetchImages(String query) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/search?query=$query'),
        headers: {'Authorization': apiKey},
      );
      if (response.statusCode == 200) {
        setState(() {
          final data = jsonDecode(response.body);
          images = data['photos'];
        });
      } else {
        print('Erreur de chargement des images: ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors de la récupération des images: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pexels Image Search App'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              print('bouton presse');
              fetchImages('ville');
            },
            child: Text('Rechercher des images sur Pexels'),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              images[index]['photographer'],
                            ),
                            content: Container(
                                color: Colors.amber,
                                child: Image.network(
                                  images[index]['src']['medium'],
                                  fit: BoxFit.cover,
                                )),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: Container(
                      margin: EdgeInsets.all(2),
                      child: Image.network(
                        images[index]['src']['small'],
                        fit: BoxFit.cover,
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

/*   ViewImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Dialog Title'),
            content: Container(
                color: Colors.amber,
                child: Image.network(
                  images[index]['src']['small'],
                  fit: BoxFit.cover,
                )),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  } */
}
