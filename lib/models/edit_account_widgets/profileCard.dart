import 'package:aura/models/edit_account_widgets/user_model.dart';
import 'package:aura/screens/EditAccount.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../palette.dart';
import '../work_sans.dart';

class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, userModel, child) {
        return GestureDetector(
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditAccountpage(),
              ),
            );
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
                          userModel.name.isNotEmpty ? userModel.name[0] : 'U',
                          style: WorkSans.titleMedium.copyWith(color: Palette.white),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userModel.name,
                              style: WorkSans.titleMedium,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Age: ${userModel.age}',
                              style: WorkSans.bodyLarge.copyWith(color: Colors.grey[600]),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'ZIP Code: ${userModel.zipCode}',
                              style: WorkSans.bodyLarge.copyWith(color: Colors.grey[600]),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Gender: ${userModel.gender}',
                              style: WorkSans.bodyLarge.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
