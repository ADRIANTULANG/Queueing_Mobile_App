import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../Config/Endpoint.dart';
import '../Methods/Style.dart';
import '../Widgets/TextField.dart';
import 'package:http/http.dart' as http;

class UpdateProfile extends StatefulWidget {
  const UpdateProfile();

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final ImagePicker picker = ImagePicker();
  final box = GetStorage();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();

  String imagePath = '';
  String imageName = '';

  @override
  void initState() {
    super.initState();
    firstname.text = box.read('firstname');
    lastname.text = box.read('lastname');
    age.text = box.read('age');
    address.text = box.read('address');
    imageName = box.read('image');
    phone.text = box.read('phoneno');
    setState(() {});
  }

  getImage() async {
    XFile imagepick = await picker.pickImage(source: ImageSource.gallery);
    if (imagepick != null) {
      setState(() {
        imagePath = imagepick.path;
        imageName = imagepick.path.split('/').last;
      });
      print(imageName);
      print(imagePath);
    }
  }

  updateInfo() async {
    try {
      var url =
          Uri.parse("${AppEndpoint.endPointDomain}/update-profile-info.php");
      var response = await http.post(url, body: {
        'id': box.read('id').toString(),
        'firstname': firstname.text,
        'lastname': lastname.text,
        'age': age.text,
        'address': address.text,
        'phoneno': phone.text,
        'image': imageName,
      });
      var res = await uploadImage(imagename: imageName, filepath: imagePath);

      if (response.statusCode == 200 && res == true) {
        box.write("firstname", firstname.text);
        box.write("lastname", lastname.text);
        box.write("address", address.text);
        box.write("phoneno", phone.text);
        box.write("age", age.text);
        box.write("image", imageName);
        Toast.show("Info updated", context,
            duration: 3, gravity: Toast.TOP, backgroundColor: Colors.lightBlue);
      } else {}
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          duration: 3, gravity: Toast.TOP);
      print(e);
    }
  }

  Future<bool> uploadImage(
      {@required String imagename, @required String filepath}) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.59.20/queuing/image-upload.php'));
    request.fields['name'] = imagename;
    var pic = await http.MultipartFile.fromPath("image", filepath);
    request.files.add(pic);
    var response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        decoration: backgroundColor(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .10,
                ),
                imagePath == ''
                    ? InkWell(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          child: CircleAvatar(
                            radius: 85,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(
                                  "${AppEndpoint.imageEndPoint}/$imageName"),
                            ),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          child: CircleAvatar(
                            radius: 85,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: FileImage(File(imagePath)),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                ),
                MyTextField(
                  controller: firstname,
                  hintText: "Firtname",
                  keyboardType: null,
                  inputFormatter: [],
                ),
                SizedBox(
                  height: 25,
                ),
                MyTextField(
                  controller: lastname,
                  hintText: "Lastname",
                  keyboardType: null,
                  inputFormatter: [],
                ),
                SizedBox(
                  height: 25,
                ),
                MyTextField(
                  controller: age,
                  hintText: "Age",
                  keyboardType: null,
                  inputFormatter: [],
                ),
                SizedBox(
                  height: 25,
                ),
                MyTextField(
                  controller: phone,
                  hintText: "Contact no.",
                  keyboardType: null,
                  inputFormatter: [],
                ),
                SizedBox(
                  height: 25,
                ),
                MyTextField(
                  controller: address,
                  hintText: "Address",
                  keyboardType: null,
                  inputFormatter: [],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                updateInfo();
                FocusScope.of(context).unfocus();
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  "UPDATE",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).textScaleFactor * 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
