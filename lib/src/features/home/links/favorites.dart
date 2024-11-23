import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: const Color(0xFF273F57), // Azul
      ),
      body: ListView(
        children: [
          _buildFavoriteCard(
            'Lugar Favorito 1',
            'Descrição do lugar favorito 1.',
            'assets/images/favorites/favorite_1.jpg',
          ),
          _buildFavoriteCard(
            'Lugar Favorito 2',
            'Descrição do lugar favorito 2.',
            'assets/images/favorites/favorite_2.jpg',
          ),
          _buildFavoriteCard(
            'Lugar Favorito 3',
            'Descrição do lugar favorito 3.',
            'assets/images/favorites/favorite_3.jpg',
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(String name, String description, String imagePath) {
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
