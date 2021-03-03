import 'package:contact_book/ui/widgets/addContact.dart';
import 'package:contact_book/ui/widgets/contactInfo.dart';
import 'package:contact_book/ui/widgets/contactList.dart';
import 'package:contact_book/ui/widgets/logIn.dart';
import 'package:contact_book/ui/widgets/registration.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Bhalobasar Contact Book App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: LogIn.urlPath,
      routes: {
        LogIn.urlPath: (context) => LogIn(),
        Registration.urlPath: (context) => Registration(),
        ContactInfo.urlPath: (context) => ContactInfo(),
        AddContact.urlPath: (context) => AddContact(),
        ContactsList.urlPath: (context) => ContactsList(),
      },
    );
  }
}

