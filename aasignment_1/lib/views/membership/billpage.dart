import 'package:aasignment_1/views/payment/paymenthistory_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'paymenthistory_screen.dart'; // Import PaymenthistoryScreen

class BillPage extends StatefulWidget {
  final String email;
  final String payment;
  final String membershipId;

  const BillPage({
    super.key,
    required this.email,
    required this.payment,
    required this.membershipId,
  });

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  late WebViewController webController;
  bool paymentCompleted = false; // Track if the payment was completed

  @override
  void initState() {
    super.initState();
    String email = widget.email;
    String payment = widget.payment;
    String membershipId = widget.membershipId;

    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // Detect when the payment update page is reached
            if (url.contains("payment_update.php")) {
              setState(() {
                paymentCompleted = true; // Mark payment as completed
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(
        "https://mymemberlink.threelittlecar.com/memberlink_asg1/api/bills.php?email=$email&amount=$payment&membershipId=$membershipId",
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     // Navigate back to PaymenthistoryScreen
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => PaymenthistoryScreen(email: widget.email),
        //       ),
        //     );
        //   },
        // ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo_white.png', // Replace with your logo asset path
              height: 50,
            ),
            const SizedBox(width: 8),
            const Text(
              'Bill',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: WebViewWidget(
        controller: webController,
      ),
      floatingActionButton: paymentCompleted
          ? FloatingActionButton.extended(
              onPressed: () {
                // Navigate back to PaymenthistoryScreen after payment
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PaymenthistoryScreen(email: widget.email),
                  ),
                );
              },
              label: const Text("Go to Payment History"),
              icon: const Icon(Icons.history),
              backgroundColor: Colors.orange,
            )
          : null, // Show FAB only if payment is completed
    );
  }
}
