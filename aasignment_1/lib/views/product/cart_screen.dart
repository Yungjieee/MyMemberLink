import 'dart:convert';
import 'dart:developer';
import 'package:aasignment_1/models/cartitem.dart';
import 'package:aasignment_1/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final String? userId;
  const CartScreen({super.key, required this.userId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItemsList = [];
  late double screenWidth, screenHeight;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> refreshProducts() async {
    await Future.delayed(const Duration(seconds: 2));
    loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo_white.png',
              height: 50,
            ),
            const SizedBox(width: 8),
            const Text(
              'Your Cart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshProducts,
              child: cartItemsList.isEmpty
                  ? const Center(
                      child: Text(
                        "Your cart is empty!",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: cartItemsList.length,
                      itemBuilder: (context, index) {
                        final item = cartItemsList[index];
                        return Dismissible(
                          key: Key(item.productId ?? ""),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            removeCartItem(item.productId ?? ""); // Remove item
                            setState(() {
                              cartItemsList.removeAt(index);
                              calculateTotalPrice();
                            });
                          },
                          child: buildCartItemCard(item, index),
                        );
                      },
                    ),
            ),
          ),
          buildTotalPriceBar(),
        ],
      ),
    );
  }

  Widget buildCartItemCard(CartItem item, int index) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(
                  "${Myconfig.servername}/memberlink_asg1/assets/products/${item.productFilename}",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    "assets/images/na.png",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.productType ?? "",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "RM ${item.productPrice}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 16, 0),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if ((item.quantity ?? 1) > 1) {
                                updateCartItemQuantity(item.productId ?? "",
                                    (item.quantity ?? 1) - 1);
                                setState(() {
                                  item.quantity = (item.quantity ?? 1) - 1;
                                  calculateTotalPrice();
                                });
                              }
                            },
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.orange),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${item.quantity}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              updateCartItemQuantity(item.productId ?? "",
                                  (item.quantity ?? 1) + 1);
                              setState(() {
                                item.quantity = (item.quantity ?? 1) + 1;
                                calculateTotalPrice();
                              });
                            },
                            icon: const Icon(Icons.add_circle,
                                color: Colors.orange),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTotalPriceBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              Text(
                'RM ${calculateTotalPrice().toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 16, 0)),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // Handle order functionality
            },
            style: ElevatedButton.styleFrom(
              elevation: 5,
              backgroundColor: const Color.fromARGB(255, 255, 16, 0),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 24.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  "Order Now",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (var item in cartItemsList) {
      total += (double.tryParse(item.productPrice ?? '0') ?? 0) *
          (item.quantity ?? 1);
    }
    return total;
  }

  void loadCartItems() {
    String userId = widget.userId.toString();
    http
        .get(Uri.parse(
            "${Myconfig.servername}/memberlink_asg1/api/load_cartitems.php?user_id=$userId"))
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['cartitems'];
          cartItemsList.clear();
          for (var item in result) {
            CartItem cartItem = CartItem.fromJson(item);
            cartItemsList.add(cartItem);
          }
          setState(() {});
        }
      }
    });
  }

void removeCartItem(String productId) async {
  String userId = widget.userId ?? "0";
  try {
    var response = await http.post(
      Uri.parse("${Myconfig.servername}/memberlink_asg1/api/remove_cartitem.php"),
      body: {"user_id": userId, "product_id": productId},
    );

    var data = jsonDecode(response.body);
    if (data['status'] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item removed from cart successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message'] ?? "Failed to remove item"),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    log("Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error: Could not connect to the server."),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  void updateCartItemQuantity(String productId, int newQuantity) async {
  String userId = widget.userId ?? "0";
  try {
    var response = await http.post(
      Uri.parse("${Myconfig.servername}/memberlink_asg1/api/update_cartitem.php"),
      body: {
        "user_id": userId,
        "product_id": productId,
        "quantity": newQuantity.toString()
      },
    );

    var data = jsonDecode(response.body);
    if (data['status'] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Quantity updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message'] ?? "Failed to update quantity"),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    log("Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error: Could not connect to the server."),
        backgroundColor: Colors.red,
      ),
    );
  }
}

}
