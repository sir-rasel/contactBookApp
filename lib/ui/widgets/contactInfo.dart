import 'dart:ui';
import 'package:contact_book/core/database/contactsHelper.dart';
import 'package:contact_book/core/database/databaseInitializer.dart';
import 'package:contact_book/core/models/contact.dart';
import 'package:contact_book/ui/utils/utilityFunctions.dart';
import 'package:contact_book/ui/widgets/addContact.dart';
import 'package:contact_book/ui/widgets/logIn.dart';
import 'package:flutter/material.dart';

import 'contactList.dart';

class ContactInfo extends StatefulWidget {
  ContactInfo({Key key, this.id}) : super(key: key);
  final int id;

  static const String urlPath = "details";
  @override
  _ContactInfoPageState createState() => _ContactInfoPageState(id: id);
}

class _ContactInfoPageState extends State<ContactInfo> {
  _ContactInfoPageState({this.id}) : super();
  final int id;

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  TextEditingController emailFieldController;
  TextEditingController phoneFieldController;
  TextEditingController nameFieldController;
  TextEditingController addressFieldController;

  var contactsDBHelper;
  Contact contact;

  @override
  void initState() {
    super.initState();
    var _ = DatabaseInitializer().initDb();
    contactsDBHelper = ContactDBHelper();

    contactsDBHelper.getContact(id).then((value) => setState(() {
      contact = value;
      print(contact.toMap());
      if(contact != null) {
        emailFieldController = TextEditingController(text: '${contact.contactEmail}');
        nameFieldController = TextEditingController(text: '${contact.name}');
        phoneFieldController = TextEditingController(text: '${contact.phone}');
        addressFieldController = TextEditingController(text: '${contact.address}');
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    final nameField = TextField(
      obscureText: false,
      controller: nameFieldController,
      keyboardType: TextInputType.text,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))
      ),
    );

    final emailField = TextField(
      obscureText: false,
      controller: emailFieldController,
      keyboardType: TextInputType.emailAddress,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))
      ),
    );

    final phoneField = TextField(
      obscureText: false,
      controller: phoneFieldController,
      keyboardType: TextInputType.number,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))
      ),
    );

    final addressField = TextField(
      obscureText: false,
      controller: addressFieldController,
      keyboardType: TextInputType.text,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))
      ),
    );

    final updateButton = ElevatedButton(

      onPressed: () {
        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+"
        r"@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailFieldController.text);

        if (!emailValid || emailFieldController.text.isEmpty) {
          formResponseMassage("Email should be valid and not empty", context);
        } else if (nameFieldController.text.isEmpty) {
          formResponseMassage("Name must not empty", context);
        } else if (phoneFieldController.text.isEmpty) {
          formResponseMassage("Phone must not empty", context);
        } else {
          // Login data checked goes here
          // like check is user registered or password correct

          if(emailFieldController.text.length > 0)
            contact.email = emailFieldController.text;
          if(nameFieldController.text.length > 0)
            contact.name = nameFieldController.text;
          if(phoneFieldController.text.length > 0)
            contact.phone = phoneFieldController.text;
          if(addressFieldController.text.length > 0)
            contact.address = addressFieldController.text;

          contactsDBHelper.update(contact);
          formResponseMassage("Updated Sucessfully", context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ContactsList(
                      email: emailFieldController.text
                  ),
            ),
          );
        }
      },
      child: Column(
        children: <Widget> [
          SizedBox(
            width: 150.0,
            height: 50.0,
            child: Center(
              child: Text(
                "Update",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        ],
      ),

    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backwardsCompatibility: true,
          automaticallyImplyLeading: true,
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),
          ),
          backgroundColor: Colors.redAccent,
          title: Text('Bhalobasar Contact Book'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Image(
                  image: AssetImage("assests/images/person.jpg"),
                  width: 300,
                  height: 250,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Contact Details :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.red.withOpacity(1.0),
                    decoration: TextDecoration.underline,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      nameField,
                      SizedBox(height: 20.0),
                      emailField,
                      SizedBox(height: 20.0),
                      phoneField,
                      SizedBox(height: 20.0),
                      addressField,
                      SizedBox(height: 35.0),
                      updateButton,
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      endDrawer: Drawer(
        child: contact != null? ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('${contact.name}'),
              accountEmail: Text('${contact.email}'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(icon:Icon(Icons.person),iconSize: 50,),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Add New Contact"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddContact(
                            email: contact.email,
                          ),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                tileColor: Colors.red,
                title: Text("Log Out"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LogIn(),
                    ),
                  );
                },
              ),
            ),
          ],
        ):null,
      ),
    );
  }
}