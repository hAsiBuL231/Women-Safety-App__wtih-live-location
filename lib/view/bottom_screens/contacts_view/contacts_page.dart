import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../.data/database/db_services.dart';
import '../../../.resources/colours/app_colours.dart';
import '../../../.utils/Functions.dart';
import '../../../models/contactsm.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    askPermissions();
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  filterContact() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = element.displayName!.toLowerCase();
        bool nameMatch = contactName.contains(searchTerm);
        if (nameMatch == true) {
          return true;
        }
        if (searchTermFlatten.isEmpty) {
          return false;
        }
        var phone = element.phones!.firstWhere((p) {
          String phnFlattered = flattenPhoneNumber(p.value!);
          return phnFlattered.contains(searchTermFlatten);
        });
        return phone.value != null;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermissions();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
      searchController.addListener(() {
        filterContact();
      });
    } else {
      handInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> getContactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  handInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      dialogueBox("Access to the contacts denied by the user", context);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      dialogueBox("May contact does exist in this device", context);
    }
  }

  getAllContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearchIng = searchController.text.isNotEmpty;
    bool listItemExit = (contactsFiltered.length > 0 || contacts.length > 0);
    return Scaffold(
      body: contacts.length == 0
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    controller: searchController,
                    decoration: const InputDecoration(labelText: "search contact", prefixIcon: Icon(Icons.search)),
                  ),
                ),
                listItemExit == true
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: isSearchIng == true ? contactsFiltered.length : contacts.length,
                          itemBuilder: (BuildContext context, int index) {
                            Contact contact = isSearchIng == true ? contactsFiltered[index] : contacts[index];
                            return ListTile(
                              title: Text(contact.displayName!),
                              // subtitle:Text(contact.phones!.elementAt(0)
                              // .value!) ,
                              leading: contact.avatar != null && contact.avatar!.length > 0
                                  ? CircleAvatar(backgroundColor: AppColors.primaryColor, backgroundImage: MemoryImage(contact.avatar!))
                                  : CircleAvatar(backgroundColor: AppColors.primaryColor, child: Text(contact.initials())),
                              onTap: () {
                                if (contact.phones!.length > 0) {
                                  final String phoneNum = contact.phones!.elementAt(0).value!;
                                  final String name = contact.displayName!;
                                  _addContact(TContact(phoneNum, name));
                                } else {
                                  Fluttertoast.showToast(msg: "Oops! phone number of this contact does exist");
                                }
                              },
                            );
                          },
                        ),
                      )
                    : const Text("searching"),
              ]),
            ),
    );
  }

  void _addContact(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);
    if (result != 0) {
      Fluttertoast.showToast(msg: "contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contacts");
    }
    Navigator.of(context).pop(true);
  }
}
