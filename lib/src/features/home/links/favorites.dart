import 'package:flutter/material.dart';
import 'package:myguide_app/src/constants/colors.dart';

class BestShopsPage extends StatelessWidget {
  const BestShopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Shops', style: TextStyle(color:Colors.white,),),
        backgroundColor: const Color(0xFF273F57),
        iconTheme: const IconThemeData(
          color:Colors.white,
        ),  // Azul
      ),
      backgroundColor: thirdColor,
      body: ListView(
        children: [
          _buildShopCard(
            'Loja A',
            'Uma loja incrível com produtos de alta qualidade.',
            'assets/images/shops/shop_a.jpg',
          ),
          _buildShopCard(
            'Loja B',
            'Variedade de produtos e ótimo atendimento.',
            'assets/images/shops/shop_b.jpg',
          ),
          _buildShopCard(
            'Loja C',
            'Preços acessíveis e produtos exclusivos.',
            'assets/images/shops/shop_c.jpg',
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard(String name, String description, String imagePath) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
