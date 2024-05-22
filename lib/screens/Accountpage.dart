import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:aura/screens/EditAccount.dart';
import 'package:aura/models/setting_widget/forward_button.dart';
import 'package:aura/models/setting_widget/setting_item.dart';
import 'package:aura/models/setting_widget/setting_switch.dart';
import 'package:aura/models/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Container(
      color: Palette.white,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account",style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Palette.lightBlue1, // Placeholder color
                        child: Text(
                          "U", // Initials or placeholder text
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Palette.darkBlue),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "test@example.com",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                          )
                        ],
                      ),
                      Spacer(),
                      ForwardButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAccountScreen(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Settings",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 20),
                SettingItem(
                  title: Text('Notifications',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Palette.darkBlue)),
                  icon: Ionicons.notifications,
                  bgColor: Colors.blue.shade100,
                  iconColor: Colors.blue,
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                SettingSwitch(
                  title: Text('Dark Mode',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Palette.darkBlue)),
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Palette.darkBlue)),
                  icon: Ionicons.nuclear,
                  bgColor: Colors.red.shade100,
                  iconColor: Colors.red,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
