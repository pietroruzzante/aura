import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/EditAccount.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  String name = 'User';
  String age = '';
  String zipCode = '';
  String gender = 'Not specified';

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'User';
      age = prefs.getString('age') ?? 'Unknown';
      zipCode = prefs.getString('zipCode') ?? 'Unknown';
      gender = prefs.getString('gender') ?? 'Not specified';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
        color: Palette.white,
        elevation: 10,
        shadowColor: Palette.softBlue2,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Palette.rainyBlue,
                    child: Text(
                      name.isNotEmpty ? name[0] : 'U',
                      style: WorkSans.titleMedium.copyWith(color: Palette.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: WorkSans.titleMedium
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Age: $age',
                        style: WorkSans.bodyLarge.copyWith(color: Colors.grey[600])
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'ZIP Code: $zipCode',
                        style: WorkSans.bodyLarge.copyWith(color: Colors.grey[600])
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Gender: $gender',
                        style: WorkSans.bodyLarge.copyWith(color: Colors.grey[600])
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
