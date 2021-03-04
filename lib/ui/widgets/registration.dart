import 'dart:ui';
import 'package:contact_book/core/database/credentialsHelper.dart';
import 'package:contact_book/core/database/databaseInitializer.dart';
import 'package:contact_book/core/database/userHelper.dart';
import 'package:contact_book/core/models/credentials.dart';
import 'package:contact_book/core/models/user.dart';
import 'package:contact_book/ui/utils/utilityFunctions.dart';
import 'package:contact_book/ui/widgets/contactList.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  Registration({Key key, this.title}) : super(key: key);

  final String title;

  static const String urlPath = "register";
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<Registration> {
  var loginCredentialsDBHelper;
  var userDBHelper;
  var status;

  @override
  void initState() {
    super.initState();
    status = false;
    var _ = DatabaseInitializer().initDb();
    loginCredentialsDBHelper = CredentialsDBHelper();
    userDBHelper = UserDBHelper();
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  TextEditingController emailFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();
  TextEditingController phoneFieldController = TextEditingController();
  TextEditingController nameFieldController = TextEditingController();
  TextEditingController addressFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final nameField = TextField(
      obscureText: false,
      controller: nameFieldController,
      keyboardType: TextInputType.text,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Full Name",
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
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))
      ),
    );

    final passwordField = TextField(
      obscureText: true,
      controller: passwordFieldController,
      keyboardType: TextInputType.text,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final phoneField = TextField(
      obscureText: false,
      controller: phoneFieldController,
      keyboardType: TextInputType.number,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Phone Number",
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
          hintText: "Address",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))
      ),
    );

    final registerButton = ElevatedButton(

      onPressed: () {
        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+"
        r"@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailFieldController.text);

        if (!emailValid || emailFieldController.text.isEmpty) {
          formResponseMassage("Email should be valid and not empty", context);
        } else if (passwordFieldController.text.isEmpty) {
          formResponseMassage("Password must not empty", context);
        } else if (passwordFieldController.text.length < 8) {
          formResponseMassage("Password must be al least 8 characters long", context);
        } else if (nameFieldController.text.isEmpty) {
          formResponseMassage("Name must not empty", context);
        } else if (phoneFieldController.text.isEmpty) {
          formResponseMassage("Phone must not empty", context);
        } else {
          // Login data checked goes here
          // like check is user registered or password correct
          User user = User(
            null,
            nameFieldController.text,
            phoneFieldController.text,
            emailFieldController.text,
            addressFieldController.text
          );

          LoginCredentials credentials = LoginCredentials(
              null,
              emailFieldController.text,
              passwordFieldController.text,
          );

          loginCredentialsDBHelper = CredentialsDBHelper();
          userDBHelper = UserDBHelper();

          userDBHelper
              .isRegistered(emailFieldController.text)
              .then((value) => setState(
                  () {
                status = value;
                if(!status){
                  formResponseMassage("Already Registered with email", context);
                } else {
                  userDBHelper.save(user);
                  loginCredentialsDBHelper.save(credentials);

                  formResponseMassage("SuccessFully Registered", context);
                  Navigator.pushNamed(context,
                      ContactsList.urlPath);
                }
              } ));
          }
      },
      child: Column(
        children: <Widget> [
          SizedBox(
            width: 150.0,
            height: 50.0,
            child: Center(
              child: Text(
                "Register",
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
                  image: AssetImage("assests/images/icon.png"),
                  width: 300,
                  height: 250,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "REGISTRATION FORM :",
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
                      SizedBox(height: 25.0),
                      passwordField,
                      SizedBox(
                        height: 35.0,
                      ),
                      registerButton,
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}