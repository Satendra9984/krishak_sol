import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/features/products/data/models/product_model.dart';
import 'package:bhoomi_sakti/app/core/network/api_client.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient _dio;

  ProductRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map(
              (json) => ProductModel.fromJson({
                ...json,
                'imageUrl': "${_dio.baseUrl}/uploads/${json['imageUrl']}",
              }),
            )
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to load products: ${response.statusCode}',
        );
      }
    } on ServerException catch (e) {
      throw ServerException(message: 'Failed to load products: ${e.message}');
    } catch (e) {
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }
}
