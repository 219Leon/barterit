import 'package:barterit/screens/buyerscreen.dart';
import 'package:barterit/screens/profilescreen.dart';
import 'package:barterit/screens/sellerscreen.dart';
import '../../model/user.dart';
import '../../model/items.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScreen extends StatefulWidget {
  final User user;
  final Item item;
  var selectedIndex;
  MainScreen(
      {super.key,
      required this.selectedIndex,
      required this.user,
      required this.item});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _tabs = [
      BuyerScreen(selectedIndex: 0),
      SellerScreen(
        selectedIndex: 1,
        user: widget.user,
        item: widget.item,
      ),
      ProfileScreen(selectedIndex: 2)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 15),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GNav(
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              curve: Curves.easeOutExpo,
              gap: 10,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              activeColor: Colors.teal,
              tabBorder: Border.all(color: Colors.tealAccent),
              tabActiveBorder: Border.all(),
              tabBorderRadius: 30,
              iconSize: 20,
              tabBackgroundColor: Colors.teal.withOpacity(0.1),
              tabs: const [
                GButton(
                  icon: Icons.shopping_bag,
                  text: 'Buyer',
                ),
                GButton(
                  icon: Icons.store_mall_directory,
                  text: 'Seller',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
