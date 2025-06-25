import 'package:bhoomi_sakti/app/core/providers/core_providers.dart';
import 'package:bhoomi_sakti/features/products/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsCard extends StatelessWidget {
  const ProductsCard({super.key, required this.product, this.onTap});

  final ProductEntity product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer(
              builder: (context, ref, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    product.imageUrl!,
                    height: 118,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: SizedBox(
                          height: 118,
                          child: const Icon(Icons.error, color: Colors.red),
                        ),
                      );
                    },
                    headers: {
                      'Authorization':
                          'Bearer ${ref.read(tokenStorageServiceProvider).accessToken}',
                    },
                  ),
                );
              },
            ),

            SizedBox(height: 12),

            Text(
              product.name,
              style: appTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '₹',
                    style: appTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: product.price.toStringAsFixed(2),
                    style: appTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' /kg',
                    style: appTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (product.description != null) Text(product.description!),
          ],
        ),
      ),
    );
  }
}
