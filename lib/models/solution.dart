import 'package:aura/screens/ElectroSolution.dart';
import 'package:aura/screens/MusicSolution.dart';
import 'package:flutter/material.dart';

class Solution {
  final String name;
  final String imagePath;
  final Widget pageRoute;

  Solution(this.name, this.imagePath, this.pageRoute);
}