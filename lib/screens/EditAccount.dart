import 'package:aura/models/work_sans.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:aura/models/edit_account_widgets/edit_item.dart';
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
  TextEditingController zipController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  String? _errorMessage;

  DateTime selectedDate = DateTime.now();
  bool manualDateEntryEnabled = true;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1970, 1),
        lastDate: DateTime(2024, 12));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = picked
            .toLocal()
            .toString()
            .split(' ')[0]; // Format date as YYYY-MM-DD
      });
    }
  }

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name') ?? 'User';
    String? age = prefs.getString('age');
    String? zipCode = prefs.getString('zipCode');
    String? onMenstrualDate = prefs.getString('onMenstrualDate');

    setState(() {
      nameController.text = name;
      if (age != null) ageController.text = age;
      if (zipCode != null) zipController.text = zipCode;
      gender = prefs.getString('gender') ?? 'man';
      if (onMenstrualDate != null) {
        selectedDate = DateTime.parse(onMenstrualDate);
        dateController.text = selectedDate.toLocal().toString().split(' ')[0];
      }
      manualDateEntryEnabled =
          prefs.getBool('manual_date_entry_enabled') ?? true;
    });
  }

  Future<void> saveUserInfo(
      String name, String age, String zipCode, String onMenstrualDate) async {
    setState(() {
      _errorMessage = null;
    });

    // CAP VALIDATION
    if (zipCode.isEmpty) {
      setState(() {
        _errorMessage = 'CAP is necessary';
      });
      return;
    }

    if (zipCode.length != 5) {
      setState(() {
        _errorMessage = 'CAP must be 5 numbers';
      });
      return;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(zipCode)) {
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
    await prefs.setString('zipCode', zipCode);
    await prefs.setString('gender', gender);
    await prefs.setString('onMenstrualDate', onMenstrualDate);
    await prefs.setBool('manual_date_entry_enabled', manualDateEntryEnabled);
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
                    zipController.text,
                    dateController.text,
                  );
                  if (_errorMessage == null) {
                    Navigator.pop(context);
                  }
                },
                style: IconButton.styleFrom(
                  backgroundColor: Palette.deepBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: Size(50, 50),
                  elevation: 1,
                ),
                icon: const Icon(Ionicons.checkmark, color: Palette.white),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account",
                  style: WorkSans.titleMedium
                      .copyWith(color: Palette.deepBlue, fontSize: 40),
                ),
                const SizedBox(height: 40),
                EditItem(
                  title: "Name",
                  widget: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(color: Palette.deepBlue, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(color: Palette.deepBlue, width: 2.0),
                      ),
                      hintText: 'Enter name here',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
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
                              ? Palette.deepBlue
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
                              ? Palette.yellow
                              : Colors.grey.shade200,
                          fixedSize: const Size(50, 50),
                        ),
                        icon: Icon(
                          Ionicons.female,
                          color:
                              gender == "woman" ? Colors.white : Colors.black,
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
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(color: Palette.deepBlue, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(color: Palette.deepBlue, width: 2.0),
                      ),
                      hintText: 'Enter age here',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  controller: ageController,
                ),
                const SizedBox(height: 40),
                EditItem(
                  title: "ZIP Code",
                  widget: TextField(
                    controller: zipController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(color: Palette.deepBlue, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(color: Palette.deepBlue, width: 2.0),
                      ),
                      hintText: 'Enter ZIP code here',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  controller: zipController,
                ),
                const SizedBox(height: 20),
                if (gender == "woman")
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Disable period date",
                            style: WorkSans.headlineSmall
                                .copyWith(color: Palette.darkBlue),
                          ),
                        ),
                        Switch(
                          value: !manualDateEntryEnabled,
                          onChanged: (value) {
                            setState(() {
                              manualDateEntryEnabled = !value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                if (gender == "woman")
                  Opacity(
                    opacity: !manualDateEntryEnabled ? 0.3 : 1.0,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                'Insert the date of your next menstrual cycle: ',
                                style: WorkSans.displaySmall.copyWith(
                                    fontSize: 15, color: Palette.black)),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        EditItem(
                          title: "Date",
                          widget: AbsorbPointer(
                            absorbing: !manualDateEntryEnabled,
                            child: TextField(
                              controller: dateController,
                              readOnly: true,
                              onTap: () => _selectDate(context),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Palette.deepBlue, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Palette.deepBlue, width: 2.0),
                                ),
                                hintText: 'Click to select',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          controller: dateController,
                        ),
                      ],
                    ),
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
      ),
    );
  }
}
