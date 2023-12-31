import 'dart:io';
import 'package:chaveirinho/agenda_contatos/helper/contact_helper.dart';
import 'package:chaveirinho/agenda_contatos/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  ContactPage({this.contact}); //opcional

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  Contact _editedContact;

  bool userEditing = false;
  
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if (_editedContact.phone != null && _editedContact.phone.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_focusNode);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(          
            children: <Widget>[            
              GestureDetector(
                child: Container(      
                  width: 140.0,    
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedContact.img != null ? FileImage(File(_editedContact.img)) : AssetImage("images/person.png")
                    )
                  ),
                ),
                onTap: (){
                  setState(() {
                    ImagePicker().getImage(source: ImageSource.gallery).then((file){
                      if(file == null) return;
                      setState(() {
                        _editedContact.img = file.path;
                      });
                    });
                  });
                },
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "nome"                
                ),
                onChanged: (text){
                  userEditing = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },              
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "email"
                ),
                onChanged: (text){
                  userEditing = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  labelText: "phone"
                ),
                onChanged: (text){
                  userEditing = true;
                  _editedContact.phone = text;              
                },
                keyboardType: TextInputType.phone,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop(){
    if (userEditing) {      
      showDialog(        
        context: context,
        builder: (context){
          return AlertDialog(
            //backgroundColor: Colors.grey,
            title: Text("Descartar alterações?"),
            content: Text("se sair as alterações serão perdidas!"),
            actions: [
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.cancel, color: Colors.red,)
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Icon(Icons.check_circle, color: Colors.green,)
              )
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}