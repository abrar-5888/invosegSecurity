import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

class PendingLogs extends StatefulWidget {
  const PendingLogs({super.key});

  @override
  State<PendingLogs> createState() => _PendingLogsState();
}

class _PendingLogsState extends State<PendingLogs> {
  List pendingLogs = [];
  Future<void> pendingLog() async {
    try {
      EasyLoading.show(status: "Please Wait");
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('entryUser')
              .where('status', isEqualTo: 'pending')
              .get();
      List<DocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;
      for (DocumentSnapshot<Map<String, dynamic>> document in documents) {
        // Access document data using document.data()
        Map<String, dynamic> data = document.data()!;

        // Perform actions with data, e.g., print it
        print("Document ID: ${document.id}, Data: $data");

        QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore
            .instance
            .collection('UserRequest')
            .where('uid', isEqualTo: data['Mainid'])
            .limit(1)
            .get();
        List<DocumentSnapshot<Map<String, dynamic>>> doc = query.docs;

        if (doc.isNotEmpty) {
          // Access the document
          DocumentSnapshot<Map<String, dynamic>> document1 = doc.first;
          Map<String, dynamic> data1 = document1.data()!;
          print(data1['phonenumber']);
          if (data.isNotEmpty) {
            setState(() {
              pendingLogs.add({
                'name': data['firstName'],
                'purpose': data['purpose'],
                'photo': data['photo'],
                'status': data['status'],
                'vehicle_No': data['vehicleNo'],
                'addressTOgo': data['addresTOgo'],
                'date': data['date'],
                'time': data['time'],
                'number': data1['phonenumber']
              });
              // print(data['time']);
            });
            EasyLoading.dismiss();
          } else {
            EasyLoading.dismiss();
            pendingLogs.clear();
          }
        } else {
          // No matching document found
          print("No matching document found");
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Error due to $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pendingLog();
    Future.delayed(const Duration(seconds: 1), () {
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pendingLogs.isNotEmpty) {
      return Container(
          child: ListView.builder(
        itemCount: pendingLogs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    pendingLogs[index]['name'],
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  leading: CircleAvatar(
                    radius: 30, // Adjust the radius based on your design
                    backgroundImage: NetworkImage(
                      pendingLogs[index]['photo'],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Purpose :",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(pendingLogs[index]['purpose']),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Vehcile No :",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(pendingLogs[index]['vehicle_No']),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Date :",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(pendingLogs[index]['date']),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  trailing: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(15, 39, 127, 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              pendingLogs[index]['status'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          )),
                      const SizedBox(height: 2),
                      SizedBox(
                          height: 25,
                          width: 60,
                          child: Container(
                            child: IconButton(
                              icon: const Icon(Icons.call),
                              onPressed: () async {
                                final url =
                                    'tel:${pendingLogs[index]['number']}';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  // throw 'Could not launch $url';
                                }
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ));
    } else {
      return Container(
        child: const Center(
          child: Text("NO data Available"),
        ),
      );
    }
  }
}
