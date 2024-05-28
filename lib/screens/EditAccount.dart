import 'package:aura/models/work_sans.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:aura/models/setting_widget/edit_item.dart';
import 'package:aura/models/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAccountpage extends StatefulWidget {
  const EditAccountpage({super.key});

  @override
  State<EditAccountpage> createState() => _EditAccountpageState();
}

class _EditAccountpageState extends State<EditAccountpage> {
  String gender = "man";
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name') ?? 'User';
    String? age = prefs.getString('age');
    String? address = prefs.getString('address');

    setState(() {
      nameController.text = name;
      if (age != null) ageController.text = age;
      if (address != null) addressController.text = address;
      gender = prefs.getString('gender') ?? 'man';
    });
  }

  Future<void> saveUserInfo(String name, String age, String address) async {
    setState(() {
      _errorMessage = null;
    });

    // CAP VALIDATION
    if (address.isEmpty) {
      setState(() {
        _errorMessage = 'CAP is necessary';
      });
      return;
    }

    if (address.length != 5) {
      setState(() {
        _errorMessage = 'CAP must be 5 numbers';
      });
      return;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(address)) {
      setState(() {
        _errorMessage = 'CAP must contain only numbers';
      });
      return;
    }

    // AGE VALIDATION
    if (age.isEmpty) {
      setState(() {
        _errorMessage = 'Age is necessary';
      });
      return;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(age)) {
      setState(() {
        _errorMessage = 'Age must contain only numbers';
      });
      return;
    }

    int ageValue = int.parse(age);
    if (ageValue < 0 || ageValue > 120) {
      setState(() {
        _errorMessage = 'Age must be between 0 and 120';
      });
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('age', age);
    await prefs.setString('address', address);
    await prefs.setString('gender', gender);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.white,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Ionicons.chevron_back_outline),
          ),
          leadingWidth: 80,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                onPressed: () async {
                  await saveUserInfo(
                    nameController.text,
                    ageController.text,
                    addressController.text,
                  );
                  if (_errorMessage == null) {
                    Navigator.pop(context);
                  }
                },  
                style: IconButton.styleFrom(
                  backgroundColor: Palette.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  fixedSize: Size(50, 50),
                  elevation: 3,
                ),
                icon: Icon(Ionicons.checkmark, color: Colors.white),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: TopSemiCircleClipper(),
                child: Container(
                  // sets height of top panel
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Palette.blue,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30,15,30,30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: WorkSans.titleMedium.copyWith(color: Palette.white),
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                        radius: 35,
                        backgroundColor: Palette.deepBlue, // Placeholder color
                        child: Text(
                          "U", // Initials or placeholder text
                          style: WorkSans.titleMedium.copyWith(color: Palette.blue),
                        ),
                      ),
                    const SizedBox(height: 40),
                    EditItem(
                      title: "Name",
                      widget: TextField(
                        controller: nameController,
                      ),
                      controller: nameController,
                    ),
                    const SizedBox(height: 40),
                    EditItem(
                      title: "Gender",
                      widget: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                gender = "man";
                              });
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: gender == "man"
                                  ? Palette.blue
                                  : Colors.grey.shade200,
                              fixedSize: const Size(50, 50),
                            ),
                            icon: Icon(
                              Ionicons.male,
                              color: gender == "man" ? Colors.white : Colors.black,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                gender = "woman";
                              });
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: gender == "woman"
                                  ? Palette.blue
                                  : Colors.grey.shade200,
                              fixedSize: const Size(50, 50),
                            ),
                            icon: Icon(
                              Ionicons.female,
                              color: gender == "woman" ? Colors.white : Colors.black,
                              size: 18,
                            ),
                          )
                        ],
                      ),
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 40),
                    EditItem(
                      title: "Age",
                      widget: TextField(
                        controller: ageController,
                      ),
                      controller: ageController,
                    ),
                    const SizedBox(height: 40),
                    EditItem(
                      title: "CAP",
                      widget: TextField(
                        controller: addressController,
                      ),
                      controller: addressController,
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopSemiCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.8, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}