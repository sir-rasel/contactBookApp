import 'dart:io';
import 'dart:ui';
import 'package:contact_book/core/database/credentialsHelper.dart';
import 'package:contact_book/ui/utils/utilityFunctions.dart';
import 'package:contact_book/ui/widgets/contactInfo.dart';
import 'package:contact_book/ui/widgets/contactList.dart';
import 'package:contact_book/ui/widgets/registration.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  LogIn({Key key, this.title}) : super(key: key);

  final String title;

  static const String urlPath = "logIn";
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogIn> {
  var loginCredentialsDBHelper;
  var status;

  @override
  void initState() {
    super.initState();
    loginCredentialsDBHelper = CredentialsDBHelper();
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  TextEditingController emailFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {

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

    final loginButton = ElevatedButton(

        onPressed: () {
          bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+"
          r"@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailFieldController.text);

          if (!emailValid || emailFieldController.text.isEmpty) {
            formResponseMassage("Email should be valid and not empty", context);
          } else if (passwordFieldController.text.isEmpty) {
            formResponseMassage("Password must not empty", context);
          } else {
            // Login data checked goes here
            // like check is user registered or password correct
            loginCredentialsDBHelper.getUser(emailFieldController.text)
                          .then((password) => setState(() => status = password);
            if(status == null || status != passwordFieldController.text){
              print(status.length);
              print(passwordFieldController.text);

              formResponseMassage("Email or password invalid!", context);
            } else {
              formResponseMassage("Login Successfully!!", context);
              Navigator.pushNamed(context,
                  ContactsList.urlPath);
            }
          }
        },
        child: Column(
            children: <Widget> [
              SizedBox(
                width: 150.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Logged In",
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
          backgroundColor: Colors.redAccent,
          backwardsCompatibility: true,
          automaticallyImplyLeading: true,
          leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => exit(0),
          ),
          title: Text('Bhalobasar Contact Book',),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                  icon: Icon(Icons.account_circle,
                      color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.pushNamed(context, ContactInfo.urlPath);
                  },
              ),
            ),
          ],
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
                  "LOG IN FORM :",
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
                      emailField,
                      SizedBox(height: 25.0),
                      passwordField,
                      SizedBox(
                        height: 35.0,
                      ),
                      loginButton,
                      SizedBox(
                        height: 15.0,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context,
                                Registration.urlPath);
                          },
                          child: Text("Haven't an account? then, Register"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // background
                            onPrimary: Colors.white,
                          ),
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