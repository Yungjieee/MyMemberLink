import 'dart:convert';
import 'dart:developer';
import 'package:aasignment_1/views/product/product_screen.dart';
import 'package:http/http.dart' as http;
import 'package:aasignment_1/models/product.dart';
import 'package:aasignment_1/myconfig.dart';
import 'package:aasignment_1/views/product/cart_screen.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final String? userId;
  final String email;
  const ProductDetailsScreen(
      {super.key, required this.product, this.userId, required this.email});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1; // Track the selected quantity
  bool isExpanded = false; // Track if the description is expanded
  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Row(
          mainAxisSize:
              MainAxisSize.min, // Centers the row contents in the AppBar
          children: [
            Image.asset(
              'assets/images/logo_white.png', // Replace with your logo asset path
              height: 50,
            ),
            const SizedBox(width: 8), // Adds spacing between logo and text
            const Text(
              'Product Details',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20), // Sets text color to white
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite_border_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const CartScreen(),
              //   ),
              // );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Main Content in Expanded Widget
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: widget.product.productFilename != null
                          ? Image.network(
                              "${Myconfig.servername}/memberlink_asg1/assets/products/${widget.product.productFilename}",
                              width: screenWidth,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image,
                              size: 100, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Product Name and Type
                  Text(
                    widget.product.productName ?? "No Name Available",
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    widget.product.productType ?? "No Type Available",
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  // SizedBox(height: screenHeight * 0.00001),

                  // Rating and Icon Actions
                  Row(
                    children: [
                      // Product Rating
                      Row(
                        children: [
                          for (int i = 0; i < 5; i++)
                            Icon(
                              i <
                                      (double.tryParse(widget
                                                      .product.productRating ??
                                                  "0")
                                              ?.floor() ??
                                          0)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.orange,
                              size: 20,
                            ),
                          const SizedBox(width: 8.0),
                          Text(
                            '(${widget.product.productRating ?? "0.0"})',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline,
                            color: Colors.orange),
                        onPressed: () {
                          // Handle action
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_outlined,
                            color: Colors.orange),
                        onPressed: () {
                          // Handle action
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.support_agent_outlined,
                            color: Colors.orange),
                        onPressed: () {
                          // Handle action
                        },
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
                  // Description
                  const SizedBox(height: 8),
                  const Text(
                    "Description",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded; // Toggle description state
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.productDescription ??
                              "No description available.",
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                          maxLines: isExpanded ? null : 3, // Expand description
                          overflow: isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),
                        Text(
                          isExpanded ? "Read Less" : "Read More",
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quantity Selector
                  const Text(
                    "Quantity",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                        icon: const Icon(Icons.remove_circle,
                            color: Colors.orange),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          quantity.toString(),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon:
                            const Icon(Icons.add_circle, color: Colors.orange),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Sticky Bottom Bar
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Price",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'RM ${widget.product.productPrice ?? "0.00"}',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 16, 0),
                      ),
                    ),
                  ],
                ),

                // Add to Cart Button
                ElevatedButton(
                  onPressed: () {
                    showConfirmationDialog();
                    // insertToCart(
                    //     widget.userId!, widget.product.productId!, quantity);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: const Color.fromARGB(255, 255, 16, 0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize
                        .min, // Adjusts the button width to fit content
                    children: [
                      Icon(
                        Icons.add_shopping_cart_outlined, // Shopping cart icon
                        color: Colors.white,
                        size: 24.0,
                      ),
                      SizedBox(
                          width: 8.0), // Adds spacing between the icon and text
                      Text(
                        "Add to Cart",
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
          ),
        ],
      ),
    );
  }

  Future<void> insertToCart(
      String userId, String productId, int quantity) async {
    try {
      String url =
          "${Myconfig.servername}/memberlink_asg1/api/insert_cartitem.php";

      final response = await http.post(
        Uri.parse(url),
        body: {
          "user_id": userId,
          "product_id": productId,
          "quantity": quantity.toString(),
        },
      );

      if (response.statusCode == 200) {
        log(response.body);
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Item added to cart successfully! You can view the item in your cart"),
                backgroundColor: Colors.green),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(data['message']), backgroundColor: Colors.red),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Failed to connect to the server"),
              backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error"), backgroundColor: Colors.red),
      );
    }
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close Icon
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ),
                // Image/Logo
                Image.asset(
                  'assets/images/addtocart.png', // Replace with your image asset
                  height: 150, // Increased image size
                  width: 300,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                // Title
                const Text(
                  "Add To Cart",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4.0),

                // Subtitle
                const Text(
                  "Are you sure you want to add this product to your cart?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 25.0),

                // Buttons Row
                Row(
                  children: [
                    // No Button
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: const Text(
                          "No, Cancel",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0), // Space between buttons

                    // Yes Button
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          insertToCart(widget.userId!,
                              widget.product.productId!, quantity);
                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                  email: widget.email,
                                  userId: widget.userId ?? "0"),
                            ),
                          );
                        },
                        color: const Color.fromARGB(255, 255, 16, 0),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: const Text(
                          "Yes, Proceed",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
