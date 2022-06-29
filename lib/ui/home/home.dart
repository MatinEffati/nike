import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/data/repo/product_repository.dart';
import 'package:nike_store/data/source/banner_data_source.dart';
import 'package:nike_store/ui/home/home_bloc.dart';
import 'package:nike_store/ui/list/list.dart';
import 'package:nike_store/ui/product/product.dart';
import 'package:nike_store/ui/widgets/error.dart';
import 'package:nike_store/ui/widgets/slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(
            bannerRepository: bannerRepository,
            productRepository: productRepository);
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccess) {
                return ListView.builder(
                    physics: defaultScrollPhysics,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return Container(
                            height: 56,
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/img/nike_logo.png',
                              height: 24,
                              fit: BoxFit.fitHeight,
                            ),
                          );
                        case 2:
                          return BannerSlider(
                            banners: state.banners,
                          );
                        case 3:
                          return HorizontalProductList(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const ProductListScreen(
                                        sort: ProductSort.latest),));
                            },
                            products: state.latestProducts,
                            title: 'جدیدترین',
                          );
                        case 4:
                          return HorizontalProductList(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                ProductListScreen(
                                    sort: ProductSort.popular),));
                            },
                            products: state.popularProducts,
                            title: 'پربازدیدترین',
                          );
                        default:
                          return Container();
                      }
                    });
              } else if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeError) {
                return AppErrorWidget(
                  exception: state.exception,
                  onPressed: () {
                    BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                  },
                );
              } else {
                throw Exception('state is not supported');
              }
            },
          ),
        ),
      ),
    );
  }
}


class HorizontalProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<ProductEntity> products;

  const HorizontalProductList({
    Key? key,
    required this.title,
    required this.onTap,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle1,
              ),
              TextButton(
                onPressed: onTap,
                child: const Text('مشاهده همه'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
            itemCount: products.length,
            scrollDirection: Axis.horizontal,
            physics: defaultScrollPhysics,
            padding: const EdgeInsets.only(left: 8, right: 8),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItem(
                product: product,
                borderRadius: BorderRadius.circular(productImageBorderRadius),
              );
            },
          ),
        ),
      ],
    );
  }
}
