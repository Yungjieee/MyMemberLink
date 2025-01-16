import 'dart:convert';
import 'dart:developer';
import 'package:aasignment_1/models/payment.dart';
import 'package:aasignment_1/myconfig.dart';
import 'package:aasignment_1/views/payment/viewreceipt_screen.dart';
import 'package:aasignment_1/views/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PaymenthistoryScreen extends StatefulWidget {
  final String email;
  const PaymenthistoryScreen({super.key, required this.email});

  @override
  State<PaymenthistoryScreen> createState() => _PaymenthistoryScreentState();
}

class _PaymenthistoryScreentState extends State<PaymenthistoryScreen> {
  List<Payments> paymentsList = [];
  late double screenWidth, screenHeight;
  String status = "Loading...";
  double totalSpend = 0.0;
  String selectedStatus = "paid"; // Default to "paid"
  List<bool> isSelected = [true, false]; // Default to "Paid" toggle selected

  @override
  void initState() {
    super.initState();
    loadPaymentsData(selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         loadPaymentsData(selectedStatus);
        //       },
        //       icon: const Icon(Icons.refresh))
        // ],
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
              'Payment History',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20), // Sets text color to white
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
    // Call the loadPaymentsData method with the current status
    await Future.delayed(const Duration(milliseconds: 500)); // Optional delay for smooth UI
    loadPaymentsData(selectedStatus);
  },
        child: Center(
          child: Column(
            children: [
              // Total Spend Card
              Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  height: screenHeight * 0.25,
                  width: screenWidth,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.yellow, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Spend",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 12.0,
                                      color: Color.fromARGB(157, 0, 0, 0),
                                    ),
                                  ]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "RM ${totalSpend.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 12.0,
                                      color: Color.fromARGB(157, 0, 0, 0),
                                    ),
                                  ]),
                            ),
                            const SizedBox(height: 45),
                            const Text(
                              "Your Financial Summary",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 6.0,
                                      color: Color.fromARGB(157, 0, 0, 0),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/images/spending.png',
                        height: 150,
                        width: 150,
                      ),
                    ],
                  ),
                ),
              ),
        
              // Toggle Button for Status
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(20.0),
                  borderColor: Colors.orange,
                  selectedBorderColor: Colors.orange,
                  selectedColor: Colors.white,
                  fillColor: Colors.orange,
                  color: Colors.orange,
                  constraints: BoxConstraints(
                    minHeight: 40.0,
                    minWidth: screenWidth * 0.4,
                  ),
                  isSelected: isSelected,
                  onPressed: (index) {
                    setState(() {
                      for (int i = 0; i < isSelected.length; i++) {
                        isSelected[i] = i == index;
                      }
                      selectedStatus = index == 0 ? "paid" : "pending";
                      loadPaymentsData(selectedStatus);
                    });
                  },
                  children: const [
                    Text("Paid", style: TextStyle(fontSize: 16)),
                    Text("Pending", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Text(
                    "Payments History",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              paymentsList.isEmpty
                  ? const Column(
                      children: [
                        SizedBox(height: 20),
                        Icon(
                          Icons.inbox_outlined,
                          size: 80,
                          color: Colors.orange,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "No payments found for the selected status.",
                          style: TextStyle(fontSize: 16, color: Colors.orange),
                        ),
                      ],
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: paymentsList.length,
                        itemBuilder: (context, index) {
                          final payment =
                              paymentsList[paymentsList.length - 1 - index];
                          final DateFormat formatter =
                              DateFormat('dd/MM/yyyy HH:mm');
                          final DateTime paymentDate =
                              DateTime.parse(payment.paymentDate ?? '');
                          final String formattedDate =
                              formatter.format(paymentDate);
                          final selectedPayment =
                              paymentsList[paymentsList.length - 1 - index];
        
                          final bool isPaid =
                              payment.paymentStatus?.toLowerCase() == "paid";
        
                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(11.0),
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: CircleAvatar(
                                  backgroundColor:
                                      isPaid ? Colors.green : Colors.red,
                                  radius: 17,
                                  child: Icon(
                                    isPaid ? Icons.check : Icons.hourglass_empty,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${payment.membershipName} Membership",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 12),
                                    margin: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: isPaid
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isPaid ? "Paid" : "Pending",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isPaid ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "RM ${payment.paymentAmount ?? '0.00'}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: isPaid ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios_outlined),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewReceiptScreen(
                                      email: widget.email, // User's email
                                      receiptId: selectedPayment.paymentReceipt ??
                                          "", // Receipt ID
                                      membershipId:
                                          selectedPayment.membershipId ??
                                              "", // Membership ID
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      drawer: MyDrawer(
        email: widget.email,
      ),
    );
  }

  void loadPaymentsData(String status) {
    String email = widget.email.toString();
    http
        .get(Uri.parse(
            "${Myconfig.servername}/memberlink_asg1/api/load_payments.php?email=$email&status=$status"))
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['payments'];
          paymentsList.clear();
          if (status == "paid") {
            totalSpend = 0.0; // Reset total spend for paid
          }
          for (var item in result) {
            Payments payment = Payments.fromJson(item);
            paymentsList.add(payment);
            if (status == "paid") {
              totalSpend += double.parse(payment.paymentAmount ?? "0");
            }
          }
          setState(() {});
        } else {
          paymentsList.clear();
          setState(() {});
        }
      } else {
        status = "Error loading data";
        setState(() {});
      }
    });
  }
}
