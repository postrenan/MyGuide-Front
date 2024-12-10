import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myguide_app/src/constants/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  late Future<List<Review>> reviews;

  @override
  void initState() {
    super.initState();
    reviews = fetchReviews();
  }

  // Função para pegar os dados da API
  Future<List<Review>> fetchReviews() async {
    final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
    final response = await http.get(Uri.parse('${apiUrl}reviews'));

    if (response.statusCode == 200) {
      // Se a resposta for bem-sucedida, parse os dados
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar as avaliações');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reviews de Atrativos Turísticos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF273F57),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: thirdColor,
      body: FutureBuilder<List<Review>>(
        future: reviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Review> reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return _buildReviewCard(
                  reviews[index].title,
                  reviews[index].description,
                  reviews[index].rating,
                );
              },
            );
          } else {
            return const Center(child: Text('Nenhuma avaliação encontrada.'));
          }
        },
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

// Classe Review para mapear os dados recebidos da API
class Review {
  final String title;
  final String description;
  final int rating;

  Review({
    required this.title,
    required this.description,
    required this.rating,
  });

  // Método para converter o JSON da API em um objeto Review
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      title: json['title'],
      description: json['description'],
      rating: json['rating'],
    );
  }
}
