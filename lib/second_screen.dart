import 'package:flutter/material.dart';
import 'database_helper.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List<Map<String, dynamic>> repoList = [];

  Future<void> fetchData() async {
    final data = await DatabaseHelper.instance.fetchRepos();
    setState(() {
      repoList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Second Screen")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: fetchData,
            child: const Text("Load Data"),
          ),
          Expanded(
            child: repoList.isEmpty
                ? const Center(child: Text("No Data Available"))
                : GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: repoList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        repoList[index]["avatar_url"],
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10),
                      Text(repoList[index]["name"],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
