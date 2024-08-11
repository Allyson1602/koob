import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/book_data_model.dart';

Future<void> saveBook(BookData book) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> bookList = prefs.getStringList('savedBooks') ?? [];

  bookList.add(jsonEncode({
    'title': book.title,
    'authors': book.authors,
    'publishedDate': book.publishedDate,
    'wasRead': book.wasRead
  }));

  await prefs.setStringList('savedBooks', bookList);
}

Future<List<BookData>> listBook() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? bookList = prefs.getStringList('savedBooks');

  if (bookList != null) {
    return bookList.map((book) {
      Map<String, dynamic> bookMap = jsonDecode(book);
      return BookData.fromJson(bookMap);
    }).toList();
  } else {
    return [];
  }
}

Future<void> deleteBook(String title) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> bookList = prefs.getStringList('savedBooks') ?? [];

  bookList.removeWhere((book) {
    final bookMap = jsonDecode(book);

    return bookMap['title'] == title;
  });

  await prefs.setStringList('savedBooks', bookList);
}
