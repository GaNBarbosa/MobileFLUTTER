

import 'package:testepaginas/class/book.dart';

class BookRepository{

  List<Book> _listaBook = [];

  List<Book> get listaBook => this._listaBook;

  set listaBook(List<Book> value) => this._listaBook = value;

  BookRepository();
}