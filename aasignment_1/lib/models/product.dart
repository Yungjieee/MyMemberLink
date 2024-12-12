class Product {
  String? productId;
  String? productName;
  String? productDescription;
  String? productPrice;
  String? productType;
  String? productFilename;
  String? productRating;

  Product(
      {this.productId,
      this.productName,
      this.productDescription,
      this.productPrice,
      this.productType,
      this.productFilename,
      this.productRating});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    productPrice = json['product_price'];
    productType = json['product_type'];
    productFilename = json['product_filename'];
    productRating = json['product_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_description'] = productDescription;
    data['product_price'] = productPrice;
    data['product_type'] = productType;
    data['product_filename'] = productFilename;
    data['product_rating'] = productRating;
    return data;
  }
}