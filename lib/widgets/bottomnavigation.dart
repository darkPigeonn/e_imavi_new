import 'package:e_imavi/pages/history.dart';
import 'package:e_imavi/pages/home.dart';
import 'package:e_imavi/pages/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class BottomNavigationImavi extends StatefulWidget {
  BottomNavigationImavi({Key? key}) : super(key: key);

  @override
  State<BottomNavigationImavi> createState() => _BottomNavigationImaviState();
}

class _BottomNavigationImaviState extends State<BottomNavigationImavi> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Beranda',
      style: optionStyle,
    ),
    Text(
      'Index 1: Histori',
      style: optionStyle,
    ),
    Text(
      'Index 2: Profil',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {

    // if (index == 0) {
    //   Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
    // } else if (index == 1) {
    //   Navigator.push(context, MaterialPageRoute(builder: (context)=> HistoryAttendances()));
    // } else if (index == 2) {
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilUserPage()));
    // }

    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white70,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 15,
              offset: Offset(0, 5))
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Histori',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
