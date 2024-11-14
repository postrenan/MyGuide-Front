import 'package:flutter/material.dart';
import 'package:myguide_app/src/constants/colors.dart';

class Review extends StatelessWidget {
  final String itemName;
  final String imageUrl;

  const Review({super.key, required this.itemName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Review of $itemName'),
        backgroundColor: thirdColor,
      ),
      body: Container(
        color: thirdColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50), 
            Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 300,
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter title',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 300,
                child: TextField(
                  controller: _controller,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Write your review here...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String reviewText = _controller.text;
                String titleText = _titleController.text;
                if (reviewText.isNotEmpty && titleText.isNotEmpty) {
                  print('Review title: $titleText');
                  print('Review submitted: $reviewText');
                  _controller.clear();
                  _titleController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: secundaryColor,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text(
                'Send Review',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
