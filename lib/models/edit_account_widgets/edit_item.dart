import 'package:aura/models/palette.dart';
import 'package:aura/models/work_sans.dart';
import 'package:flutter/material.dart';

class EditItem extends StatelessWidget {
  final Widget widget;
  final String title;
  final TextEditingController controller;
  const EditItem({
    super.key,
    required this.widget,
    required this.title,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: WorkSans.headlineMedium.copyWith(color: Palette.darkBlue),
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          flex: 5,
          child: widget,
        )
      ],
    );
  }
}