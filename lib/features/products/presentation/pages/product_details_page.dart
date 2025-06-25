import 'package:bhoomi_sakti/common/app_common_providers.dart';
import 'package:bhoomi_sakti/features/products/domain/entities/product_entity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(
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
                padding: EdgeInsets.symmetric(vertical: 8),
                color: Color(0xffF8F9FE),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.locationDot,
                      color: Color(0xff3657AD),
                      size: 16,
                    ),
                    SizedBox(width: 8),
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
                                        // TODO: Implement location selection
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

              SizedBox(height: 20),
              Center(
                child: Consumer(
                  builder: (context, ref, _) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        product.imageUrl!,
                        height: 200,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: SizedBox(
                              height: 200,
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
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.heart,
                        size: 20,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        FontAwesomeIcons.share,
                        size: 20,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '₹',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: product.price.toStringAsFixed(2),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: (product.price * 1.25).toStringAsFixed(0),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 2,
                          ),
                        ),
                        TextSpan(
                          text: ' 25% off',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // offers
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xffEEF1FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.moneyBill,
                          size: 20,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Cash on Delivery',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xffEEF1FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.solidStar,
                          size: 16,
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Lowest Price',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Divider(color: Color(0xffE0E0E0)),

              SizedBox(height: 20),

              // select quantity
              Text(
                'Select Quantity',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 12),
              // create chips of various kgs with borderradius 16 with padding 16h and 6v and white background and spacing 12
              Builder(
                builder: (context) {
                  final padding = EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  );
                  final shape = RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  );
                  return Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Chip(
                        label: Text('1 kg'),
                        // backgroundColor: Color(0xffEEF1FF),
                        padding: padding,
                        shape: shape,
                      ),
                      Chip(
                        label: Text('2 kg'),
                        // backgroundColor: Color(0xffEEF1FF),
                        padding: padding,
                        shape: shape,
                      ),
                      Chip(
                        label: Text('2.5 kg'),
                        // backgroundColor: Color(0xffEEF1FF),
                        padding: padding,
                        shape: shape,
                      ),
                      Chip(
                        label: Text('3 kg'),
                        // backgroundColor: Color(0xffEEF1FF),
                        padding: padding,
                        shape: shape,
                      ),
                      Chip(
                        label: Text('5 kg'),
                        // backgroundColor: Color(0xffEEF1FF),
                        padding: padding,
                        shape: shape,
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 20),

              Divider(color: Color(0xffE0E0E0)),

              SizedBox(height: 20),

              // Buy now and add to cart buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
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
                          side: BorderSide(color: theme.colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
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

              SizedBox(height: 20),

              Divider(color: Color(0xffE0E0E0)),

              SizedBox(height: 20),

              Text(
                'Product Details',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              Table(
                // border: TableBorder.all(),
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
                      // SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(product.name),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(
                        'Description',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(product.description!),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(
                        'Manufacturer',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(product.manufacturer ?? ''),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              Divider(color: Color(0xffE0E0E0)),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
