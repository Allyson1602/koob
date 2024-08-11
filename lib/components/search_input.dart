import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/book_data_model.dart';

class SearchInput extends StatefulWidget {
  final Function(List<BookData>) onBooksFetched;

  const SearchInput({super.key, required this.onBooksFetched});

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  String searchValue = '';

  Future<List<BookData>> fetchBooks(String query) async {
    final response = await http.get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['items'] as List).map((item) => BookData.fromJson(item['volumeInfo'])).toList();
    } else {
      throw Exception('Falha ao carregar os livros');
    }
  }

  void onSearchIconPressed() async {
    final books = await fetchBooks(searchValue);
    widget.onBooksFetched(books);
  }

  void onChangedValue(value) {
    setState(() {
      searchValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: onChangedValue,
        decoration: InputDecoration(
          hintText: 'Pesquise pelo nome do livro',
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, size: 32),
            onPressed: onSearchIconPressed,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}
