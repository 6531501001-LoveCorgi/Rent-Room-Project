import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myapp/Project/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';

class userPage extends StatefulWidget {
  const userPage({super.key});

  @override
  State<userPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<userPage> {
  @override
  List? rooms;
  List? request;
  List? history;
  int? userID;

  void showSuccessDialog(BuildContext context, textAlert) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Success',
      desc: '$textAlert.',
      btnOkOnPress: () {},
    ).show();
  }

// Error Alert
  void showErrorDialog(BuildContext context, textAlert) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: '$textAlert.',
      btnOkOnPress: () {},
    ).show();
  }

// Question Alert (with Yes/No buttons)
  void showQuestionDialog(BuildContext context, textAlert) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: 'Are you sure?',
      desc: '$textAlert',
      btnCancelOnPress: () {
        print("Cancel Pressed");
      },
      btnOkOnPress: () {
        print("OK Pressed");
      },
    ).show();
  }

  void rentRoom(roomID) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: 'Are you sure?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
       postRentRoomAPI(roomID);
      },
    ).show();
  }

  Future<void> postRentRoomAPI(int roomID) async {
    final userID = ModalRoute.of(context)?.settings.arguments as int?;
    // showSuccessDialog(context, '${userID}, ${roomID}');
    try {
      final response = await http.post(
          Uri.parse('http://192.168.2.34:3000/user/rentRoom'), 
        body: jsonEncode({
          'userID': userID,
          'roomID': roomID,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          showSuccessDialog(context, response.body.toString());
          getRequestAPI();
        });
      } else {
        showErrorDialog(context, response.body); 
      }
    } catch (e) {
      showErrorDialog(context, e.toString()); 
    }
  }

  Future<void> getRoomAPI() async {
    final userID = ModalRoute.of(context)?.settings.arguments as int?;

    if (userID == null) {
      showErrorDialog(context, "User ID not found");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.2.34:3000/rooms'), // Your API endpoint
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          rooms = jsonDecode(response.body); // Update the state with new data
        });
      } else {
        showErrorDialog(context, response.body); // Show error if not 200
      }
    } catch (e) {
      showErrorDialog(context, e.toString()); // Handle exceptions
    }
  }

  Future<void> getRequestAPI() async {
    // showSuccessDialog(context, "getRequestAPI function is called");
    final userID = ModalRoute.of(context)?.settings.arguments as int?;

    if (userID == null) {
      showErrorDialog(context, "User ID not found");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://yourserver.com/user/request?userID=$userID'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        request = jsonDecode(response.body);
      } else {
        showErrorDialog(context,
            "Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      showErrorDialog(context, "Exception: ${e.toString()}");
    }
  }

  Future<void> getHistoryAPI() async {
    final userID = ModalRoute.of(context)?.settings.arguments as int?;

    if (userID == null) {
      showErrorDialog(context, "User ID not found");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://yourserver.com/user/history?userID=$userID'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        history = jsonDecode(response.body);
      } else {
        showErrorDialog(context,
            "Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      showErrorDialog(context, "Exception: ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getRoomAPI();
      getRequestAPI();
      getHistoryAPI();
    });
  }

  Widget build(BuildContext context) {
    userID = ModalRoute.of(context)?.settings.arguments as int;
    DateTime now = DateTime.now(); // Get the current date and time
    String borrowDate = "${now.year}-${now.month}-${now.day}"; // Format it
    String returnDate = "${now.year}-${now.month}-${now.day + 1}"; // Format it
    Color firstColor = Color.fromARGB(255, 254, 190, 191);
    Color secondColor = Color.fromARGB(255, 87, 150, 225);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Project",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    "$userID",
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                    child: Text("Out"),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: firstColor,
          child: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: const [
              Tab(
                icon: Icon(Icons.home),
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.book),
                text: 'My request',
              ),
              Tab(
                icon: Icon(Icons.timelapse),
                text: 'History',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Home
            SafeArea(
              child: Container(
                height: (rooms != null && rooms!.length > 3)
                    ? null
                    : MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: firstColor,
                child: Container(
                  child: rooms != null
                      ? RefreshIndicator(
                          backgroundColor: secondColor,
                          color: firstColor,
                          onRefresh: getRoomAPI,
                          child: ListView.builder(
                            itemCount: rooms?.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ID: ${rooms?[index]["ID"]}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Building: ${rooms?[index]["building"]}',
                                                ),
                                                Text(
                                                  rooms?[index]["status"] == 1
                                                      ? "Status: Available"
                                                      : "Status: Unavailable",
                                                ),
                                                Text(
                                                    "Borrow date: $borrowDate"),
                                                Text(
                                                    "Return date: ${returnDate}"),
                                              ],
                                            ),
                                            Image.asset(
                                              "assets/clock-tower.jpg",
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            )
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: FilledButton(
                                            onPressed:
                                                rooms?[index]["status"] == 1
                                                    ? () => rentRoom(
                                                        rooms?[index]["ID"])
                                                    : null,
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      rooms?[index]["status"] ==
                                                              1
                                                          ? secondColor
                                                          : secondColor
                                                              .withOpacity(
                                                                  0.3)),
                                            ),
                                            child: const Text(
                                              "Rent",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const Text("No rooms available"),
                ),
              ),
            ),

            // Request
            SafeArea(
              child: RefreshIndicator(
                backgroundColor: secondColor,
                color: firstColor,
                onRefresh: getRequestAPI,
                child: Container(
                  height: (request != null && request!.length > 3)
                      ? null
                      : MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: firstColor,
                  child: request != null
                      ? ListView.builder(
                          itemCount: request?.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'ID: ${request?[index]["ID"]}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Building: ${request?[index]["Building"]}',
                                              ),
                                              Text(
                                                'Room ID: ${request?[index]["roomID"]}',
                                              ),
                                              Text(
                                                request?[index]["status"] == 1
                                                    ? "Status: Available"
                                                    : "Status: Unavailable",
                                              ),
                                              Text(
                                                "Borrow date: ${request?[index]["borrow_date"]}",
                                              ),
                                              Text(
                                                "Return date: ${request?[index]["return_date"]}",
                                              ),
                                            ],
                                          ),
                                          Image.asset(
                                            "assets/clock-tower.jpg",
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(child: Text("No Request available")),
                ),
              ),
            ),

            //history
            SafeArea(
              child: RefreshIndicator(
                backgroundColor: secondColor,
                color: firstColor,
                onRefresh: getHistoryAPI,
                child: Container(
                  height: (history != null && history!.length > 3)
                      ? null
                      : MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: firstColor,
                  child: request != null
                      ? ListView.builder(
                          itemCount: history?.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'ID: ${history?[index]["id"]}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Building: ${history?[index]["Building"]}',
                                              ),
                                              Text(
                                                'Room ID: ${history?[index]["roomID"]}',
                                              ),
                                              Text(
                                                  'Borrow date: ${history?[index]["borrow_date"]}'),
                                              Text(
                                                  "Return date: ${history?[index]["return_date"]}"),
                                            ],
                                          ),
                                          Image.asset(
                                            "assets/clock-tower.jpg",
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(child: Text("No History available")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
