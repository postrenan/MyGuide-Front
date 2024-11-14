import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myguide_app/src/constants/colors.dart';
import 'package:myguide_app/src/features/home/links/reviews/review.dart';

class MyCarousel extends StatelessWidget {
  final String title;
  final List<String> itemNames;

  const MyCarousel({
    super.key,
    required this.title,
    required this.itemNames,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemNames.length,
            itemBuilder: (context, index) {
              final randomValue = random.nextInt(1000);
              final imageUrl = 'https://picsum.photos/400?random=$randomValue';

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Review(
                        itemName: itemNames[index],
                        imageUrl: imageUrl, 
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  width: 200,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        color: primaryColor,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Text(
                            itemNames[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
