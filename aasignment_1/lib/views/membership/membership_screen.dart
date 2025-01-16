import 'dart:convert';
import 'dart:developer';

import 'package:aasignment_1/models/membership.dart';
import 'package:aasignment_1/myconfig.dart';
import 'package:aasignment_1/views/membership/billpage.dart';
import 'package:aasignment_1/views/membership/membership_details.dart';
import 'package:aasignment_1/views/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MembershipScreen extends StatefulWidget {
  final String email;
  const MembershipScreen({super.key, required this.email});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  List<Memberships> membershipsList = [];
  late double screenWidth, screenHeight;
  //final df = DateFormat('dd/MM/yyyy hh:mm a');
  String status = "Loading...";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMembershipData();
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
                loadMembershipData();
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
              'Membership',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20), // Sets text color to white
            ),
          ],
        ),
      ),
      body: membershipsList.isEmpty
          ? Center(
              child: Text(
                status,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    // Header Section in a Card
                    Card(
                      elevation: 8,
                      margin: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 242, 120),
                              Color.fromARGB(255, 246, 95, 49)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            // Premium Badge Image
                            Image.asset(
                              'assets/images/membership.png', // Replace with your premium badge image path
                              height: 130,
                              width: 130,
                              fit: BoxFit.contain,
                            ),

                            const Text(
                              "Subscribe to Premium",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const Text(
                              "Unlock exclusive access to premium features, priority support, and much more by subscribing today!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Membership Cards
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: membershipsList.length,
                      itemBuilder: (context, index) {
                        // Dynamically set the image and color based on membershipName or other attributes
                        String backgroundImage;
                        Color textColor;

                        if (membershipsList[index].membershipName ==
                            "Premium") {
                          backgroundImage =
                              'assets/images/premium_membership.png';
                          textColor = Colors.purple;
                        } else if (membershipsList[index].membershipName ==
                            "Standard") {
                          backgroundImage =
                              'assets/images/standard_membership.png';
                          textColor = const Color.fromARGB(255, 1, 37, 181);
                        } else {
                          backgroundImage =
                              'assets/images/basic_membership.png';
                          textColor = const Color.fromARGB(255, 254, 97, 0);
                        }

                        return Column(
                          children: [
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: InkWell(
                                onTap: () {
                                  // Handle the tap here
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MembershipDetails(
                                        email: widget.email,
                                        membership: membershipsList[
                                            index], // Pass membership details
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 490, // Adjust the height as needed
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          backgroundImage), // Dynamically set image
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors
                                              .transparent, // Start with transparency at the top
                                          Colors.black.withOpacity(
                                              0.7), // Black shade at the bottom
                                        ],
                                        begin: Alignment
                                            .topCenter, // Start the gradient from the top
                                        end: Alignment
                                            .bottomCenter, // End the gradient at the bottom
                                        stops: const [
                                          0.7,
                                          1.0
                                        ], // Limit the black gradient to the bottom half
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: screenHeight * 0.02),
                                        Text(
                                          membershipsList[index]
                                                  .membershipName
                                                  ?.toUpperCase() ??
                                              "N/A",
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                textColor, // White for better readability
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          membershipsList[index]
                                                  .membershipDuration ??
                                              "Duration N/A",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                textColor, // Slightly lighter white for subtitle
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "RM ${membershipsList[index].membershipPrice ?? "0"}",
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                textColor, // White for emphasis
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "Benefits:",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ...?membershipsList[index]
                                            .membershipBenefits
                                            ?.map((benefit) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: Row(
                                              children: [
                                                Icon(Icons.check_circle,
                                                    color: textColor),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    benefit.trim(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                        const Spacer(),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Show the confirmation dialog when the button is pressed
                                              showConfirmationDialog(
                                                membershipId:
                                                    membershipsList[index]
                                                        .membershipId!,
                                                membershipName:
                                                    membershipsList[index]
                                                        .membershipName!,
                                                membershipPrice:
                                                    membershipsList[index]
                                                        .membershipPrice!
                                                        .toString(),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              side: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "SUBSCRIBE NOW",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.01,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 20), // Add spacing between cards
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),

      // body: Center(
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text("membership screen"),
      //         TextField(
      //           decoration: const InputDecoration(hintText: "Email"),
      //           controller: emailController,
      //           keyboardType: TextInputType.emailAddress,
      //           ),
      //         TextField(
      //             decoration: const InputDecoration(hintText: "Payment"),
      //             controller: paymentController,
      //             keyboardType: TextInputType.number,),
      //         ElevatedButton(onPressed: () {
      //           Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (content) =>
      //                           BillPage(email: widget.email,payment: paymentController.text)));
      //         }, child: Text("Pay")),
      //       ],
      //     ),
      //   ),
      // ),
      drawer: MyDrawer(
        email: widget.email,
      ),
    );
  }

  void loadMembershipData() {
    http
        .get(Uri.parse(
            "${Myconfig.servername}/memberlink_asg1/api/load_membership.php"))
        .then((response) {
      //  log(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['memberships'];
          membershipsList.clear();
          for (var item in result) {
            Memberships memberships = Memberships.fromJson(item);
            membershipsList.add(memberships);
          }
          setState(() {});
        } else {
          status = "No Data";
        }
      } else {
        status = "Error loading data";
        print("Error");
        setState(() {});
      }
    });
  }

  void showConfirmationDialog({
    required String membershipId,
    required String membershipName,
    required String membershipPrice,
  }) {
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
                  "Are you sure you want to subscribe to the $membershipName membership?",
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
                          Navigator.pop(context); // Close the dialog
                          await checkMembershipStatus(
                            widget.email,
                            membershipId,
                            membershipName,
                            membershipPrice,
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

  Future<void> checkMembershipStatus(String email, String membershipId, String membershipName, String membershipPrice) async {
  final url =
      "${Myconfig.servername}/memberlink_asg1/api/check_membership_status.php?email=$email&membership_id=$membershipId";

  try {
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
            builder: (context) => BillPage(
              email: email,
              payment: membershipPrice,
              membershipId: membershipId,
            ),
          ),
        );
      } else {
        _showInfoDialog("Error", data['message']);
      }
    } else {
      _showInfoDialog("Error", "Unable to check membership status. Please try again.");
    }
  } catch (e) {
    log("Error: $e");
    _showInfoDialog("Error", "An unexpected error occurred. Please try again.");
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
