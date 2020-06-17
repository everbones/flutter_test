import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
void main() {
  runApp(MyApp());
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
class User{
  final int id;
  final String name;
  final String email;

  User({this.id,this.name,this.email});
  factory User.fromJson(Map<String,dynamic> json){
    return User(
      id : json["id"],
      name : json["username"],
      email: json["email"],
    );
  }
}
Future<Album> fetchAlbum() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/2');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
Future<User> fetchUser() async {
  final token = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhYmMiLCJjcmVhdGVkIjoxNTkxMjM1MjM1NTAwLCJleHAiOjE1OTE4NDAwMzV9.6SmfW64NcLQ8-15_R8WYXstJLFM7ibnxmln1bxoZNlXZWluEVcDsRDIp9g0r_9Z1syZIZrfZjA9DnzcDfr0CAQ";
  final response =
      await http.get('http://10.0.2.2:8080/users/1',
        headers:{HttpHeaders.authorizationHeader : token } 
      );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return User.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
class _MyAppState extends State<MyApp> {
  Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<User>(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.email);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}