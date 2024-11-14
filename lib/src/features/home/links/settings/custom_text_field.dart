import 'package:flutter/material.dart';

Widget buildTextField(String hintText, double width, TextEditingController controller) {
  return SizedBox(
    width: width,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,  // Exibe o nome do campo como dica (placeholder)
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),  // Estilo do texto do hint
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    ),
  );
}