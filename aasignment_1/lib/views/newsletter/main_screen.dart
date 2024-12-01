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
  List<News> favouriteNewsList = [];
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  late double screenwidth, screenHeight;
  var color;
  TextEditingController searchController = TextEditingController();
  bool showFavouritesOnly = false; // Determines which tab is active
  bool isDescending = true; // Default to descending order


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

    return DefaultTabController(
      length: 2, // Two tabs: All News and Favorites
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo_white.png',
                height: 50,
              ),
              const SizedBox(width: 8),
              const Text(
                'Newsletter',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          actions: [
            IconButton(
      icon: Icon(
        isDescending ? Icons.arrow_downward : Icons.arrow_upward,
        color: Colors.white,
      ),
      tooltip: "Sort by Date",
      onPressed: () {
        setState(() {
          isDescending = !isDescending; // Toggle sorting order
          loadNewsData(); // Reload data with the new sorting order
        });
      },
    ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  buildSearchBar(),
                ],
              ),
            ),

            // Tab Bar
            TabBar(
              onTap: (index) {
                setState(() {
                  showFavouritesOnly = index == 1; // Switch tab
                  curpage = 1; // Reset to the first page
                  loadNewsData(); // Reload data based on selected tab
                });
              },
              tabs: const [
                Tab(text: "All News"),
                Tab(text: "Favourites"),
              ],
            ),

            // News List with Pagination
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                children: [
                  // Tab 1: All News
                  RefreshIndicator(
                  onRefresh: () async {
                    loadNewsData(); // Reload data on pull-down
                  },
                  child: buildNewsList(),
                ),

                  // Tab 2: Favorites
                  RefreshIndicator(
                  onRefresh: () async {
                    loadNewsData(); // Reload data on pull-down
                  },
                  child: buildNewsList(),
                ),
                ],
              ),
            ),
          ],
        ),
        drawer: MyDrawer(email: widget.email),
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
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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

  Widget buildNewsList() {
   if (showFavouritesOnly && newsList.isEmpty) {
    return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.inbox_outlined,
          size: 80,
          color: Colors.orange
        ),
        SizedBox(height: 20),
        Text(
          "No favorites news found.",
          style: TextStyle(
            fontSize: 16,
            //fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
  }

  if (!showFavouritesOnly && newsList.isEmpty) {
    return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.inbox_outlined,
          size: 80,
          color: Colors.orange
        ),
        SizedBox(height: 20),
        Text(
          "No news found.",
          style: TextStyle(
            fontSize: 16,
            //fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
  }

  return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: newsList.length + 1, // +1 for pagination info
                    itemBuilder: (context, index) {
                      // Check if it's the last item for pagination info
                      if (index == newsList.length) {
                        return buildPaginationInfo();
                      }

                      // Ensure we don't access out-of-range indexes
                      if (index < newsList.length) {
                        return buildNewsCard(index);
                      }

                      return const SizedBox
                          .shrink(); // Return an empty widget for safety
                    },
                  ),
                ),
                buildPagination(),
              ],
            ),
          );
  }

  Widget buildPaginationInfo() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Text(
            "----- Page: $curpage / $numofpage   |   Total Results: $numofresult -----",
            style: const TextStyle(fontSize: 14),
          ),
          SizedBox(height: screenHeight * 0.01),
        ],
      ),
    );
  }

  Widget buildPagination() {
    return SizedBox(
      height: screenHeight * 0.05,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: numofpage,
        itemBuilder: (context, index) {
          color = (curpage - 1) == index ? Colors.red : Colors.black;
          return TextButton(
            onPressed: () {
              setState(() {
                curpage = index + 1; // Update the current page
              });
              loadNewsData(); // Load news for the selected page
            },
            
            child: Text(
              (index + 1).toString(),
              style: TextStyle(color: color, fontSize: 16),
            ),
          );
        },
      ),
    );
  }

  Widget buildNewsCard(int index) {
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
                  truncateString(newsList[index].newsTitle.toString(), 50),
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
              style: const TextStyle(fontSize: 12),
            ),
            trailing: IconButton(
              onPressed: () {
                toggleFavourite(newsList[index]);
              },
              icon: Icon(
                newsList[index].isFavourite == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: newsList[index].isFavourite == true
                    ? Colors.red
                    : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }


 void loadNewsData() {
  String url = showFavouritesOnly
      ? "${Myconfig.servername}/memberlink_asg1/api/load_favourites.php?pageno=$curpage"
      : "${Myconfig.servername}/memberlink_asg1/api/load_news.php?pageno=$curpage";

  String searchQuery = searchController.text.trim();
  if (searchQuery.isNotEmpty) {
    url += "&search=${Uri.encodeComponent(searchQuery)}";
  }

  url += "&order=${isDescending ? 'DESC' : 'ASC'}"; // Add sorting parameter

  http.post(Uri.parse(url), body: {
    "userEmail": widget.email,
  }).then((response) {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print(response.body);

      if (data['status'] == "success") {
        var result = data['data']['news'];
        newsList.clear();
        for (var i in result) {
          News news = News.fromJson(i);

          // Map 'isFavourite' from backend to 'isFavourite' in Flutter
          news.isFavourite =
              (i['isFavourite']?.toString() == "1") ? true : false;

          newsList.add(news);
        }

        numofpage = int.parse(data['numofpage'].toString());
        numofresult = int.parse(data['numberofresult'].toString());
        setState(() {}); // Refresh the UI
      } else {
        setState(() {
          newsList.clear(); // Clear the list
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
  }).catchError((error) {
    log("Error occurred: $error");
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("An error occurred while fetching news"),
      backgroundColor: Colors.red,
    ));
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


  void toggleFavourite(News news) {
    //log("Toggling favourite for News ID: ${news.newsId}, User Email: ${widget.email}");

    // Optimistically update the UI
    setState(() {
      news.isFavourite = !(news.isFavourite ?? false); // Toggle state
    });

    String email = widget.email;

    String url =
        "${Myconfig.servername}/memberlink_asg1/api/toggle_favourite_news.php";

    http.post(Uri.parse(url), body: {
      "userEmail": email, // Pass the user email dynamically
      "newsId": news.newsId,
    }).then((response) {
      //print(response.statusCode);
      //print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(news.isFavourite == true
              ? "Added to favorites successfully!"
              : "Removed from favorites successfully!"),
          backgroundColor: Colors.green,
        ));
         // log("Favourite status updated successfully: ${data['message']}");
        } else {
          log("Failed to update favourite status: ${data['message']}");
          // Revert the state on failure
          setState(() {
            news.isFavourite = !(news.isFavourite ?? false);
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to update favourite status"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        log("Failed to connect to server");
        // Revert the state on network failure
        setState(() {
          news.isFavourite = !(news.isFavourite ?? false);
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to connect to server"),
          backgroundColor: Colors.red,
        ));
      }
    }).catchError((error) {
      log("Error occurred: $error");
      // Revert the state on error
      setState(() {
        news.isFavourite = !(news.isFavourite ?? false);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An error occurred"),
        backgroundColor: Colors.red,
      ));
    });
  }
}
