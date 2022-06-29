import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/cart_item.dart';
import 'package:nike_store/theme.dart';
import 'package:nike_store/ui/widgets/image.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.data,
    required this.onDeleteButtonClicked,
    required this.onIncreaseButtonClicked,
    required this.onDecreaseButtonClicked,
  }) : super(key: key);

  final CartItemEntity data;
  final GestureTapCallback onDeleteButtonClicked;
  final GestureTapCallback onIncreaseButtonClicked;
  final GestureTapCallback onDecreaseButtonClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ImageLoadingService(
                    imageUrl: data.product.imageUrl,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      data.product.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('تعداد'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: onIncreaseButtonClicked,
                          icon: const Icon(CupertinoIcons.plus_square),
                        ),
                        data.changeCountLoading
                            ? CupertinoActivityIndicator(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )
                            : Text(
                                data.count.toString(),
                                style: Theme.of(context).textTheme.headline6,
                              ),
                        IconButton(
                          onPressed: onDecreaseButtonClicked,
                          icon: const Icon(CupertinoIcons.minus_square),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.product.previousPrice.withPriceLabel,
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12,
                        color: LightThemeColors.secondaryTextColor,
                      ),
                    ),
                    Text(
                      data.product.price.withPriceLabel,
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
          data.deleteButtonLoading
              ? const SizedBox(
                  height: 48,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : TextButton(
                  onPressed: onDeleteButtonClicked,
                  child: const Text('حذف از سبد خرید'),
                ),
        ],
      ),
    );
  }
}
