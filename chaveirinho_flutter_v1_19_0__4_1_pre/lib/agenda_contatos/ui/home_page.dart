import 'dart:io';

import 'package:chaveirinho_flutter_v1_19_0__4_1_pre/agenda_contatos/helper/contact_helper.dart';
import 'package:chaveirinho_flutter_v1_19_0__4_1_pre/agenda_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();

    Contact contact = Contact();
    contact.email = "sdfsdf";
    contact.name = "ale";
    contact.phone = "234234235";

    helper.saveContact(contact);

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: _contactCard
      )
    );
  }

  Widget _contactCard(context, item){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[item].img != null ? FileImage(File(contacts[item].img)) : AssetImage("images/person.png"),
                    fit: BoxFit.cover
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[                    
                    Text(contacts[item].name ?? "",
                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),                              
                    ),
                    Text(contacts[item].email ?? "",
                      style: TextStyle(fontSize: 22.0),                              
                    ),
                    Text(contacts[item].phone ?? "",
                      style: TextStyle(fontSize: 22.0),                              
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showContactPage(contact: contacts[item]);
      },
    );
  }

  void _showContactPage({Contact contact}) async{
    final recContact = await Navigator.push(context, MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));
    if (recContact != null) {
      if (contact != null) {
        helper.updateContact(recContact);
      } else {
        helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts(){
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }
}