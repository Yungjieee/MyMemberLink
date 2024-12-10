import 'dart:convert';
import 'dart:developer';
import 'package:aasignment_1/models/myevent.dart';
import 'package:aasignment_1/views/events/edit_event.dart';
import 'package:http/http.dart' as http;
import 'package:aasignment_1/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:aasignment_1/views/events/new_event.dart';
import 'package:aasignment_1/views/shared/my_drawer.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  final String email;
  const EventScreen({super.key, required this.email});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<MyEvent> eventsList = [];
  late double screenWidth, screenHeight;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  String status = "Loading...";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadEventsData();
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
                loadEventsData();
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
              'Events',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20), // Sets text color to white
            ),
          ],
        ),
      ),
      body: eventsList.isEmpty
          ? Center(
              child: Text(
                status,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.count(
                  childAspectRatio: 1 / 1.5,
                  crossAxisCount: 2, //2 card per row
                  children: List.generate(eventsList.length, (index) {
                    return Card(
                      child: InkWell(
                        //splashColor: Colors.grey,
                        onLongPress: () {
                          deleteDialog(index);
                        },
                        onTap: () {
                          showEventDetailsDialog(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
                          child: Column(children: [
                            Text(
                              eventsList[index].eventTitle.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            SizedBox(
                              child: Image.network(
                                  errorBuilder: (context, error, stackTrace) =>
                                      SizedBox(
                                        height: screenHeight / 6,
                                        child: Image.asset(
                                          "assets/images/na.png",
                                        ),
                                      ),
                                  width: screenWidth / 2,
                                  height: screenHeight / 6,
                                  fit: BoxFit.cover,
                                  scale: 4,
                                  "${Myconfig.servername}/memberlink_asg1/assets/events/${eventsList[index].eventFilename}"),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: Text(
                                eventsList[index].eventType.toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(df.format(DateTime.parse(
                                eventsList[index].eventDate.toString()))),
                            Text(truncateString(
                                eventsList[index].eventDescription.toString(),
                                45)),
                          ]),
                        ),
                      ),
                    );
                  })),
            ),
      drawer: MyDrawer(
        email: widget.email,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewEventScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void loadEventsData() {
    http
        .get(Uri.parse(
            "${Myconfig.servername}/memberlink_asg1/api/load_events.php"))
        .then((response) {
      //log(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['events'];
          eventsList.clear();
          for (var item in result) {
            MyEvent myevent = MyEvent.fromJson(item);
            eventsList.add(myevent);
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

  String truncateString(String str, int length) {
    if (str.length > length) {
      str = str.substring(0, length);
      return "$str...";
    } else {
      return str;
    }
  }

  void showEventDetailsDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(eventsList[index].eventTitle.toString()),
            content: SingleChildScrollView(
              child: Column(children: [
                Image.network(
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                          "assets/images/na.png",
                        ),
                    width: screenWidth,
                    height: screenHeight / 4,
                    fit: BoxFit.cover,
                    scale: 4,
                    "${Myconfig.servername}/memberlink_asg1/assets/events/${eventsList[index].eventFilename}"),
                Text(eventsList[index].eventType.toString()),
                Text(df.format(
                    DateTime.parse(eventsList[index].eventDate.toString()))),
                Text(eventsList[index].eventLocation.toString()),
                const SizedBox(height: 10),
                Text(
                  eventsList[index].eventDescription.toString(),
                  textAlign: TextAlign.justify,
                )
              ]),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  MyEvent myevent = eventsList[index];
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => EditEventScreen(
                                myevent: myevent,
                              )));
                  loadEventsData();
                },
                child: const Text("Edit Event"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close"),
              )
            ],
          );
        });
  }

  void deleteDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(
                "Delete \"${truncateString(eventsList[index].eventTitle.toString(), 20)}\"",
                style: const TextStyle(fontSize: 18),
              ),
              content:
                  const Text("Are you sure you want to delete this event?"),
              actions: [
                TextButton(
                  onPressed: () {
                    deleteEvents(index);
                    Navigator.pop(context);
                  },
                  child: const Text("Yes"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"),
                ),
              ]);
        });
  }

  void deleteEvents(int index) {
    http.post(
        Uri.parse(
            "${Myconfig.servername}/memberlink_asg1/api/delete_event.php"),
        body: {
          "eventid": eventsList[index].eventId.toString()
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        log(data.toString());
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Event Deleted Successfully!"),
            backgroundColor: Colors.green,
          ));
          loadEventsData(); //reload data
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
