import 'package:flutter/material.dart';
import 'package:myguide_app/src/constants/colors.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews de Atrativos Turísticos',style: TextStyle(color:Colors.white,),),
        backgroundColor: const Color(0xFF273F57),
        iconTheme: const IconThemeData(
          color:Colors.white,
        ), // Azul
      ),
      backgroundColor: thirdColor,
      body: ListView(
        children: [
          _buildReviewCard(
            'Cristo Redentor',
            'Um dos pontos turísticos mais famosos do Brasil. A vista é incrível!',
            5,
          ),
          _buildReviewCard(
            'Pão de Açúcar',
            'A subida de bondinho é uma experiência única. Recomendo!',
            4,
          ),
          _buildReviewCard(
            'Cataratas do Iguaçu',
            'As cataratas são impressionantes. Vale a pena a visita!',
            5,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String title, String description, int rating) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(description),
            const SizedBox(height: 5),
            Row(
              children: List.generate(rating, (index) {
                return const Icon(Icons.star, color: Colors.amber);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
