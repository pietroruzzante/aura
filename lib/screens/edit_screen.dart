import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:aura/models/setting_widget/edit_item.dart';
import 'package:aura/models/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  String gender = "man";
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('age', age);
    await prefs.setString('address', address);
    await prefs.setString('gender', gender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                await saveUserInfo(nameController.text, ageController.text,
                    addressController.text);
                // We can optionally show a confirmation message here
                Navigator.pop(context);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Account",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Photo",
                widget: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 45), // Adjust the value as needed
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Palette.lightBlue1,
                    child: const Text(
                      "U",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                controller: TextEditingController(),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
