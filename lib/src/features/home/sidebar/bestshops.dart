import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myguide_app/src/constants/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BestShopsPage extends StatefulWidget {
  const BestShopsPage({super.key});

  @override
  _BestShopsPageState createState() => _BestShopsPageState();
}

class _BestShopsPageState extends State<BestShopsPage> {
  late Future<List<Shop>> shops;

  @override
  void initState() {
    super.initState();
    shops = fetchBestShops();
  }

  // Função para pegar as melhores lojas da API
  Future<List<Shop>> fetchBestShops() async {
    final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
    final response = await http.get(Uri.parse('${apiUrl}best-shops'));

    if (response.statusCode == 200) {
      // Se a resposta for bem-sucedida, parse os dados
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Shop.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar as melhores lojas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Melhores Lojas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF273F57),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: thirdColor,
      body: FutureBuilder<List<Shop>>(
        future: shops,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Shop> shopList = snapshot.data!;
            return ListView.builder(
              itemCount: shopList.length,
              itemBuilder: (context, index) {
                return _buildShopCard(
                  shopList[index].name,
                  shopList[index].description,
                  shopList[index].imagePath,
                  shopList[index].rating,
                );
              },
            );
          } else {
            return const Center(child: Text('Nenhuma loja encontrada.'));
          }
        },
      ),
    );
  }

  Widget _buildShopCard(String name, String description, String imagePath, double rating) {
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
                const SizedBox(height: 5),
                Row(
                  children: List.generate(rating.toInt(), (index) {
                    return const Icon(Icons.star, color: Colors.amber);
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Classe Shop para mapear os dados recebidos da API
class Shop {
  final String name;
  final String description;
  final String imagePath;
  final double rating;

  Shop({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.rating,
  });

  // Método para converter o JSON da API em um objeto Shop
  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
      rating: json['rating'].toDouble(), // Convertendo rating para double
    );
  }
}
