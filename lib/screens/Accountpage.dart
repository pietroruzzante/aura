import 'package:aura/models/work_sans.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:aura/screens/EditAccount.dart';
import 'package:aura/models/edit_account_widgets/forward_button.dart';
import 'package:aura/models/edit_account_widgets/setting_item.dart';
import 'package:aura/models/edit_account_widgets/setting_switch.dart';
import 'package:aura/models/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
typedef UserNameUpdatedCallback = void Function(String newName);

class Accountpage extends StatefulWidget {
  const Accountpage({super.key});

  @override
  State<Accountpage> createState() => _AccountpageState();
}

class _AccountpageState extends State<Accountpage> {
  bool isDarkMode = false;
  String name = 'User';

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account",
                  style: WorkSans.titleMedium.copyWith(color: Palette.white),
                ),
                const SizedBox(height: 15,),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Palette.deepBlue, // Placeholder color
                        child: Text(
                          "U", // Initials or placeholder text
                          style: WorkSans.titleMedium.copyWith(color: Palette.blue),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: WorkSans.headlineLarge.copyWith(color: Palette.white, fontSize: 30),
                          ),
            
                          const SizedBox(height: 20), // MODIFY THE UI
                        ],
                      ),
                      const Spacer(),
                      ForwardButton(
                        onTap: () async {
                          final updatedUsername = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAccountpage(),
                            ),
                          );
                          if (updatedUsername != null) {
                            setState(() {
                              name = updatedUsername;
                            });
                          }
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Settings",
                  style: WorkSans.titleMedium,
                ),
                SizedBox(height: 20),
                SettingItem(
                  title: Text('Notifications',
                  style: WorkSans.bodyMedium.copyWith(color: Palette.darkBlue)),
                  icon: Ionicons.notifications,
                  bgColor: Colors.blue.shade100,
                  iconColor: Colors.blue,
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                SettingSwitch(
                  title: Text('Dark Mode',
                  style: WorkSans.bodyMedium.copyWith(color: Palette.darkBlue)),
                  icon: Ionicons.earth,
                  bgColor: Colors.purple.shade100,
                  iconColor: Colors.purple,
                  value: isDarkMode,
                  onTap: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                SettingItem(
                  title: Text('Help',
                  style: WorkSans.bodyMedium.copyWith(color: Palette.darkBlue)),
                  icon: Ionicons.nuclear,
                  bgColor: Colors.red.shade100,
                  iconColor: Colors.red,
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
  }
}
