import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/data/repo/product_repository.dart';
import 'package:nike_store/ui/list/bloc/product_list_bloc.dart';
import 'package:nike_store/ui/product/product.dart';
import 'package:nike_store/ui/widgets/error.dart';

enum ViewType { grid, list }

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({
    Key? key,
    required this.sort,
  }) : super(key: key);
  final int sort;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc? bloc;
  ViewType viewType = ViewType.grid;

  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('کفش های ورزشی'),
        ),
        body: BlocProvider<ProductListBloc>(
          create: (context) {
            bloc = ProductListBloc(productRepository)
              ..add(ProductListStarted(widget.sort));
            return bloc!;
          },
          child: BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              if (state is ProductListSuccess) {
                final products = state.products;
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          border: Border(
                            top: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: 1,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20)
                          ]),
                      height: 56,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (context) {
                                return SizedBox(
                                  height: 300,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 24, bottom: 24),
                                    child: Column(
                                      children: [
                                        Text(
                                          'انتخاب نوع مرتب سازی',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        Divider(
                                          height: 1,
                                          indent: 16,
                                          endIndent: 16,
                                          color: Theme.of(context).dividerColor,
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: state.sortNames.length,
                                            itemBuilder: (context, index) {
                                              final selectedSortIndex =
                                                  state.sort;
                                              return InkWell(
                                                onTap: () {
                                                  bloc?.add(ProductListStarted(
                                                      index));
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 8, 16, 8),
                                                  child: SizedBox(
                                                    height: 32,
                                                    child: Row(
                                                      children: [
                                                        Text(state
                                                            .sortNames[index]),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        if (index ==
                                                            selectedSortIndex)
                                                          Icon(
                                                            CupertinoIcons
                                                                .check_mark_circled_solid,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                          )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(CupertinoIcons.sort_down),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('مرتب سازی'),
                                        Text(
                                          ProductSort.names[state.sort],
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 0.8,
                              color: Theme.of(context).dividerColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    viewType = viewType == ViewType.grid
                                        ? ViewType.list
                                        : ViewType.grid;
                                  });
                                },
                                icon:
                                    const Icon(CupertinoIcons.square_grid_2x2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                          physics: defaultScrollPhysics,
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.65,
                            crossAxisCount: viewType == ViewType.grid ? 2 : 1,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final product = products[index];
                            return ProductItem(
                              product: product,
                              borderRadius: BorderRadius.zero,
                            );
                          }),
                    ),
                  ],
                );
              } else if (state is ProductListLoading) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else if (state is ProductListError) {
                return AppErrorWidget(
                  exception: state.exception,
                  onPressed: () {
                    BlocProvider.of<ProductListBloc>(context)
                        .add(ProductListStarted(widget.sort));
                  },
                );
              } else {
                throw Exception('this state not valid');
              }
            },
          ),
        ));
  }
}
