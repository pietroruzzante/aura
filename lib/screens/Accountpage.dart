import 'package:aura/models/edit_account_widgets/profileCard.dart';
import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:aura/screens/NPSpage.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
              style: WorkSans.titleMedium.copyWith(color: Palette.deepBlue),
            ),
            ProfileCard(),
            const SizedBox(height: 20),
            Text(
              "About",
              style: WorkSans.headlineLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Palette.deepBlue),
              title: Text('App Version', style: WorkSans.bodyLarge.copyWith(color: Colors.grey[600]),),
              subtitle: Text('1.0.0', style: WorkSans.bodyMedium.copyWith(color: Colors.grey[600]),),
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail, color: Palette.deepBlue,),
              title: Text('Contact Us', style: WorkSans.bodyLarge.copyWith(color: Colors.grey[600]),),
              subtitle: Text('dartvadersaura@gmail.com', style: WorkSans.bodyMedium.copyWith(color: Colors.grey[600]),),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.white, // Red background
                  foregroundColor: Colors.red, // White text
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),

                onPressed: () {
                   Navigator.push(context,
                          MaterialPageRoute(builder: ((context) => NPSpage())));
                  },
                child: Text('Logout', style: WorkSans.headlineSmall.copyWith(color: Colors.red),),
              ),
            )])));


  }
}
