import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AlocRepository {
  final String _baseUrl = 'http://localhost:8080'; // Substitua pelo endereço correto do servidor

  Future<bool> alocarLivro({
    required int userId,
    required int bookId,
    required DateTime alocDate,
    required DateTime returnDate,
    required String status,
  }) async {
    try {
      // Formatação das datas no formato esperado pela API
      final String alocDateFormatted = DateFormat('dd/MM/yyyy').format(alocDate);
      final String returnDateFormatted = DateFormat('dd/MM/yyyy').format(returnDate);

      // Criação do JSON a ser enviado
      final Map<String, dynamic> alocData = {
        'userId': userId,
        'bookId': bookId,
        'alocDate': alocDateFormatted,
        'returnDate': returnDateFormatted,
        'status': status,
      };

      final url = Uri.parse('$_baseUrl/Aloc/insert'); // Substitua pelo endpoint correto
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(alocData),
      );

      if (response.statusCode == 200) {
        print("Alocação realizada com sucesso.");
        return true;
      } else {
        print("Falha na alocação: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Erro ao tentar alocar o livro: $e");
      return false;
    }
  }
}
