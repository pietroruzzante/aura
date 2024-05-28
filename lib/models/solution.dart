import 'package:flutter/material.dart';

class Solution {
  final String name;
  final String imagePath;
  final String description;
  final Widget? pageRoute;

  Solution(this.name, this.imagePath, this.description, {this.pageRoute});
}