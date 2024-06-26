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

  String? _nameError;
  String? _ageError;
  String? _zipError;
  String? _dateError;

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
      lastDate: DateTime(2024, 12),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = picked.toLocal().toString().split(' ')[0]; // Format date as YYYY-MM-DD
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
      if (onMenstrualDate != null && onMenstrualDate.isNotEmpty) {
        selectedDate = DateTime.parse(onMenstrualDate);
        dateController.text = selectedDate.toLocal().toString().split(' ')[0];
      }
      manualDateEntryEnabled = prefs.getBool('manual_date_entry_enabled') ?? true;
    });
  }

  Future<void> saveUserInfo(
    String name,
    String age,
    String zipCode,
    String onMenstrualDate,
  ) async {
    setState(() {
      _nameError = null;
      _ageError = null;
      _zipError = null;
      _dateError = null;
    });

    bool hasError = false;

    // Name validation
    if (name.isEmpty) {
      setState(() {
        _nameError = 'Name is necessary';
      });
      hasError = true;
    }

    // CAP VALIDATION
    if (zipCode.isEmpty) {
      setState(() {
        _zipError = 'CAP is necessary';
      });
      hasError = true;
    } else if (zipCode.length != 5) {
      setState(() {
        _zipError = 'CAP must be 5 numbers';
      });
      hasError = true;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(zipCode)) {
      setState(() {
        _zipError = 'CAP must contain only numbers';
      });
      hasError = true;
    }

    // AGE VALIDATION
    if (age.isEmpty) {
      setState(() {
        _ageError = 'Age is necessary';
      });
      hasError = true;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(age)) {
      setState(() {
        _ageError = 'Age must contain only numbers';
      });
      hasError = true;
    } else {
      int ageValue = int.parse(age);
      if (ageValue < 0 || ageValue > 120) {
        setState(() {
          _ageError = 'Age must be between 0 and 120';
        });
        hasError = true;
      }
    }

    // Menstrual date validation if gender is woman and manual entry is enabled
    if (gender == "woman" && manualDateEntryEnabled && onMenstrualDate.isEmpty) {
      setState(() {
        _dateError = 'Pick a date or disable option';
      });
      hasError = true;
    }

    if (hasError) {
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
                  if (_nameError == null &&
                      _ageError == null &&
                      _zipError == null &&
                      _dateError == null) {
                    Navigator.pop(context);
                  }
                },
                style: IconButton.styleFrom(
                  backgroundColor: Palette.deepBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  fixedSize: Size(50, 50),
                  elevation: 3,
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
                Text("Account", style: WorkSans.titleMedium.copyWith(color: Palette.deepBlue, fontSize: 40)),
                const SizedBox(height: 15),
                EditItem(
                  title: "Name",
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          errorText: _nameError,
                          errorStyle: TextStyle(color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _nameError != null ? Colors.red : Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _nameError != null ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: ageController,
                        decoration: InputDecoration(
                          errorText: _ageError,
                          errorStyle: TextStyle(color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _ageError != null ? Colors.red : Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _ageError != null ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  controller: ageController,
                ),
                const SizedBox(height: 40),
                EditItem(
                  title: "ZIP Code",
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: zipController,
                        decoration: InputDecoration(
                          errorText: _zipError,
                          errorStyle: TextStyle(color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _zipError != null ? Colors.red : Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _zipError != null ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                            style: WorkSans.headlineSmall.copyWith(color: Palette.darkBlue),
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
                        const SizedBox(
                          height: 20,
                        ),
                    EditItem(
                      title: "Date:",
                      widget: AbsorbPointer(
                        absorbing: !manualDateEntryEnabled,
                        child: TextField(
                          controller: dateController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            errorText: _dateError,
                            errorStyle: TextStyle(color: Colors.red),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _dateError != null ? Colors.red : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _dateError != null ? Colors.red : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      controller: dateController,
                      
                    ),
                    ],
                  ),
            ),
          ]),
        ),
      ),
    ));
  }
}


