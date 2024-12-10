import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _selectedStars = 1;
  bool _isLoading = false;
  List<Map<String, dynamic>> _reviews = []; // Lista de reviews

  // Função para carregar todas as reviews do usuário
  Future<void> _loadUserReviews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
      final response = await http.get(Uri.parse('${apiUrl}reviews/user'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _reviews = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading reviews')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para adicionar uma nova review
  Future<void> _addReview() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';
      final response = await http.post(
        Uri.parse('${apiUrl}reviews'),
        body: {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'stars': _selectedStars.toString(),
          // Adicione aqui o campo para o ID do estabelecimento selecionado
          'shopId': '123', // Isso deve ser dinamicamente preenchido
        },
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review added successfully')),
        );
        _loadUserReviews(); // Recarregar as reviews
      } else {
        throw Exception('Failed to add review');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding review')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para abrir o modal de adicionar review
  void _openAddReviewModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo para título
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              // Campo para descrição
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              // Seleção de estrelas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _selectedStars
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.yellow[700],
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedStars = index + 1;
                      });
                    },
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _titleController.clear();
                _descriptionController.clear();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _isLoading ? null : _addReview,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserReviews(); // Carregar as reviews ao iniciar a página
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Reviews'),
        backgroundColor: const Color(0xFF273F57),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _reviews.isEmpty
                ? const Center(child: Text('You have not added any reviews yet.'))
                : ListView.builder(
                    itemCount: _reviews.length,
                    itemBuilder: (context, index) {
                      final review = _reviews[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(review['title']),
                          subtitle: Text(review['description']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${review['stars']}★'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddReviewModal, // Abre o modal para adicionar review
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF273F57),
      ),
    );
  }
}
