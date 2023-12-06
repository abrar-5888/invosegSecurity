import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RejectedLogs extends StatefulWidget {
  const RejectedLogs({super.key});

  @override
  State<RejectedLogs> createState() => _RejectedLogsState();
}

class _RejectedLogsState extends State<RejectedLogs> {
  List RejectedLogs = [];
  Future<void> RejectedLog() async {
    try {
      EasyLoading.show(status: "Please Wait");
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('entryUser')
              .where('status', isEqualTo: 'Rejected')
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
            RejectedLogs.add({
              'name': data['firstName'],
              'purpose': data['purpose'],
              'photo': data['photo'],
              'status': data['status'],
              'vehicle_No': data['vehicleNo'],
              'addressTOgo': data['addresTOgo'],
              'date': data['date'],
              'time': data['time']
            });
          });
          EasyLoading.dismiss();
        } else {
          EasyLoading.dismiss();
          RejectedLogs.clear();
        }
      }
    } catch (e) {
      RejectedLogs.clear();
      setState(() {
        EasyLoading.dismiss();
      });

      print("Error due to $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RejectedLog();

    Future.delayed(const Duration(seconds: 1), () {
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (RejectedLogs.isNotEmpty) {
      EasyLoading.dismiss();
      return Container(
          child: ListView.builder(
        itemCount: RejectedLogs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    RejectedLogs[index]['name'],
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  leading: CircleAvatar(
                    radius: 30, // Adjust the radius based on your design
                    backgroundImage: NetworkImage(
                      RejectedLogs[index]['photo'],
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
                              Text(RejectedLogs[index]['purpose']),
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
                              Text(RejectedLogs[index]['vehicle_No']),
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
                              Text(RejectedLogs[index]['date']),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  trailing: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 203, 12, 12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          RejectedLogs[index]['status'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      )),
                ),
              ),
            ),
          );
        },
      ));
    } else {
      EasyLoading.dismiss();
      return Container(
        child: const Center(
          child: Text("NO data Available"),
        ),
      );
    }
  }
}
