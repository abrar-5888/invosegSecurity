import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoseg_security/appSecurity/fetchUser.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class appSecurity extends StatefulWidget {
  const appSecurity({Key? key}) : super(key: key);

  @override
  State<appSecurity> createState() => _appSecurityState();
}

class _appSecurityState extends State<appSecurity> {
  var downloadUrl = "";
  XFile? file;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController vehicleNoController = TextEditingController();

  int _currentStep = 0;
  var selectedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchUsers("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Security",
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stepper(
        elevation: 0,
        type: StepperType.horizontal,
        currentStep: _currentStep,
        connectorColor:
            const MaterialStatePropertyAll(Color.fromRGBO(15, 39, 127, 1)),
        onStepContinue: () {
          if (_validateCurrentStep()) {
            setState(() {
              _currentStep += 1;
            });
            if (_currentStep == 3) {
              setState(() {
                firstNameController.clear();
                purposeController.clear();
                addressController.clear();
                vehicleNoController.clear();
                _currentStep = 3;
              });
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        controlsBuilder: (BuildContext context, ControlsDetails controls) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 70.0, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(15, 39, 127, 1)),
                  onPressed: controls.onStepContinue,
                  child: const Text('Continue'),
                ),
                TextButton(
                  onPressed: controls.onStepCancel,
                  child: const Text('Cancel'),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text(''),
            content: Column(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Enter Details",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: firstNameController,
                    onChanged: (value) async {
                      SharedPreferences set =
                          await SharedPreferences.getInstance();
                      set.setString('FirstName', firstNameController.text);
                    },
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the first name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: purposeController,
                    onChanged: (value) async {
                      SharedPreferences set =
                          await SharedPreferences.getInstance();
                      set.setString('LastName', purposeController.text);
                    },
                    decoration: const InputDecoration(labelText: 'Purpose'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the Purpose';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: vehicleNoController,
                    onChanged: (value) async {
                      SharedPreferences set =
                          await SharedPreferences.getInstance();
                      set.setString('VehicleNo', value);
                    },
                    decoration: const InputDecoration(labelText: 'Vehicle No.'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the vehicle number';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: addressController,
                    onChanged: (value) async {
                      SharedPreferences set =
                          await SharedPreferences.getInstance();
                      set.setString('addressTOgo', value);
                    },
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the address';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(15, 39, 127, 1)),
                        onPressed: () async {
                          // EasyLoading.show(
                          //   status: "Loading please wait",
                          // );
                          await selectAndUploadImage();
                          EasyLoading.showSuccess("Image Uploaded");
                        },
                        child: const Text(
                          "Upload Picture",
                        )),
                  ),
                )
              ],
            ),
            isActive: _currentStep == 0,
          ),
          Step(
            title: const Text(''),
            content: Column(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Confirm Details",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: downloadUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: Image.network(
                                      downloadUrl,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'First Name :         ${firstNameController.text}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Purpose :          ${purposeController.text}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Vehicle No :             ${vehicleNoController.text}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Address :         ${addressController.text}'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            isActive: _currentStep == 1,
          ),
          Step(
            title: const Text(''),
            content: const fetchUsers(),
            isActive: _currentStep == 2,
          ),
        ],
      ),
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _validateStep0();
      case 1:
      // return _validateStep1();
      case 2:
        return _validateStep1();
      case 3:
      // return _validateStep2();
      default:
        return false;
    }
  }

  bool _validateStep0() {
    if (firstNameController.text.isEmpty ||
        purposeController.text.isEmpty ||
        vehicleNoController.text.isEmpty ||
        addressController.text.isEmpty) {
      // Display an error message or handle the validation failure
      return false;
    }
    return true;
  }

  // bool _validateStep1() {
  //   // Add your validation logic for step 1
  //   // For example, you can check if a picture is uploaded
  //   return file != null;
  // }

  bool _validateStep1() {
    // Add your validation logic for step 2
    // For example, you can check if user details are confirmed
    return true; // Placeholder, replace with actual validation
  }

  bool _validateStep3() {
    // Add your validation logic for step 3
    // For example, you can check if a user is selected
    return selectedUser != null;
  }

  Future<void> selectAndUploadImage() async {
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    ImagePicker imagePicker = ImagePicker();

    const source = ImageSource.camera;

    if (source == null) {
      print("No image source selected");
      return;
    }

    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

    print('path == ${file?.path}');

    if (file == null) {
      print("File is empty");
    } else {
      try {
        File imageFile = File(file.path);

        // Ensure the file has a proper extension
        String fileExtension =
            p.extension(imageFile.path); // using the path package
        String fileName = '$uniqueName$fileExtension';

        Reference rootReference = FirebaseStorage.instance.ref();
        Reference imageReference = rootReference.child('/userDetails');
        Reference fileReference = imageReference.child(fileName);
        EasyLoading.show(status: "Loading please wait");

        await fileReference.putFile(imageFile);
        downloadUrl = await fileReference.getDownloadURL();

        SharedPreferences set = await SharedPreferences.getInstance();
        set.setString('Image', downloadUrl);

        print("Upload successful $downloadUrl");
        EasyLoading.dismiss();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  // Fetch users from Firebase based on the search query
}

class UserDetails {
  final String name;
  final String phone;

  UserDetails({
    required this.name,
    required this.phone,
  });
}
