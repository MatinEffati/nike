import 'package:flutter/material.dart';
import 'package:nike_store/ui/receipt/payment_receipt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGatewayScreen extends StatelessWidget {
  const PaymentGatewayScreen({Key? key, required this.bankGatewayUrl}) : super(key: key);
final String bankGatewayUrl;
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: bankGatewayUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (url) {
        debugPrint('Url: $url');
        final uri =  Uri.parse(url);
        if(uri.pathSegments.contains('appCheckout') && uri.host == 'expertdevelopers.ir'){
          final orderId = int.parse(uri.queryParameters['order_id']!);
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentReceiptScreen(orderId: orderId)));
        }
      },
    );
  }
}
