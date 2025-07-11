// lib/data/datasources/payment_remote_data_source.dart
import 'dart:convert';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/app/core/network/api_client.dart';

import '../models/payment_model.dart';
import '../../domain/entities/payment_entity.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> createPayment({
    required double amount,
    required PaymentMode paymentMode,
  });

  Future<void> updatePaymentStatus({
    required int paymentId,
    required PaymentStatus status,
  });

  Future<PaymentModel> getPaymentById({required int paymentId});
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiClient apiClient;

  PaymentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaymentModel> createPayment({
    required double amount,
    required PaymentMode paymentMode,
  }) async {
    try {
      final response = await apiClient.post(
        '/payments',
        data: jsonEncode({
          'amount': amount,
          'paymentMode': paymentMode == PaymentMode.online ? 'ONLINE' : 'CASH',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.data);
        return PaymentModel.fromJson(jsonResponse);
      } else {
        throw ServerException(
          message: 'Failed to create payment',
          code: response.statusCode.toString(),
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NoInternetException();
    }
  }

  @override
  Future<void> updatePaymentStatus({
    required int paymentId,
    required PaymentStatus status,
  }) async {
    try {
      // This is a dummy implementation for now
      await Future.delayed(const Duration(seconds: 1));

      // Simulate API call
      final response = await apiClient.post(
        '/payments/$paymentId/status',
        data: jsonEncode({
          'status': status == PaymentStatus.completed ? 'COMPLETED' : 'PENDING',
        }),
      );

      if (response.statusCode == null ||
          response.statusCode! < 200 ||
          response.statusCode! >= 300) {
        throw ServerException(
          message: 'Failed to update payment status',
          code: response.statusCode.toString(),
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NoInternetException();
    }
  }

  @override
  Future<PaymentModel> getPaymentById({required int paymentId}) async {
    try {
      final response = await apiClient.get('/payments/$paymentId');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.data);
        return PaymentModel.fromJson(jsonResponse);
      } else {
        throw ServerException(
          message: 'Failed to get payment',
          code: response.statusCode.toString(),
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NoInternetException();
    }
  }
}
