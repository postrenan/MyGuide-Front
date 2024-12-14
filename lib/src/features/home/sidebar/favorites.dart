import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myguide_app/src/constants/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<Favorite>> favorites;

  @override
  void initState() {
    super.initState();
    favorites = fetchFavorites();
  }

  // Função para pegar os favoritos da API
  Future<List<Favorite>> fetchFavorites() async {
    final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
    final response = await http.get(Uri.parse('${apiUrl}favorites'));

    if (response.statusCode == 200) {
      // Se a resposta for bem-sucedida, parse os dados
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Favorite.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar favoritos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF273F57),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: thirdColor,
      body: FutureBuilder<List<Favorite>>(
        future: favorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Favorite> favoriteList = snapshot.data!;
            return ListView.builder(
              itemCount: favoriteList.length,
              itemBuilder: (context, index) {
                return _buildFavoriteCard(
                  favoriteList[index].name,
                  favoriteList[index].description,
                  favoriteList[index].imagePath,
                );
              },
            );
          } else {
            return const Center(child: Text('Nenhum favorito encontrado.'));
          }
        },
      ),
    );
  }

  Widget _buildFavoriteCard(String name, String description, String imagePath) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imagePath, fit: BoxFit.cover),
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

// Classe Favorite para mapear os dados recebidos da API
class Favorite {
  final String name;
  final String description;
  final String imagePath;

  Favorite({
    required this.name,
    required this.description,
    required this.imagePath,
  });

  // Método para converter o JSON da API em um objeto Favorite
  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'], // Caminho para a imagem
    );
  }
}
