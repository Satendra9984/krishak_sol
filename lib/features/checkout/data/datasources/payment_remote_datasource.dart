// lib/data/datasources/payment_remote_data_source.dart
import 'dart:convert';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/app/core/network/api_client.dart';
import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_mode.dart';
import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_status.dart';
import '../models/payment_model.dart';

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
        data: {
          'amount': amount,
          'paymentMode': paymentMode.value.toUpperCase(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = {
          'paymentId': response.data['paymentId'],
          'amount': response.data['amount'] ?? amount,
          'paymentMode': response.data['paymentMode'] ?? paymentMode.value,
          'status': response.data['status'] ?? PaymentStatus.pending.value,
          'cashfreeOrderResponse': response.data['cashfreeOrderResponse'],
        };
        return PaymentModel.fromJson(jsonResponse);
      } else {
        throw ServerException(
          message: 'Failed to create payment',
          code: response.statusCode.toString(),
        );
      }
    } catch (e) {
      e;
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
      // final response = await apiClient.post(
      //   '/payments/$paymentId/status',
      //   data: {'status': status.value},
      // );

      // if (response.statusCode == null ||
      //     response.statusCode! < 200 ||
      //     response.statusCode! >= 300) {
      //   throw ServerException(
      //     message: 'Failed to update payment status',
      //     code: response.statusCode.toString(),
      //   );
      // }
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
        final Map<String, dynamic> jsonResponse = response.data;
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
