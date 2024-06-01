import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Solution {
  final String name;
  final String imagePath;
  final String description;
  final Widget? pageRoute;
  final String? url;

  Solution(this.name, this.imagePath, this.description, {this.pageRoute, this.url});

  Future<void> open(BuildContext context) async {
    if (url != null) {
      final Uri toLaunch = Uri.parse(url!);
      if (!await launchUrl(toLaunch, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } else if (pageRoute != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => pageRoute!),
      );
    }
  }
}