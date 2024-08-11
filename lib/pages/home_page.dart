import 'package:flutter/material.dart';
import 'package:koob/components/search_input.dart';

import '../components/book_card.dart';
import '../models/book_data_model.dart';
import 'book_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BookData> books = [];

  void _handleBooksFetched(List<BookData> fetchedBooks) {
    setState(() {
      books = fetchedBooks;
    });
  }

  void onPressedGoMyBooks() {
    Navigator.pushNamed(context, '/book', arguments: BookPageArguments(false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: SafeArea(
            child: Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onPressedGoMyBooks,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A3FF), // C
                      ),
                      child: const Text('Meus livros',
                        style: TextStyle(
                          color: Color(0xffffffff),
                        ),),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: SearchInput(onBooksFetched: _handleBooksFetched),
                  ),
                  Expanded(
                    flex: 5,
                    child: ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return BookCard(
                          bookData: book,
                          isRemoved: false,
                        );
                      },
                    ),
                  ),
                ],
            ),
          )
      ),
    );
  }
}