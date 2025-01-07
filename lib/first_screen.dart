
import 'package:database/second_screen.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirstScreen extends StatefulWidget {
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final String apiUrl = "https://api.github.com/users/mralexgray/repos";

  final List<Map<String, dynamic>> repositories = [];

  /// Fetch data from API and store in SQLite
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        repositories.clear(); // Clear list before adding new data

        for (var repo in data) {
          Map<String, dynamic> repoData = {
            "node_id": repo["node_id"],
            "name": repo["name"],
            "avatar_url": repo["owner"]["avatar_url"],
          };

          repositories.add(repoData);
          await DatabaseHelper.instance.insertRepo(repoData);
        }

        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Data saved to local database!")),
        );
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

/*  Future<void> saveData() async {
    for (var repo in repositories) {
      await DatabaseHelper.instance.insertRepo({
        "node_id": repo["node_id"],
        "name": repo["name"],
        "avatar_url": repo["avatar_url"],
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("First Screen")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await fetchData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Data Saved to Local Database")),
                );
              },
              child: const Text("Save Data"),
            ),
            ElevatedButton(
              onPressed: () async {
             Navigator.push(context, MaterialPageRoute(builder: (context) => SecondScreen(),));
              },
              child: const Text("second screen"),
            ),
          ],
        ),
      ),
    );
  }
}
