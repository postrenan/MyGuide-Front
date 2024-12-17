import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  final dynamic shop;

  const ShopPage({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          shop['name'] ?? 'Detalhes da Loja',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF273F57), // Azul
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // Cor do botão de voltar
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://picsum.photos/200/150?random=0', // Exemplo de imagem aleatória
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Nome da Loja: ${shop['name'] ?? 'Desconhecido'}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Descrição: ${shop['description'] ?? 'Descrição indisponível'}',
              style: const TextStyle(fontSize: 16),
            ),
            // Adicione mais informações conforme necessário
          ],
        ),
      ),
    );
  }
}
