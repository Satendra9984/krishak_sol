import 'package:bhoomi_sakti/app/core/providers/core_providers.dart';
import 'package:bhoomi_sakti/common/app_common_providers.dart';
import 'package:bhoomi_sakti/common/widgets/custom_text_field.dart';
import 'package:bhoomi_sakti/features/products/domain/entities/category_entity.dart';
import 'package:bhoomi_sakti/features/products/presentation/blocs/product_bloc.dart';
import 'package:bhoomi_sakti/features/products/presentation/blocs/product_event.dart';
import 'package:bhoomi_sakti/features/products/presentation/blocs/product_state.dart';
import 'package:bhoomi_sakti/features/products/presentation/pages/product_details_page.dart';
import 'package:bhoomi_sakti/features/products/presentation/widgets/products_card.dart';
import 'package:bhoomi_sakti/features/products/product_providers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  late final TextEditingController _searchController;
  final ValueNotifier<CategoryEntity> _selectedCategory =
      ValueNotifier<CategoryEntity>(CategoryEntity(categoryId: 1, name: 'All'));

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();

    // Dispatch the event to fetch products when the widget is first created
    ref.read(productBlocProvider).add(FetchProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  List<CategoryEntity> categories = [
    CategoryEntity(categoryId: 1, name: 'All'),
    CategoryEntity(categoryId: 2, name: 'Vegetables'),
    CategoryEntity(categoryId: 3, name: 'Fruits'),
    CategoryEntity(categoryId: 4, name: 'Grains'),
    CategoryEntity(categoryId: 5, name: 'Dairy'),
    CategoryEntity(categoryId: 6, name: 'Beverages'),
    CategoryEntity(categoryId: 7, name: 'Snacks'),
    CategoryEntity(categoryId: 8, name: 'Bakery'),
    CategoryEntity(categoryId: 9, name: 'Beverages'),
    CategoryEntity(categoryId: 10, name: 'Beverages'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final size = MediaQuery.of(context).size;

    debugPrint('[ShopPage] size: $size');

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Products', style: theme.textTheme.titleLarge),
        actions: [
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
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: _searchController,
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: Color(0xffc7c7c7),
                      size: 24,
                    ),
                    hintText: 'Search Items, Services',
                    validator: (_) {
                      return null;
                    },
                  ),
                ),

                SizedBox(width: 24),

                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    FontAwesomeIcons.sliders,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

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

            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ValueListenableBuilder(
                      valueListenable: _selectedCategory,
                      builder: (context, value, child) {
                        final isSelected =
                            value.categoryId == category.categoryId;
                        return GestureDetector(
                          onTap: () {
                            _selectedCategory.value = category;
                          },
                          child: Chip(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            label: Text(
                              category.name,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                color:
                                    isSelected
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurface,
                              ),
                            ),
                            backgroundColor:
                                isSelected
                                    ? theme.colorScheme.primary
                                    : Color(0xffF7F7F7),
                            side: BorderSide.none,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                bloc: ref.watch(productBlocProvider),
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductLoaded) {
                    return AlignedGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductsCard(
                          product: product,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        ProductDetailsPage(product: product),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is ProductError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return const Center(child: Text('Welcome to the Shop!'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
