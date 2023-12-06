import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CompletedLogs extends StatefulWidget {
  const CompletedLogs({super.key});

  @override
  State<CompletedLogs> createState() => _CompletedLogsState();
}

class _CompletedLogsState extends State<CompletedLogs> {
  List CompletedLogs = [];
  Future<void> CompletedLog() async {
    try {
      EasyLoading.show(status: "Please Wait");
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
            CompletedLogs.add({
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
          CompletedLogs.clear();
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
    CompletedLog();
    Future.delayed(const Duration(seconds: 1), () {
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (CompletedLogs.isNotEmpty) {
      return Container(
          child: ListView.builder(
        itemCount: CompletedLogs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    CompletedLogs[index]['name'],
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  leading: CircleAvatar(
                    radius: 30, // Adjust the radius based on your design
                    backgroundImage: NetworkImage(
                      CompletedLogs[index]['photo'],
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
                              Text(CompletedLogs[index]['purpose']),
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
                              Text(CompletedLogs[index]['vehicle_No']),
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
                              Text(CompletedLogs[index]['date']),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  trailing: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 26, 187, 20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          CompletedLogs[index]['status'],
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
      return Container(
        child: const Center(
          child: Text("NO data Available"),
        ),
      );
    }
  }
}
