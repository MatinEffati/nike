class AddToCartResponse {
  final int productId;
  final int cartId;
  final int count;

  AddToCartResponse(this.productId, this.cartId, this.count);

  AddToCartResponse.fromJson(Map<String, dynamic> json)
      : productId = json['product_id'],
        cartId = json['id'],
        count = json['count'];
}
