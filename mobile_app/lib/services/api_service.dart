import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // رابط السيرفر المباشر المرفوع على Render
  static const String baseUrl = 'https://xcash-1.onrender.com/api';

  // جلب رصيد المحفظة من السيرفر
  static Future<Map<String, dynamic>> getWalletBalance(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/wallet/$userId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'فشل الاتصال بالسيرفر: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'خطأ في الشبكة: $e'};
    }
  }

  // شحن رصيد X Cash
  static Future<Map<String, dynamic>> topUpWallet(int userId, double amountUsd) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wallet/topup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'amountUsd': amountUsd,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'error': 'خطأ في شحن الرصيد: $e'};
    }
  }
}
