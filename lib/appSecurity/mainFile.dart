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
  TextEditingController vehicleNoController = TextEditingController();

  int _currentStep = 0;
  var selectedUser;

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
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
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
                    backgroundColor: const Color.fromRGBO(15, 39, 127, 1),
                  ),
                  onPressed: controls.onStepContinue,
                  child: const Text('Continue',
                      style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: controls.onStepCancel,
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white)),
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(15, 39, 127, 1),
                          ),
                          onPressed: () async {
                            await selectAndUploadImage();
                          },
                          child: const Text("Upload Picture",
                              style: TextStyle(color: Colors.white)),
                        ),
                        if (file != null)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "File Uploaded",
                              style: TextStyle(fontSize: 15),
                            ),
                          )
                      ],
                    ),
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
        return _validateStep1();
      case 2:
        return _validateStep2();
      default:
        return false;
    }
  }

  bool _validateStep0() {
    if (firstNameController.text.isEmpty) {
      _showValidationError("Please enter the first name");
      return false;
    } else if (purposeController.text.isEmpty) {
      _showValidationError("Please enter the purpose");
      return false;
    } else if (vehicleNoController.text.isEmpty) {
      _showValidationError("Please enter the vehicle number");
      return false;
    }
    return true;
  }

  bool _validateStep1() {
    return file != null;
  }

  bool _validateStep2() {
    return selectedUser != null;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  String fileName = "";

  Future<void> selectAndUploadImage() async {
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    ImagePicker imagePicker = ImagePicker();

    const source = ImageSource.camera;

    XFile? selectedFile = await imagePicker.pickImage(source: source);

    print('path == ${selectedFile?.path}');

    if (selectedFile == null) {
      EasyLoading.showError("Image not selected");
      Future.delayed(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
    } else {
      try {
        File imageFile = File(selectedFile.path);

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
        setState(() {
          fileName = selectedFile.name;
          file = selectedFile;
        });
        print(file!.name);
        SharedPreferences set = await SharedPreferences.getInstance();
        set.setString('Image', downloadUrl);

        print("Upload successful $downloadUrl");
        EasyLoading.dismiss();
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
