class CartItem {
  String? productId;
  String? productName;
  String? productType;
  String? productPrice;
  String? productFilename;
  int? quantity; // Ensuring this remains an integer
  String? addedDate;

  CartItem({
    this.productId,
    this.productName,
    this.productType,
    this.productPrice,
    this.productFilename,
    this.quantity,
    this.addedDate,
  });

  CartItem.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productType = json['product_type'];
    productPrice = json['product_price'];
    productFilename = json['product_filename'];

    // Handle string or integer for quantity
    if (json['quantity'] is String) {
      quantity = int.tryParse(json['quantity']) ?? 0; // Convert string to int
    } else if (json['quantity'] is int) {
      quantity = json['quantity']; // Directly assign if it's already int
    } else {
      quantity = 0; // Default to 0 if null or unrecognized type
    }

    addedDate = json['added_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_type'] = productType;
    data['product_price'] = productPrice;
    data['product_filename'] = productFilename;
    data['quantity'] = quantity;
    data['added_date'] = addedDate;
    return data;
  }
}
