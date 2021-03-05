import 'package:contact_book/core/database/contactsHelper.dart';
import 'package:contact_book/core/database/databaseInitializer.dart';
import 'package:contact_book/core/database/userHelper.dart';
import 'package:contact_book/core/models/contact.dart';
import 'package:contact_book/ui/widgets/addContact.dart';
import 'package:contact_book/ui/widgets/contactInfo.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'logIn.dart';

class ContactsList extends StatefulWidget {
  ContactsList({Key key, this.email}) : super(key: key);
  final String email;

  static const String urlPath = "contactList";

  @override
  _ContactsListState createState() => _ContactsListState(email : email);
}

class _ContactsListState extends State<ContactsList> {
  _ContactsListState({this.email}) : super();

  String email;
  var contactsDBHelper;
  var userDBHelper;
  String userName;

  List<Contact> contacts = [];
  List<Contact> items = [];

  @override
  void initState() {
    super.initState();
    var _ = DatabaseInitializer().initDb();
    contactsDBHelper = ContactDBHelper();
    userDBHelper = UserDBHelper();

    contactsDBHelper.getContacts(email).then((value) => setState(() {
      contacts = value;
      for(var item in contacts)
        items.add(item);
    }));

    userDBHelper.getUserName(email).then((value) => setState((){
      userName = value;
    }));
  }

  void filterContact(String searchTerm) {
    var tmpSearchList = [];
    for(var item in items)
      tmpSearchList.add(item);

    if (searchTerm.isNotEmpty) {
      List<Contact> tmpList = [];

      tmpSearchList.forEach((element) {
        if(element.name.toLowerCase().contains(searchTerm.trim())) {
          tmpList.add(element);
        }
      });

      setState(() {
        contacts.clear();
        for(var item in tmpList)
          contacts.add(item);
      });
      return;
    }
    else{
      setState(() {
        contacts.clear();
        for(var item in items)
          contacts.add(item);
      });
    }
  }

  void _launchURL(_url) async =>
      await canLaunch(_url) ?
      await launch(_url) :
      throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    final title = 'Bahalobasar Contacts';

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(2.0),
              margin: EdgeInsets.all(5.0),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0))
                    ),
                    prefix: Icon(Icons.search),
                    labelText: 'Search'
                ),
                onChanged: (value){
                  filterContact(value.toLowerCase());
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return Card(
                    child:
                      ListTile(
                        title: Center(child: Text(
                            '${contacts[index].name}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )),
                        subtitle: Column(
                          children: [
                            Text(
                              '${contacts[index].contactEmail}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '${contacts[index].phone}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                  child: IconButton(icon:Icon(Icons.phone),
                                    onPressed: () {
                                      _launchURL('tel: ${contacts[index].phone}');
                                    },
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                  child: IconButton(icon:Icon(Icons.email),
                                    onPressed: () {
                                      final Uri _emailLaunchUri = Uri(
                                          scheme: 'mailto',
                                          path: '${contacts[index].contactEmail}',
                                          queryParameters: {
                                            'subject': 'Conversion'
                                          }
                                      );
                                      _launchURL(_emailLaunchUri.toString());
                                    },
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                  child: IconButton(icon:Icon(Icons.sms),
                                    onPressed: () {
                                      _launchURL('sms: ${contacts[index].phone}');
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: IconButton(icon:Icon(Icons.person),),
                        ),
                        trailing: CircleAvatar(
                          child: IconButton(icon:Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                contactsDBHelper.delete(contacts[index].id);
                                items.removeAt(index);
                                contacts.clear();
                                for(var item in items)
                                  contacts.add(item);
                              });
                            },
                          ),
                          backgroundColor: Colors.lightBlue,
                        ),

                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ContactInfo(
                                      id: contacts[index].id,
                                      name : userName,
                                  ),
                            ),
                          );
                        },
                      ),
                  );
                },
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: <Widget>[
              UserAccountsDrawerHeader(
                  accountName: Text('$userName'),
                  accountEmail: Text('$email'),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(icon:Icon(Icons.person),iconSize: 50,),
                  ),
              ),
              Card(
                child: ListTile(
                  title: Text("Add New Contact"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddContact(
                                email: email,
                            ),
                      ),
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Sort By Name"),
                  onTap: () {
                    setState(() {
                      items.sort((a, b) =>
                          a.name.compareTo(b.name));

                      contacts.clear();
                      for(var item in items)
                        contacts.add(item);
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Sort By Number"),
                  onTap: () {
                    setState(() {
                      items.sort((a, b) =>
                          a.phone.compareTo(b.phone));

                      contacts.clear();
                      for(var item in items)
                        contacts.add(item);
                      Navigator.pop(context);
                    });
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
          ),
        ),
      );
  }
}