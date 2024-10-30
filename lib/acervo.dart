import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:testepaginas/class/book.dart';
import 'package:testepaginas/repository/bookRepository.dart';

class Acervo extends StatefulWidget {
  const Acervo({super.key});

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
      // Atualize o URL conforme necessário (ex: '10.0.2.2' para emulador Android)
      var url = Uri.parse("http://10.0.2.2:8080/Book/todos");
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        List booklist = jsonDecode(response.body) as List;
        bookRepository.listaBook = booklist.map((book) => Book.fromJson(book)).toList();
        livrosExibidos = bookRepository.listaBook;
        print("Livros carregados com sucesso: ${livrosExibidos.length}");
      } else {
        print("Erro ao carregar livros: Código ${response.statusCode}");
        throw Exception('Falha ao carregar livros');
      }
    } catch (e) {
      print("Erro ao carregar livros: $e");
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
      body: SingleChildScrollView(
        child: Column(
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
            const SizedBox(height: 20),
            FutureBuilder<void>(
              future: livrosCarregados,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erro ao carregar livros"));
                } else if (livrosExibidos.isEmpty) {
                  return Center(child: Text("Nenhum livro disponível."));
                } else {
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Dois livros por linha
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.7, // Ajuste para exibir imagens e textos bem alinhados
                    ),
                    itemCount: livrosExibidos.length,
                    itemBuilder: (context, index) {
                      final livro = livrosExibidos[index];
                      return Column(
                        children: [
                          Image.network(livro.cover, width: 100, height: 150, fit: BoxFit.cover),
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
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
