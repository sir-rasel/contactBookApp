import 'package:contact_book/ui/widgets/contactInfo.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  final List<String> items = List<String>.generate(10000, (i) => "Item $i");
  static const String urlPath = "contactList";

  @override
  Widget build(BuildContext context) {
    final title = 'Long List';

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Card(
              child:
                ListTile(
                  title: Text('${items[index]}'),
                  onTap: (){
                    Navigator.pushNamed(context, ContactInfo.urlPath);
                  },
                ),
            );
          },
        ),
      );
  }
}