import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:invoseg_security/appSecurity/mainFile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int approvedUser = 0;
  int pendingUser = 0;
  int rejectedUser = 0;
  List<Map<String, dynamic>> users = [];
  Map<String, List<Map<String, dynamic>>> groupedUsers = {};

  Future<void> getApprovedUser() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('entryUser')
              .where('status', isEqualTo: 'Approved')
              .get();
      List<DocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      for (DocumentSnapshot<Map<String, dynamic>> document in documents) {
        // Access document data using document.data()
        Map<String, dynamic> data = document.data()!;

        // Perform actions with data, e.g., print it
        print("Document ID: ${document.id}, Data: $data");

        if (data.isNotEmpty) {
          setState(() {
            users.add({
              'name': data['firstName'],
              'date': data['date'],
              'time': data['time']
            });
          });
        } else {
          users.clear();
        }
      }

      setState(() {
        groupedUsers = groupDocumentsByDate(users);
        approvedUser = documents.length;
      });
      print(groupedUsers);

      print(documents.length);
    } catch (e) {
      print("Error due to $e");
    }
  }

  // Helper function to group documents by date
  Map<String, List<Map<String, dynamic>>> groupDocumentsByDate(
      List<Map<String, dynamic>> documents) {
    Map<String, List<Map<String, dynamic>>> groupedDocuments = {};

    for (var document in documents) {
      String date = document['date'];

      if (!groupedDocuments.containsKey(date)) {
        groupedDocuments[date] = [];
      }

      groupedDocuments[date]!.add(document);
    }

    return groupedDocuments;
  }

  Future<void> getPendingUser() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('entryUser')
              .where('status', isEqualTo: 'pending')
              .get();
      List<DocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;
      setState(() {
        pendingUser = documents.length;
      });
      print(documents.length);
    } catch (e) {
      print("Error due to $e");
    }
  }

  Future<void> getRejectedUser() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('entryUser')
              .where('status', isEqualTo: 'Rejected')
              .get();
      List<DocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;
      setState(() {
        rejectedUser = documents.length;
      });
      print(documents.length);
    } catch (e) {
      print("Error due to $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApprovedUser();
    getPendingUser();
    getRejectedUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const appSecurity(),
                ));
          },
          backgroundColor: const Color.fromRGBO(15, 39, 127, 1),
          child: const Icon(Icons.add)),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Home Screen",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: Container(),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 10, bottom: 8),
                  child: SizedBox(
                    height: 300,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Colors.tealAccent,
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Approved Users",
                                      style: TextStyle(
                                        fontSize: 23,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "$approvedUser",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.done_outline_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 145,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          color: Colors.amberAccent,
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Pending Users",
                                          style: TextStyle(
                                              fontSize: 23,
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "$pendingUser",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.pending_actions,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 145,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          color: Colors.lightBlueAccent,
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Rejected Users",
                                          style: TextStyle(
                                              fontSize: 23,
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "$rejectedUser",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.cancel_sharp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: Container(
              // height: ,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
              ),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              subtitle: Text(users[index]['date']),
                              title: Text(
                                  "${users[index]['name']} has been Approved"),
                              leading: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color:
                                          const Color.fromRGBO(15, 39, 127, 1),
                                    ),
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: SvgPicture.asset(
                                    'assets/Svg/user_security_token.svg', // Replace with your SVG file path
                                    width: 30,
                                    height: 30,
                                    // color: Colors
                                    //     .blue, // You can set the color if needed
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: users.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
