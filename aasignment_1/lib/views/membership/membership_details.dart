import 'dart:convert';

import 'package:aasignment_1/models/membership.dart';
import 'package:aasignment_1/myconfig.dart';
import 'package:aasignment_1/views/membership/billpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MembershipDetails extends StatefulWidget {
  final String email;
  final Memberships membership;
  const MembershipDetails(
      {super.key, required this.email, required this.membership});

  @override
  State<MembershipDetails> createState() => _MembershipDetailsState();
}

class _MembershipDetailsState extends State<MembershipDetails> {
  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    final membership = widget.membership; // Access membership details
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

// Define images for the price section based on membership type
    final priceBackgroundImage =
        membership.membershipName?.toLowerCase() == "premium"
            ? const AssetImage('assets/images/pink.png') // Premium image
            : membership.membershipName?.toLowerCase() == "standard"
                ? const AssetImage('assets/images/blue.png') // Standard image
                : const AssetImage('assets/images/orange.png'); // Basic image

    // Define button gradient based on membership type
    final buttonGradient = membership.membershipName?.toLowerCase() == "premium"
        ? const LinearGradient(
            colors: [Colors.purple, Colors.blue], // Premium gradient
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
        : membership.membershipName?.toLowerCase() == "standard"
            ? const LinearGradient(
                colors: [
                  Color.fromARGB(255, 152, 226, 226),
                  Color.fromARGB(255, 18, 98, 163)
                ], // Standard gradient
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : const LinearGradient(
                colors: [
                  Colors.yellow,
                  Colors.deepOrangeAccent
                ], // Basic gradient
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              );

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                //loadMembershipData();
              },
              icon: const Icon(Icons.refresh))
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
              'Membership Details',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20), // Sets text color to white
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
                bottom: 80), // Prevents overlap with the button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price Section
                Container(
                  width: screenWidth,
                  height: 510,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: priceBackgroundImage, // Dynamically select image
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        membership.membershipName?.toUpperCase() ?? "N/A",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Image.asset(
                        membership.membershipName?.toLowerCase() == 'premium'
                            ? 'assets/images/premium.png'
                            : membership.membershipName?.toLowerCase() == 'standard'
                                ? 'assets/images/standard1.png'
                                : 'assets/images/basic.png', // Add more conditions if needed
                        height: 200,
                        width: 350,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "RM",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${membership.membershipPrice}",
                            style: const TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(height: 90),
                              Text(
                                "/ ${membership.membershipDuration}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Membership Details
                Container(
                  width: screenWidth,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        membership.membershipDescription ??
                            "No description provided.",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 93, 93, 93),
                          height: 2.0, // Line spacing for the description
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Benefits:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      ...?membership.membershipBenefits?.map((benefit) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color:
                                      Colors.green), // Updated check icon color
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  benefit.trim(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 93, 93, 93),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                      const Text(
                        "Terms:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      ...?membership.membershipTerms?.map((term) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.circle,
                                  size: 8, color: Colors.black54),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  term.trim(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 93, 93, 93),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky Subscribe Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity, // Full width for the white background
              color: Colors.white, // White background to ensure no gaps
              padding: const EdgeInsets.all(16.0), // Padding around the button
              child: Material(
                elevation: 8, // Add elevation for the button
                borderRadius: BorderRadius.circular(24),
                shadowColor: Colors.black.withOpacity(0.5),
                child: Container(
                  width: double.infinity, // Full width for the button
                  decoration: BoxDecoration(
                    gradient:
                        buttonGradient, // Dynamically select button gradient
                    borderRadius: BorderRadius.circular(24), // Rounded corners
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      showConfirmationDialog();
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (content) => BillPage(
                      //             email: widget.email,
                      //             payment: membership.membershipPrice.toString(),
                      //             membershipId: membership.membershipId.toString(),)));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor:
                          Colors.transparent, // Transparent to show gradient
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(24), // Match container radius
                      ),
                    ),
                    child: const Text(
                      "Subscribe Now",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text for contrast
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
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
                  'assets/images/subscription.png', // Replace with your image asset
                  height: 200, // Increased image size
                  width: 300,
                ),
                // const SizedBox(
                //   height: 15.0,
                // ),
                // Title
                const Text(
                  "Subscribe Now?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 126, 46),
                  ),
                ),
                const SizedBox(height: 4.0),

                // Subtitle
                Text(
                  "Are you sure you want to subscribe to the ${widget.membership.membershipName} membership?",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                        onPressed: () async {
                          // insertToCart(widget.userId!,
                          //     widget.product.productId!, quantity);
                           Navigator.pop(context);

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (content) => BillPage(
                          //               email: widget.email,
                          //               payment: widget
                          //                   .membership.membershipPrice
                          //                   .toString(),
                          //               membershipId: widget
                          //                   .membership.membershipId
                          //                   .toString(),
                          //             )));

                          await checkMembershipStatus();
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
  Future<void> checkMembershipStatus() async {
  final email = widget.email;
  final membershipId = widget.membership.membershipId;
  final url =
      "${Myconfig.servername}/memberlink_asg1/api/check_membership_status.php?email=$email&membership_id=$membershipId";

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['status'] == 'exists') {
      _showInfoDialog("Already Subscribed", data['message']);
    } else if (data['status'] == 'pending') {
      _showInfoDialog("Pending Payment", data['message']);
    } else if (data['status'] == 'not_found') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (content) => BillPage(
            email: email,
            payment: widget.membership.membershipPrice.toString(),
            membershipId: membershipId.toString(),
          ),
        ),
      );
    } else {
      _showInfoDialog("Error", data['message']);
    }
  } else {
    _showInfoDialog("Error", "Unable to check membership status.");
  }
}

void _showInfoDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
}
