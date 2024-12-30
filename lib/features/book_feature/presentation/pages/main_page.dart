import 'package:flutter/material.dart';
import 'book_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bible Sections')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookPage( section: 'oldTestament',), // Example ID
                  ),
                );
              },
              child: Text('Old Testament'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookPage(section: 'newTestament'), // Example ID
                  ),
                );
              },
              child: Text('New Testament'),
            ),
          ],
        ),
      ),
    );
  }
}
