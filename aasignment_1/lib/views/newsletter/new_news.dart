import 'dart:convert';
import 'package:aasignment_1/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:aasignment_1/myconfig.dart';

class NewNewsScreen extends StatefulWidget {
  const NewNewsScreen({super.key});

  @override
  State<NewNewsScreen> createState() => _NewNewsScreenState();
}

class _NewNewsScreenState extends State<NewNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  late double screenwidth, screenheight;

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
    // print(screenheight);
    // print(screenwidth);

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
              'New Newsletter',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20), // Sets text color to white
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Title",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: "News Title"),
            ),
            const SizedBox(
              height: 15,
            ),
             const Text(
                "Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
            SizedBox(
              height: screenheight * 0.65,
              child: TextField(
                controller: detailsController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "News Details"),
                maxLines: screenheight ~/ 35,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            MaterialButton(
                elevation: 10,
                 shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                onPressed: () {
                  onInsertNewsDialog();
                },
                minWidth: 400,
                height: 50,
                color: const Color.fromARGB(255, 236, 16, 0),
                child: const Text(
                  "Insert",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }

  void onInsertNewsDialog() {
    String title = titleController.text;
    String details = detailsController.text;
    if (title.isEmpty || details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter title and details"),
      ));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Insert this newsletter?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                insertNews();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //   content: Text("Registration Canceled"),
                //   backgroundColor: Colors.red,
                // ));
              },
            ),
          ],
        );
      },
    );
  }

  void insertNews() {
    String title = titleController.text;
    String details = detailsController.text;
    http.post(
        Uri.parse("${Myconfig.servername}/memberlink_asg1/api/insert_news.php"),
        body: {"title": title, "details": details}).then((response) {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Success"),
            backgroundColor: Colors.green,
          ));
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (content) => const MainScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
