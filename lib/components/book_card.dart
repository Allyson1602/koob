import 'package:flutter/material.dart';

import '../models/book_data_model.dart';
import '../pages/book_page.dart';
import '../shared_preferences/book.dart';

class BookCard extends StatelessWidget {
  final BookData bookData;
  final bool isRemoved;
  final VoidCallback? onRemove;

  const BookCard({
    super.key,
    required this.bookData,
    required this.isRemoved,
    this.onRemove,
  });

  void onPressedBookCard(BuildContext context) {
    showModal(context);
  }

  void onPressedOwnedBooks(BuildContext context) async {
    var updatedBookData = bookData.copyWith(wasRead: false);

    await deleteBook(updatedBookData.title);
    await saveBook(updatedBookData);

    Navigator.of(context).pop();
    Navigator.pushNamed(context, '/book', arguments: BookPageArguments(false));
  }

  void onPressedReadBooks(BuildContext context) async {
    var updatedBookData = bookData.copyWith(wasRead: true);

    await deleteBook(updatedBookData.title);
    await saveBook(updatedBookData);

    Navigator.of(context).pop();
    Navigator.pushNamed(context, '/book', arguments: BookPageArguments(true));
  }

  void onPressedRemoveBook(BuildContext context) async {
    Navigator.of(context).pop();

    if (isRemoved) {
      onRemove!();
    }
  }

  void showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'O que deseja fazer com o livro?',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (bookData.wasRead == null || bookData.wasRead == true)
              SizedBox(
                width: double.infinity,
                child:
                ElevatedButton(
                  onPressed: () => onPressedOwnedBooks(context),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: const Color(0xFF00A3FF)
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      'Mover para livros possuídos',
                      style: TextStyle(
                        color: Color(0xffffffff),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ),
              ),
              const SizedBox(height: 8),
              if (bookData.wasRead == null || bookData.wasRead == false)
              SizedBox(
                width: double.infinity,
                child:
                ElevatedButton(
                  onPressed: () => onPressedReadBooks(context),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: const Color(0xFF00A3FF)
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      'Mover para livros lidos',
                      style: TextStyle(
                        color: Color(0xffffffff),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              if (isRemoved)
              const SizedBox(height: 8),
              if (isRemoved)
                ElevatedButton(
                  onPressed: () => onPressedRemoveBook(context),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: const Color(0xfffef7ff),
                  ),
                  child: const Text(
                    'remover livro',
                    style: TextStyle(
                      color: Color(0xffBD0000),
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressedBookCard(context),
      child: Card(
        elevation: 3,
        color: const Color(0xFF98DAFF),
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  bookData.title,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        bookData.authors,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(bookData.publishedDate, style: const TextStyle(fontSize: 14, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w500),),
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}