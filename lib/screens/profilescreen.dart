import 'dart:async';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget{
  final int selectedIndex;
  const ProfileScreen({super.key, required this.selectedIndex});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
  }
  
  class _ProfileScreenState extends State<ProfileScreen> {

      @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: Column(
        children: [
          const Text("Profile Screen"),
        ],
      ),
    );
  }
  }
