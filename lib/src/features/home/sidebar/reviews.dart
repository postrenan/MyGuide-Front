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
  late Future<List<Shop>> shops;
  int selectedShopId = 1;
  int userId = 1;

  @override
  void initState() {
    super.initState();
    reviews = fetchReviews();
    shops = fetchShops();
  }

  // Função para pegar as avaliações da API
  Future<List<Review>> fetchReviews() async {
    final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
    final response = await http.get(Uri.parse('${apiUrl}reviews'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar as avaliações');
    }
  }

  // Função para pegar as lojas da API
  Future<List<Shop>> fetchShops() async {
    final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
    final response = await http.get(Uri.parse('${apiUrl}shops'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Shop.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar as lojas');
    }
  }

  // Função para adicionar uma nova avaliação
  Future<void> addReview(String title, String description, int picture) async {
    final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
    final response = await http.post(
      Uri.parse('${apiUrl}reviews'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'description': description,
        'picture': picture,
        'shop': {
          'connect': {'id': selectedShopId}
        },
        'user': {
          'connect': {'id': userId},
        },
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        reviews = fetchReviews();
      });
    } else {
      throw Exception('Falha ao adicionar a avaliação');
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
                return _buildReviewCard(reviews[index]);
              },
            );
          } else {
            return const Center(child: Text('Nenhuma avaliação encontrada.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddReviewDialog(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF273F57),
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              review.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text('Loja: ${review.shopName}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 5),
            Text('Usuário: ${review.userName} - ${review.userEmail}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _pictureController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Nova Avaliação'),
          content: FutureBuilder<List<Shop>>(
            future: shops,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              } else if (snapshot.hasData) {
                List<Shop> shopList = snapshot.data!;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Título'),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                    ),
                    TextField(
                      controller: _pictureController,
                      decoration: const InputDecoration(labelText: 'Imagem (ID)'),
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButton<int>(
                      hint: const Text('Selecione a loja'),
                      value: selectedShopId,
                      onChanged: (newValue) {
                        setState(() {
                          selectedShopId = newValue!;
                        });
                      },
                      items: shopList.map((shop) {
                        return DropdownMenuItem<int>(
                          value: shop.id,
                          child: Text(shop.name),
                        );
                      }).toList(),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('Nenhuma loja encontrada.'));
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_pictureController.text.isNotEmpty) {
                  addReview(
                    _titleController.text,
                    _descriptionController.text,
                    int.parse(_pictureController.text),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }
}

class Review {
  final String title;
  final String description;
  final String shopName;
  final String userName;
  final String userEmail;

  Review({
    required this.title,
    required this.description,
    required this.shopName,
    required this.userName,
    required this.userEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      title: json['title'],
      description: json['description'],
      shopName: json['shop']['name'],
      userName: json['user']['name'],
      userEmail: json['user']['email'],
    );
  }
}

class Shop {
  final int id;
  final String name;

  Shop({required this.id, required this.name});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
    );
  }
}
