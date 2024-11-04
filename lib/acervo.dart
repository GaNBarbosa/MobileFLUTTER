import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:testepaginas/bookdetailpage.dart';
import 'package:testepaginas/class/book.dart';
import 'package:testepaginas/repository/bookRepository.dart';

class Acervo extends StatefulWidget {
  const Acervo({Key? key}) : super(key: key);

  @override
  State<Acervo> createState() => _AcervoState();
}

class _AcervoState extends State<Acervo> {
  BookRepository bookRepository = BookRepository();
  List<Book> livrosExibidos = [];
  final TextEditingController _searchController = TextEditingController();
  late Future<void> livrosCarregados;

  Future<void> carregaLivros() async {
    try {
      var url = Uri.parse("http://localhost:8080/Book/todos");
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        List bookList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
        bookRepository.listaBook = bookList.map((book) => Book.fromJson(book)).toList();
        setState(() {
          livrosExibidos = bookRepository.listaBook;
        });
        print("Livros carregados com sucesso: ${livrosExibidos.length}");
      } else {
        print("Erro ao carregar livros: Código ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao carregar livros: $e");
    }
  }

  Future<void> incrementarAcessos(int bookId) async {
    try {
      var url = Uri.parse("http://localhost:8080/Book/updateAcesses/$bookId");
      var response = await http.put(url);
      if (response.statusCode == 200) {
        print("Acesso incrementado para o livro ID: $bookId");
      } else {
        print("Erro ao incrementar acessos: Código ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao incrementar acessos: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    livrosCarregados = carregaLivros();
    _searchController.addListener(_filtrarLivros);
  }

  void _filtrarLivros() {
    setState(() {
      livrosExibidos = bookRepository.listaBook
          .where((book) => book.title.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 24, 24, 26),
        title: const Text("Acervo"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.person))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar livro',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<void>(
              future: livrosCarregados,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Erro ao carregar livros"));
                } else if (livrosExibidos.isEmpty) {
                  return const Center(child: Text("Nenhum livro disponível."));
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: livrosExibidos.length,
                    itemBuilder: (context, index) {
                      final livro = livrosExibidos[index];
                      return GestureDetector(
                        onTap: () async {
                          await incrementarAcessos(livro.id); // Incrementa acessos ao clicar
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailPage(book: livro),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/covers/${livro.cover}",
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              livro.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              livro.author,
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}