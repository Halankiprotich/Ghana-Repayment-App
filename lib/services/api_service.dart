import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/link.dart';
import '../models/dashboard_stats.dart';

class ApiService {
  final String baseUrl = AppConstants.apiBaseUrl;

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data, {String? token}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to ${endpoint.split('/').last}: ${response.body}');
    }
  }

  Future<dynamic> get(String endpoint, {String? token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch $endpoint: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data, {String? token}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update: ${response.body}');
    }
  }

  Future<void> delete(String endpoint, {String? token}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete: ${response.body}');
    }
  }

  // Auth endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    return await post('auth/login', {'email': email, 'password': password});
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    return await post('auth/register', data);
  }

  // Link endpoints
  Future<List<RepaymentLink>> getLinks(String token) async {
    final response = await get('links', token: token);

    // Handle different response formats
    List<dynamic> dataList = [];

    if (response is List) {
      dataList = response;
    } else if (response is Map && response.containsKey('data')) {
      dataList = response['data'];
    } else if (response is Map && response.containsKey('content')) {
      dataList = response['content'];
    } else if (response is Map && response is! List) {
      // If response is a single object, wrap it in a list
      dataList = [response];
    }

    return dataList.map((json) => RepaymentLink.fromJson(json)).toList();
  }

  Future<DashboardStats> getDashboardStats(String token) async {
    final response = await get('links/dashboard', token: token);
    return DashboardStats.fromJson(response);
  }

  Future<Map<String, dynamic>> createLink(Map<String, dynamic> data, String token) async {
    return await post('links', data, token: token);
  }

  Future<void> markAsPaid(int linkId, String paymentReference, String token) async {
    await put('links/$linkId/paid', {'paymentReference': paymentReference}, token: token);
  }

  Future<void> cancelLink(int linkId, String token) async {
    await delete('links/$linkId', token: token);
  }

  // Public repayment endpoints
  Future<Map<String, dynamic>> getRepaymentDetails(String tokenId) async {
    final response = await get('repay/$tokenId');
    return response;
  }

  Future<Map<String, dynamic>> processPayment(String tokenId, String walletNumber) async {
    return await post('repay/$tokenId/pay', {'walletNumber': walletNumber});
  }
}