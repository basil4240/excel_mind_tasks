import 'package:flutter/material.dart';

class MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}