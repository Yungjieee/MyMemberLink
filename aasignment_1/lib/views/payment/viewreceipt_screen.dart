import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewReceiptScreen extends StatefulWidget {
  final String receiptId;
  final String email;
  final String membershipId;
  const ViewReceiptScreen({super.key, required this.receiptId,  required this.membershipId, required this.email});

  @override
  State<ViewReceiptScreen> createState() => _ViewReceiptScreenState();
}

class _ViewReceiptScreenState extends State<ViewReceiptScreen> {
  late WebViewController webController;
  
  @override
  void initState() {
    String receiptId = widget.receiptId;
    String email = widget.email;
    String membershipId = widget.membershipId;

    super.initState();
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            // Handle any WebView errors
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error loading receipt"),
              ),
            );
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          "https://mymemberlink.threelittlecar.com/memberlink_asg1/api/view_receipt.php?receiptId=$receiptId&email=$email&membershipId=$membershipId",
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         //loadPaymentsData(selectedStatus);
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
              'View Receipt',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20), // Sets text color to white
            ),
          ],
        ),
      ),
      body: WebViewWidget(
        controller: webController,
      ),
      // body: Column(
      //   children: [
      //     Text(widget.receiptId),
      //     Text(widget.email),
      //     Text(widget.membershipId),
      //   ],
      // ),
      
    );
  }
}