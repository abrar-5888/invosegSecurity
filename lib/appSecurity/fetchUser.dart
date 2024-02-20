import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:invoseg_security/tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class fetchUsers extends StatefulWidget {
  const fetchUsers({super.key});

  @override
  State<fetchUsers> createState() => _fetchUsersState();
}

class _fetchUsersState extends State<fetchUsers> {
  List usersList = [];
  void fetchUsers(String query) {
    // You need to implement fetching users from Firebase based on your data model
    // For example, if you have a 'users' collection in Firebase Firestore:
    // Replace 'your_firestore_collection' with your actual collection name

    if (query.contains('House') || query.contains('house')) {
      // Fetch all documents when the search query is empty
      FirebaseFirestore.instance
          .collection('UserRequest')
          .where('address', isEqualTo: query)
          .get()
          .then((QuerySnapshot querySnapshot) {
        usersList.clear();
        for (var doc in querySnapshot.docs) {
          setState(() {
            usersList.add({
              'id': doc['uid'],
              'name': doc['Name'],
              'phoneNumber': doc['phonenumber'],
              'address': doc['address']
            });
          });
        }
        // setState(() {}); // Update the UI to reflect the changes
      }).catchError((error) {
        print('Error fetching users: $error');
      });
    } else {
      // Fetch only matching documents when the search query is not empty
      if (query.startsWith('03')) {
        FirebaseFirestore.instance
            .collection('UserRequest')
            .where('phonenumber', isEqualTo: query)
            .get()
            .then((QuerySnapshot querySnapshot) {
          usersList.clear();
          for (var doc in querySnapshot.docs) {
            setState(() {
              usersList.add({
                'id': doc['uid'],
                'name': doc['Name'],
                'phoneNumber': doc['phonenumber'],
                'address': doc['address']
              });
            });
          }
          setState(() {}); // Update the UI to reflect the changes
        }).catchError((error) {
          print('Error fetching users: $error');
        });
      } else {
        FirebaseFirestore.instance
            .collection('UserRequest')
            .where('Name', isEqualTo: query)
            .get()
            .then((QuerySnapshot querySnapshot) {
          usersList.clear();
          for (var doc in querySnapshot.docs) {
            setState(() {
              usersList.add({
                'id': doc['uid'],
                'name': doc['Name'],
                'phoneNumber': doc['phonenumber'],
                'address': doc['address']
              });
            });
          }
          setState(() {}); // Update the UI to reflect the changes
        }).catchError((error) {
          print('Error fetching users: $error');
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchAllUsers();
  }

  TextEditingController searchUserController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Align(
        alignment: Alignment.center,
        child: Text(
          "Select User",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: searchUserController,
          onChanged: (value) {
            fetchUsers(searchUserController.text);
          },
          decoration: InputDecoration(
            labelText: 'Search User by Name or Phone',
            suffixIcon: IconButton(
              onPressed: () {
                // Fetch users based on searchUserController.text
                // Update usersList accordingly
                // For example:
                fetchUsers(searchUserController.text);
              },
              icon: const Icon(Icons.search),
            ),
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 2.5,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: usersList.length,
          itemBuilder: (context, index) {
            var name = usersList[index]['name'];
            var phoneNumber = usersList[index]['phoneNumber'];
            var id = usersList[index]['id'];

            var address = usersList[index]['address'];
            // var user = usersList[index];
            return ListTile(
              title: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Phone Number",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$name",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "$phoneNumber",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Address",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$address",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            DateTime dateTime = DateTime.now();
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(dateTime);
                            print(formattedDate); // Output: 03/12/2023
                            String formattedTime =
                                DateFormat('h:mm:ss a').format(dateTime);
                            print(formattedTime);
                            SharedPreferences get =
                                await SharedPreferences.getInstance();
                            var fname = get.getString('FirstName');
                            var lname = get.getString('LastName');
                            var addressTOgo = get.getString('addressTOgo');
                            var vhicleNo = get.getString('VehicleNo');
                            var photo = get.getString('Image');
                            // Implement your logic to send details
                            // Close the dialog
                            try {
                              await FirebaseFirestore.instance
                                  .collection('entryUser')
                                  .add({
                                'Mainid': id,
                                'date': formattedDate,
                                'time': formattedTime,
                                'firstName': fname,
                                'vehicleNo': vhicleNo,
                                'purpose': lname,
                                'addresTOgo': addressTOgo,
                                'photo': photo,
                                'status': 'pending',
                              }).then((DocumentReference
                                      documentReference) async {
                                await FirebaseFirestore.instance
                                    .collection('entryUser')
                                    .doc(documentReference.id)
                                    .update({'id': documentReference.id});

                                await FirebaseFirestore.instance
                                    .collection('notifications')
                                    .add({
                                  'pressedTime': DateTime.now(),
                                  'uid': id,
                                  'id': documentReference.id,
                                  'description':
                                      "please confirm identity of your friend",
                                  'isRead': false,
                                  'title': 'Security',
                                  'date': formattedDate,
                                  'time': formattedTime,
                                  'image':
                                      'https://blog.udemy.com/wp-content/uploads/2014/05/bigstock-test-icon-63758263.jpg'
                                });
                              });
                              EasyLoading.showSuccess("Request has been sent");
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TabsScreen(index: 0)));
                                EasyLoading.dismiss();
                              });
                            } catch (e) {
                              print("Error");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(15, 39, 127, 1)),
                          child: const Text(
                            "Send",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.grey,
                      height: 3,
                      width: MediaQuery.of(context).size.width,
                    )
                  ],
                ),
              ),
              onTap: () {},
            );
          },
        ),
      ),
    ]);
  }
}
