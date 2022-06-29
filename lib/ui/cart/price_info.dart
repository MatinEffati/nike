import 'package:flutter/material.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/theme.dart';

class PriceInfo extends StatelessWidget {
  const PriceInfo(
      {Key? key,
      required this.payablePrice,
      required this.totalPrice,
      required this.shippingCost})
      : super(key: key);
  final int payablePrice;
  final int totalPrice;
  final int shippingCost;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 8, 0),
          child: Text(
            'جزییات خرید',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              PriceDetailItem(price: totalPrice, text: 'مبلغ کل خرید',color: LightThemeColors.secondaryColor,),
              const Divider(
                height: 1,
              ),
              PriceDetailItem(price: shippingCost, text: 'هزینه ارسال'),
              const Divider(
                height: 1,
              ),
              PriceDetailItem(price: payablePrice, text: 'مبلغ قابل پرداخت'),
            ],
          ),
        ),
      ],
    );
  }
}

class PriceDetailItem extends StatelessWidget {
  const PriceDetailItem({
    Key? key,
    required this.text,
    required this.price,
    this.color,
  }) : super(key: key);

  final String text;
  final int price;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          price == 0
              ? Text(price.withPriceLabel)
              : RichText(
                  text: TextSpan(
                      text: price.separateByComma,
                      style: DefaultTextStyle.of(context).style.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: color),
                      children: const [
                        TextSpan(
                          text: ' تومان',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.normal),
                        )
                      ]),
                ),
        ],
      ),
    );
  }
}
