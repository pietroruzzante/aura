import 'package:aura/models/palette.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Palette.darkBlue),
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 5,
          child: widget,
        )
      ],
    );
  }
}