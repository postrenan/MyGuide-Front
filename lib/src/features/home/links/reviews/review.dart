import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myguide_app/src/constants/colors.dart';

class Review extends StatefulWidget {
  final String itemName;
  final String imageUrl;

  const Review({super.key, required this.itemName, required this.imageUrl});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  TextEditingController titleController = TextEditingController();
  TextEditingController controller = TextEditingController();
  double rating = 0.0; // Variável para armazenar a avaliação

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review of ${widget.itemName}'),
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
                  widget.imageUrl,
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 300,
              child: TextField(
                controller: titleController,
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
            const SizedBox(height: 16),
            SizedBox(
              width: 300,
              child: TextField(
                controller: controller,
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
            const SizedBox(height: 16),
            Text(
              'Your Rating:',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String reviewText = controller.text;
                String titleText = titleController.text;
                if (reviewText.isNotEmpty && titleText.isNotEmpty) {
                  print('Review title: $titleText');
                  print('Review submitted: $reviewText');
                  print('Rating: $rating');
                  controller.clear();
                  titleController.clear();
                  setState(() {
                    rating = 0.0;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: secundaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text(
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
