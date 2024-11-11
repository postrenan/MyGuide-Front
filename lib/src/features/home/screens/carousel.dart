import 'package:flutter/material.dart';
import 'package:myguide_app/src/constants/colors.dart';

class MyCarousel extends StatelessWidget {
  const MyCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: 
      CarouselView(
        itemExtent: 200,
        itemSnapping: true,
        children: List.generate(12, (int index) {
          return Container(
            color: primaryColor,
            child: Image.network(
              'https://picsum.photos/400?random=$index',
              fit: BoxFit.cover,
            ),
          );
        }),
      ),
    );
  }
}