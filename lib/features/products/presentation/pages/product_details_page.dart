import 'package:bhoomi_sakti/common/app_common_providers.dart';
import 'package:bhoomi_sakti/features/cart/cart_providers.dart';
import 'package:bhoomi_sakti/features/products/domain/entities/product_entity.dart';
import 'package:bhoomi_sakti/features/products/products_providers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// 1. Changed to ConsumerWidget to use ref
class ProductDetailsPage extends ConsumerWidget {
  // 2. Changed constructor to accept productId
  const ProductDetailsPage({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. Watch the new provider using the productId
    final productAsyncValue = ref.watch(productDetailsProvider(productId));

    // 4. Handle the async states (loading, error, data)
    return productAsyncValue.when(
      data: (product) => _buildScaffold(context, ref, product),
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (err, stack) => Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: $err')),
          ),
    );
  }

  // 5. Extracted the original Scaffold into its own method
  Scaffold _buildScaffold(
    BuildContext context,
    WidgetRef ref,
    ProductEntity product,
  ) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 28,
              color: theme.colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              FontAwesomeIcons.heart,
              size: 28,
              color: Color(0xffD31D1D),
            ),
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  FontAwesomeIcons.cartShopping,
                  size: 28,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary,
                  ),
                  child: Text(
                    '1',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: const Color(0xffF8F9FE),
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.locationDot,
                      color: Color(0xff3657AD),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Consumer(
                      builder: (context, ref, _) {
                        final userAccount = ref.watch(currentUserProvider);
                        return RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Delivering to ',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text:
                                    userAccount?.location ??
                                    'Select your location',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        // TODO: Handle location change
                                      },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                // TODO: Replace with actual product image
                child: const Icon(Icons.image, size: 100, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Text(
                product.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '₹${product.price.toStringAsFixed(2)}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        return ElevatedButton.icon(
                          onPressed: () {
                            ref
                                .read(addProductToCartUsecaseProvider)
                                .call(product);
                          },
                          icon: Icon(
                            Icons.shopping_cart,
                            color: theme.colorScheme.primary,
                          ),
                          label: Text(
                            'Add to Cart',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            foregroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: theme.colorScheme.primary),
                        ),
                      ),
                      child: Text(
                        'Buy Now',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Color(0xffE0E0E0)),
              const SizedBox(height: 20),
              Text(
                'Product Details',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Table(
                columnWidths: const {
                  0: FractionColumnWidth(0.4),
                  1: FractionColumnWidth(0.6),
                },
                children: [
                  TableRow(
                    children: [
                      Text(
                        'Name',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(product.name),
                      ),
                    ],
                  ),
                  if (product.description != null)
                    TableRow(
                      children: [
                        Text(
                          'Description',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(product.description!),
                        ),
                      ],
                    ),
                  if (product.manufacturer != null)
                    TableRow(
                      children: [
                        Text(
                          'Manufacturer',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(product.manufacturer!),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Color(0xffE0E0E0)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
