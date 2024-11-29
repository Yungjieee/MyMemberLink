import 'dart:convert';
import 'dart:developer';
import 'package:aasignment_1/views/newsletter/new_news.dart';
import 'package:aasignment_1/views/shared/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aasignment_1/models/news.dart';
import 'package:aasignment_1/myconfig.dart';
import 'package:aasignment_1/views/newsletter/edit_news.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  final String email;
  const MainScreen({super.key, required this.email});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<News> newsList = [];
  List<News> filteredNewsList = [];
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  late double screenwidth, screenHeight;
  var color;
  TextEditingController searchController = TextEditingController();
  bool isFavorite = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNewsData();
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
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
              'Newsletter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20, // Sets text color to white
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              loadNewsData(); // Calls the refresh function
            },
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh", // Optional: Adds a tooltip for the button
          ),
        ],
      ),
      body: newsList.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  buildSearchBar(),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text("Loading..."),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  buildSearchBar(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: newsList.length +
                          1, // Include the "Page" text as the last item
                      itemBuilder: (context, index) {
                        if (index == newsList.length) {
                          // Display "Page: X / Result: Y" at the end of the list
                          return buildPaginationInfo();
                        }
                        // Normal news cards
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () {
                                  showNewsDetailsDialog(index);
                                },
                                onLongPress: () {
                                  showEditDeleteMenu(index);
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      truncateString(
                                        newsList[index].newsTitle.toString(),
                                        50,
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.01,
                                    ),
                                    Text(
                                      df.format(
                                        DateTime.parse(
                                          newsList[index].newsDate.toString(),
                                        ),
                                      ),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.01,
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                    truncateString(
                                      newsList[index].newsDetails.toString(),
                                      165,
                                    ),
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(fontSize: 12)),
                                trailing: IconButton(
                                  onPressed: () {
                                    // showNewsDetailsDialog(index);
                                    // Toggle favorite status
                                    //toggleFavorite(newsList[index]);
                                    setState(() {
                                      isFavorite =
                                          !isFavorite; // Toggle favorite state
                                    });
                                  },
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        isFavorite ? Colors.red : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  buildPagination(),
                ],
              ),
            ),
      drawer: MyDrawer(email:widget.email),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewNewsScreen()),
          );
          loadNewsData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // void loadNewsData() {
  //   http
  //       .get(Uri.parse(
  //           "${Myconfig.servername}/memberlink_asg1/api/load_news.php?pageno=$curpage"))
  //       .then((response) {
  //     // log(response.body.toString());
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       if (data['status'] == "success") {
  //         var result = data['data']['news'];
  //         newsList.clear();
  //         for (var i in result) {
  //           News news = News.fromJson(i);
  //           newsList.add(news);
  //           //print(news.newsTitle);
  //         }
  //         numofpage = int.parse(data['numofpage'].toString());
  //         numofresult = int.parse(data['numberofresult'].toString());
  //         setState(() {});
  //       }
  //     } else {
  //       print("Error");
  //     }
  //   });
  // }

  void loadNewsData() {
    String searchQuery = searchController.text.trim();
    String url =
        "${Myconfig.servername}/memberlink_asg1/api/load_news.php?pageno=$curpage";

    // Append search query if it's not empty
    if (searchQuery.isNotEmpty) {
      url += "&search=${Uri.encodeComponent(searchQuery)}";
    }

    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear(); // Clear the current list before loading new data
          for (var i in result) {
            News news = News.fromJson(i);
            newsList.add(news);
          }

          // Update pagination details
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());

          setState(() {});
        } else {
          setState(() {
            newsList.clear(); // Clear the list if no results found
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("No results found"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to load news"),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  Widget buildPagination() {
    return SizedBox(
      height: screenHeight * 0.05,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: numofpage,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // Build the list for text buttons with scroll
          if ((curpage - 1) == index) {
            // Set current page number active
            color = Colors.red;
          } else {
            color = Colors.black;
          }
          return TextButton(
            onPressed: () {
              setState(() {
                curpage = index + 1; // Set the current page
              });
              loadNewsData();
            },
            child: Text(
              (index + 1).toString(),
              style: TextStyle(color: color, fontSize: 18),
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: searchController,
        style: const TextStyle(fontSize: 13),
        onChanged: (value) {
          curpage = 1; // Reset to page 1 for a new search
          loadNewsData(); // Load news with the current search query
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          hintText: "Search news...",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.clear_rounded,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () {
              searchController.clear(); // Clear the search bar
              curpage = 1; // Reset to the first page
              loadNewsData(); // Reload all news
            },
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        ),
      ),
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

  void showNewsDetailsDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //backgroundColor: const Color.fromARGB(255, 215, 237, 255),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            title: Text(newsList[index].newsTitle.toString()),
            content: Text(
              newsList[index].newsDetails.toString(),
              textAlign: TextAlign.justify,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close"))
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
              "Delete \"${truncateString(newsList[index].newsTitle.toString(), 15)}\" ?",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            content: const Text("Are you sure you want to delete this news?"),
            actions: [
              TextButton(
                  onPressed: () {
                    deleteNews(index);
                    Navigator.pop(context);
                  },
                  child: const Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
            ],
          );
        });
  }

  void deleteNews(int index) {
    String newsId = newsList[index].newsId.toString();
    http.post(
        //databse modification deals with post
        Uri.parse("${Myconfig.servername}/memberlink_asg1/api/delete_news.php"),
        body: {"newsId": newsId}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        log(data.toString());
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Delete Success"),
            backgroundColor: Colors.green,
          ));
          loadNewsData(); //reload data after deletion
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Delete Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  void showEditDeleteMenu(int index) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit News'),
              onTap: () {
                Navigator.pop(context);
                editNews(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete News'),
              onTap: () {
                Navigator.pop(context);
                deleteDialog(index);
              },
            ),
          ],
        );
      },
    );
  }

  void editNews(int index) async {
    News news = newsList[index];
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNewsScreen(news: news),
      ),
    );
    loadNewsData(); // Refresh the news list after editing
  }

  // void toggleFavorite(News news) {
  //   String url =
  //       "${Myconfig.servername}/memberlink_asg1/api/toggle_favorite_news.php";

  //   http.post(Uri.parse(url), body: {
  //     "userEmail": widget.email, // Replace with dynamic user email
  //     "newsId": news.newsId,
  //   }).then((response) {
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       if (data['status'] == "success") {
  //         setState(() {
  //           news.isFavorite = !(news.isFavorite ?? false); // Toggle state
  //         });
  //       }
  //     }
  //   });
  // }

  Widget buildPaginationInfo() {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 10.0),
          child: Text(
            "Page: $curpage / Result: $numofresult",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        )
      ],
    );
  }

  // void searchNews(String query) {
  //   final filteredNews = newsList
  //       .where((news) =>
  //           news.newsTitle!.toLowerCase().contains(query.toLowerCase()) ||
  //           news.newsDetails!.toLowerCase().contains(query.toLowerCase()))
  //       .toList();

  //   setState(() {
  //     filteredNewsList = filteredNews; // Update the displayed news list
  //     print(filteredNewsList);
  //   });
  // }
}
