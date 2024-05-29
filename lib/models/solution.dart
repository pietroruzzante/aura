import 'package:flutter/material.dart';

class Solution {
  final String name;
  final String imagePath;
  final String description;
  final Widget? pageRoute;
  final String? url;

  Solution(this.name, this.imagePath, this.description, {this.pageRoute, this.url});
}