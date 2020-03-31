import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_system/services/authManagement.dart';
import 'hamburger.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HamBurger hamBurger = new HamBurger();
  Auth auth;
  Stream<QuerySnapshot> feedbacks;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(children: hamBurger.menu(context)),
      ),
      body: Center(child: Text('Welcome')),
    );
  }
}