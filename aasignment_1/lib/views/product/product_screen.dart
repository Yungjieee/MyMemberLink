import 'dart:convert';
import 'dart:developer';
import 'package:aasignment_1/models/product.dart';
import 'package:aasignment_1/myconfig.dart';
import 'package:aasignment_1/views/product/cart_screen.dart';
import 'package:aasignment_1/views/product/product_details.dart';
import 'package:aasignment_1/views/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  final String email;
  final String? userId;
  const ProductScreen({super.key, required this.email, this.userId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> productsList = [];
  late double screenWidth, screenHeight;
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  var color;
  TextEditingController searchController = TextEditingController();

  String selectedCategory = "All Products"; // Track the selected category index
  final categories = ['All Products', 'Clothes', 'Bags', 'Mugs', 'Pens'];
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProductsData(selectedCategory);
  }

  Future<void> refreshProducts() async {
    // Simulate a delay for testing purposes
    await Future.delayed(const Duration(seconds: 2));
    loadProductsData(selectedCategory);
  }

  void updateSelectedCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void updateSelectedCategoryIndex(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CartScreen(userId: widget.userId ?? "0"),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined))
        ],
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
              'Products',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20), // Sets text color to white
            ),
          ],
        ),
      ),
      // body:Center(
      //   child: Text("Product Screen"),
      // ),
      body: RefreshIndicator(
        onRefresh: refreshProducts,
        child: productsList.isEmpty
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        buildSearchBar(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 0),
                    child: buildHorizontalScrollBar(),
                  ),
                  const SizedBox(height: 240,),
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 80, color: Colors.orange),
                        SizedBox(height: 20),
                        Text(
                          "No results found.",
                          style: TextStyle(
                            fontSize: 16,
                            //fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        buildSearchBar(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 0),
                    child: buildHorizontalScrollBar(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                          childAspectRatio: 1 / 1.56,
                          crossAxisCount: 2, //2 card per row
                          children: List.generate(productsList.length, (index) {
                            return Card(
                              color: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Product product = productsList[index];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(
                                              product: product,
                                              userId: widget.userId ?? "0",
                                              email: widget.email),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                "${Myconfig.servername}/memberlink_asg1/assets/products/${productsList[index].productFilename}",
                                                width: double.infinity,
                                                height: 180,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Container(
                                                  height: 120,
                                                  color: Colors.grey[200],
                                                  child: const Center(
                                                      child: Text(
                                                          "Image not available")),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 15),
                                                    const SizedBox(width: 2),
                                                    Text(
                                                      productsList[index]
                                                          .productRating
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          truncateString(
                                              productsList[index]
                                                  .productName
                                                  .toString(),
                                              18),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          productsList[index]
                                              .productType
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "RM ${productsList[index].productPrice.toString()}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 255, 16, 0),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showConfirmationDialog(
                                                    productsList[index]);
                                              },
                                              icon: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 255, 16, 0),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            // Container(
                                            //   padding: const EdgeInsets.all(4),
                                            //   decoration: BoxDecoration(
                                            //     color: const Color.fromARGB(
                                            //         255, 255, 16, 0),
                                            //     borderRadius:
                                            //         BorderRadius.circular(8),
                                            //   ),
                                            //   child: const Icon(Icons.add,
                                            //       color: Colors.white),
                                            // ),
                                          ],
                                        ),
                                      ]),
                                ),
                              ),
                            );
                          })),
                    ),
                  ),
                  buildPagination(),
                ],
              ),
      ),
      drawer: MyDrawer(
        email: widget.email,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const NewEventScreen()),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  Widget buildPagination() {
    return SizedBox(
      height: screenHeight * 0.05, // Set fixed height for pagination bar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Arrow
          GestureDetector(
            onTap: curpage > 1
                ? () {
                    setState(() {
                      curpage--;
                    });
                    loadProductsData(selectedCategory);
                  }
                : null,
            child: Icon(
              Icons.arrow_back_ios,
              color: curpage > 1 ? Colors.orange : Colors.grey[300],
              size: 16,
            ),
          ),
          const SizedBox(width: 8), // Add space between elements
          // Page Numbers
          ...List.generate(
            numofpage,
            (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    curpage = index + 1;
                  });
                  loadProductsData(selectedCategory);
                },
                child: Container(
                  width: screenHeight *
                      0.03, // Match the height for a square button
                  height: screenHeight * 0.03,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    color: curpage == index + 1 ? Colors.orange : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Center(
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(
                        color:
                            curpage == index + 1 ? Colors.white : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8), // Add space between elements
          // Next Arrow
          GestureDetector(
            onTap: curpage < numofpage
                ? () {
                    setState(() {
                      curpage++;
                    });
                    loadProductsData(selectedCategory);
                  }
                : null,
            child: Icon(
              Icons.arrow_forward_ios,
              color: curpage < numofpage ? Colors.orange : Colors.grey[300],
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  // void loadProductsData(String category) {
  //    String searchQuery = searchController.text.trim();
  //   // if (searchQuery.isNotEmpty) {
  //   //   url += "&search=${Uri.encodeComponent(searchQuery)}";
  //   // }

  //   http
  //       .get(Uri.parse(
  //           "${Myconfig.servername}/memberlink_asg1/api/load_products.php?pageno=$curpage&category=$category&search=${Uri.encodeComponent(searchQuery)}"))
  //       .then((response) {
  //     //log(response.body.toString());
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       if (data['status'] == "success") {
  //         var result = data['data']['products'];
  //         productsList.clear();
  //         for (var item in result) {
  //           Product product = Product.fromJson(item);
  //           productsList.add(product);
  //         }
  //         numofpage = int.parse(data['numofpage'].toString());
  //         numofresult = int.parse(data['numberofresult'].toString());
  //         //print(numofpage);
  //         //print(numofresult);
  //         setState(() {});
  //       } else {
  //         //status = "No Data";
  //       }
  //     } else {
  //       //status = "Error loading data";
  //       print("Error");
  //       setState(() {});
  //     }
  //   });
  // }

  void loadProductsData(String category) {
    String searchQuery = searchController.text.trim();

    http
        .get(Uri.parse(
            "${Myconfig.servername}/memberlink_asg1/api/load_products.php?pageno=$curpage&category=$category&search=${Uri.encodeComponent(searchQuery)}"))
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['products'];
          productsList.clear();
          for (var item in result) {
            Product product = Product.fromJson(item);
            productsList.add(product);
          }
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());
          setState(() {});
        } else {
          productsList.clear(); // Clear list if no data
          setState(() {});
        }
      } else {
        productsList.clear(); // Handle failed response
        setState(() {});
      }
    }).catchError((error) {
      log("Error: $error");
    });
  }

  Future<void> insertToCart(String userId, String productId) async {
    try {
      String url =
          "${Myconfig.servername}/memberlink_asg1/api/insert_cartitem.php";

      final response = await http.post(
        Uri.parse(url),
        body: {
          "user_id": userId,
          "product_id": productId,
          "quantity": "1",
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

  void showConfirmationDialog(Product product) {
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
                          insertToCart(widget.userId!, product.productId!);
                          Navigator.pop(context);
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

  String truncateString(String str, int length) {
    if (str.length > length) {
      str = str.substring(0, length);
      return "$str...";
    } else {
      return str;
    }
  }

  Widget buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
          elevation: 4, // Elevation for shadow effect
          borderRadius:
              BorderRadius.circular(30), // Match the border outline radius
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              curpage = 1; // Reset to page 1 for a new search
              loadProductsData(
                  selectedCategory); // Reload data with the search term
            },
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.orange, width: 2),
              ),
              hintText: "Search products...",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear_rounded, color: Colors.grey),
                onPressed: () {
                  searchController.clear();
                  loadProductsData(
                      selectedCategory); // Reload data without search
                },
              ),
            ),
          )),
    );
  }

  Widget buildHorizontalScrollBar() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(categories.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      categories[index],
                      style: TextStyle(
                        color: selectedCategoryIndex == index
                            ? Colors.white
                            : Colors.black, // Highlight selected category text
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // More circular
                      side: BorderSide(
                        color: selectedCategoryIndex == index
                            ? Colors.orange
                            : Colors.grey[300]!,
                        width: 2, // Make the border stand out
                      ),
                    ),
                    backgroundColor: Colors.grey[300],
                    selectedColor: Colors.orange,
                    onSelected: (isSelected) {
                      setState(() {
                        selectedCategoryIndex =
                            index; // Update the selected index
                        // Implement functionality to filter products by category
                        loadProductsData(categories[index]);
                        selectedCategory = categories[index];
                        updateSelectedCategory(categories[index]);
                        updateSelectedCategory(categories[index]);
                        //print("Selecected category: " +categories[index].toString());
                        //print(selectedCategory.toString());
                      });
                    },
                    selected: selectedCategoryIndex == index,
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  // void showEventDetailsDialog(int index) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(eventsList[index].eventTitle.toString()),
  //           content: SingleChildScrollView(
  //             child: Column(children: [
  //               Image.network(
  //                   errorBuilder: (context, error, stackTrace) => Image.asset(
  //                         "assets/images/na.png",
  //                       ),
  //                   width: screenWidth,
  //                   height: screenHeight / 4,
  //                   fit: BoxFit.cover,
  //                   scale: 4,
  //                   "${Myconfig.servername}/memberlink_asg1/assets/events/${eventsList[index].eventFilename}"),
  //               Text(eventsList[index].eventType.toString()),
  //               Text(df.format(
  //                   DateTime.parse(eventsList[index].eventDate.toString()))),
  //               Text(eventsList[index].eventLocation.toString()),
  //               const SizedBox(height: 10),
  //               Text(
  //                 eventsList[index].eventDescription.toString(),
  //                 textAlign: TextAlign.justify,
  //               )
  //             ]),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () async {
  //                 Navigator.pop(context);
  //                 MyEvent myevent = eventsList[index];
  //                 await Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (content) => EditEventScreen(
  //                               myevent: myevent,
  //                             )));
  //                 loadEventsData();
  //               },
  //               child: const Text("Edit Event"),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: const Text("Close"),
  //             )
  //           ],
  //         );
  //       });
  // }

  // void deleteDialog(int index) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //             title: Text(
  //               "Delete \"${truncateString(eventsList[index].eventTitle.toString(), 20)}\"",
  //               style: const TextStyle(fontSize: 18),
  //             ),
  //             content:
  //                 const Text("Are you sure you want to delete this event?"),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   deleteEvents(index);
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text("Yes"),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text("No"),
  //               ),
  //             ]);
  //       });
  // }

  // void deleteEvents(int index) {
  //   http.post(
  //       Uri.parse(
  //           "${Myconfig.servername}/memberlink_asg1/api/delete_event.php"),
  //       body: {
  //         "eventid": eventsList[index].eventId.toString()
  //       }).then((response) {
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       log(data.toString());
  //       if (data['status'] == "success") {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           content: Text("Event Deleted Successfully!"),
  //           backgroundColor: Colors.green,
  //         ));
  //         loadProductsData(); //reload data
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           content: Text("Failed"),
  //           backgroundColor: Colors.red,
  //         ));
  //       }
  //     }
  //   });
  // }
}
