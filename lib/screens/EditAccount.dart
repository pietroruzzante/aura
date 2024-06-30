import 'package:aura/models/edit_account_widgets/user_model.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/models/edit_account_widgets/edit_item.dart';
import 'package:aura/models/palette.dart';

class EditAccountpage extends StatefulWidget {
  const EditAccountpage({super.key});

  @override
  State<EditAccountpage> createState() => _EditAccountpageState();
}

class _EditAccountpageState extends State<EditAccountpage> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController zipController;
  late TextEditingController dateController;

  String? _nameError;
  String? _ageError;
  String? _zipError;
  String? _dateError;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final userModel = Provider.of<UserModel>(context, listen: false);
    nameController = TextEditingController(text: userModel.name);
    ageController = TextEditingController(text: userModel.age);
    zipController = TextEditingController(text: userModel.zipCode);
    dateController = TextEditingController(text: userModel.onMenstrualDate);
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
        dateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> saveUserInfo(BuildContext context) async {
    setState(() {
      _nameError = null;
      _ageError = null;
      _zipError = null;
      _dateError = null;
    });

    bool hasError = false;

    final userModel = Provider.of<UserModel>(context, listen: false);

    // Name validation
    if (nameController.text.isEmpty) {
      setState(() {
        _nameError = 'Name is necessary';
      });
      hasError = true;
    }

    // CAP validation
    if (zipController.text.isEmpty) {
      setState(() {
        _zipError = 'CAP is necessary';
      });
      hasError = true;
    } else if (zipController.text.length != 5) {
      setState(() {
        _zipError = 'CAP must be 5 numbers';
      });
      hasError = true;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(zipController.text)) {
      setState(() {
        _zipError = 'CAP must contain only numbers';
      });
      hasError = true;
    }

    // Age validation
    if (ageController.text.isEmpty) {
      setState(() {
        _ageError = 'Age is necessary';
      });
      hasError = true;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(ageController.text)) {
      setState(() {
        _ageError = 'Age must contain only numbers';
      });
      hasError = true;
    } else {
      int ageValue = int.parse(ageController.text);
      if (ageValue < 0 || ageValue > 120) {
        setState(() {
          _ageError = 'Age must be between 0 and 120';
        });
        hasError = true;
      }
    }

    // Menstrual date validation if gender is woman and manual entry is enabled
    if (userModel.gender == 'woman' && userModel.manualDateEntryEnabled && dateController.text.isEmpty) {
      setState(() {
        _dateError = 'Pick a date or disable option';
      });
      hasError = true;
    }

    if (hasError) {
      return;
    }

    await userModel.saveUserInfo(
      nameController.text,
      ageController.text,
      zipController.text,
      userModel.gender,
      dateController.text,
      userModel.manualDateEntryEnabled,
    );

    if (_nameError == null && _ageError == null && _zipError == null && _dateError == null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

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
                  await saveUserInfo(context);
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
                const SizedBox(height: 15),
                EditItem(
                  title: "Gender",
                  widget: DropdownButton<String>(
                    value: userModel.gender,
                    onChanged: (String? newValue) {
                      setState(() {
                        userModel.gender = newValue!;
                        if (newValue != "woman") {
                          dateController.clear();
                          userModel.manualDateEntryEnabled = false;
                        } else {
                          userModel.manualDateEntryEnabled = true;
                        }
                      });
                    },
                    items: <String>["man", "woman"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontSize: 15)),
                      );
                    }).toList(),
                  ),
                  controller: TextEditingController(text: userModel.gender),
                ),
                const SizedBox(height: 15),
                EditItem(
                  title: "CAP",
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
                const SizedBox(height: 15),
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
                const SizedBox(height: 15),
                if (userModel.gender == "woman")
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
                          value: !userModel.manualDateEntryEnabled,
                          onChanged: (value) {
                            setState(() {
                              userModel.manualDateEntryEnabled = !value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                if (userModel.gender == "woman")
                  Opacity(
                    opacity: !userModel.manualDateEntryEnabled ? 0.3 : 1.0,
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
                        const SizedBox(height: 20),
                        EditItem(
                          title: "Date:",
                          widget: AbsorbPointer(
                            absorbing: !userModel.manualDateEntryEnabled,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
