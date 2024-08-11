import 'package:flutter/material.dart';

import '../components/book_card.dart';
import '../models/book_data_model.dart';
import '../shared_preferences/book.dart';

class BookPageArguments {
  final bool? wasRead;

  BookPageArguments(this.wasRead);
}

class BookPage extends StatefulWidget {
  final bool? wasRead;

  const BookPage({super.key, this.wasRead});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  void initState() {
    super.initState();
    _loadBooks(widget.wasRead);
  }

  Future<List<BookData>> _loadBooks(bool? wasRead) async {
    List<BookData>? bookList = await listBook();

    return bookList
      .where((book) => book.wasRead == wasRead)
      .toList();
  }

  Future<void> _deleteBook(String title) async {
    await deleteBook(title);
    _loadBooks(widget.wasRead);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: DefaultTabController(
            initialIndex: widget.wasRead == true ? 1 : 0,
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  labelColor: Color(0xFF004395),
                  indicatorColor: Color(0xFF004395),
                  tabs: [
                    Tab(text: 'Possuídos'),
                    Tab(text: 'Lidos'),
                  ],
                ),
                title: const Text('Meus livros'),
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TabBarView(
                  children: [
                    _buildBooksList(false),
                    _buildBooksList(true),
                  ],
                ),
              ),
            ),
          )
        )
      ),
    );
  }

  Widget _buildBooksList(bool wasRead) {
    return FutureBuilder<List<BookData>>(
      future: _loadBooks(wasRead),
      builder: (BuildContext context, AsyncSnapshot<List<BookData>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum livro encontrado.'));
        } else {
          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(
                bookData: book,
                isRemoved: true,
                onRemove: () => _deleteBook(book.title),
              );
            },
          );
        }
      },
    );
  }
}