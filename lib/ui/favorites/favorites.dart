import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/favorite_manager.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/theme.dart';
import 'package:nike_store/ui/product/details.dart';
import 'package:nike_store/ui/widgets/image.dart';

class FavoritesListScreen extends StatelessWidget {
  const FavoritesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('علاقه مندی ها'),
      ),
      body: ValueListenableBuilder<Box<ProductEntity>>(
          valueListenable: favoriteManager.listenableFavorites,
          builder: (context, box, child) {
            final favorites = box.values.toList();
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 100),
              physics: defaultScrollPhysics,
              itemCount: favorites.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.8),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.info,color: Colors.white,),
                        const SizedBox(width: 16,),
                        Expanded(
                          child: Text(
                              'برای حذف یک محصول از لیست علاقه مندی ها، انگشت اشاره خود را به صورت طولانی بر روی محصول نگهدارید.',style:Theme.of(context).textTheme.caption!.apply(color: Colors.white),),
                        ),
                      ],
                    ),
                  );
                } else {
                  final favorite = favorites[index - 1];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(product: favorite),
                        ),
                      );
                    },
                    onLongPress: () {
                      favoriteManager.delete(favorite);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 110,
                            height: 110,
                            child: ImageLoadingService(
                              imageUrl: favorite.imageUrl,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    favorite.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .apply(
                                            color: LightThemeColors
                                                .primaryTextColor),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    favorite.previousPrice.withPriceLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .apply(
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                  ),
                                  Text(favorite.price.withPriceLabel),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }),
    );
  }
}
