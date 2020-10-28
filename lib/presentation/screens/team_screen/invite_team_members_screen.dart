import 'package:contacts_service/contacts_service.dart';
import 'package:couchya/api/team.dart';
import 'package:couchya/presentation/common/form_field.dart';
import 'package:couchya/utilities/api_response.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class InviteTeamMembersScreen extends StatefulWidget {
  final int id;

  const InviteTeamMembersScreen(this.id);
  @override
  _InviteTeamMembersScreenState createState() =>
      _InviteTeamMembersScreenState();
}

class _InviteTeamMembersScreenState extends State<InviteTeamMembersScreen> {
  bool isSearching = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _isGettingContacts = false;

  TextEditingController searchController = new TextEditingController();
  List<Contact> contacts = [];
  List<Contact> selectedContacts = [];
  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  getAllContacts() async {
    setState(() {
      _isGettingContacts = true;
    });
    List colors = [Colors.green, Colors.indigo, Colors.yellow, Colors.orange];
    int colorIndex = 0;
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    _contacts.forEach((contact) {
      Color baseColor = colors[colorIndex];
      contactsColorMap[contact.displayName] = baseColor;
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
    });
    setState(() {
      contacts = _contacts;
      _isGettingContacts = false;
    });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        children: [
          _buildSearchBar(),
          _buildSelectedContactsHeader(),
          _buildSelectedContactsListView(),
          _buildAllContactsHeader(),
          _buildAllContactsListView(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: CustomFormField(
                hint: 'Search/Add Phone',
                controller: searchController,
                isPassword: false,
                isWhiteSpaceAllowed: true,
                validator: (value) {
                  if (value.length < 3)
                    return 'Name must contain at least 3 letters';
                  if (value.length != 10) {
                    return 'Please Enter a valid Number';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.add_circle),
                iconSize: 32,
                onPressed: _isGettingContacts
                    ? null
                    : () {
                        if (_formKey.currentState.validate()) {
                          this._addNumber();
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addNumber() {
    Contact phone = Contact(
      displayName: searchController.text,
      givenName: searchController.text,
      phones: [
        Item(
          label: searchController.text,
          value: searchController.text,
        )
      ],
    );
    if (!selectedContacts.contains(phone))
      setState(() {
        selectedContacts.add(phone);
      });
  }

  Widget _buildAllContactsHeader() {
    return Container(
      width: SizeConfig.screenWidth,
      color: Color(0xffd9d9d9),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'ALL CONTACTS',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  Widget _buildSelectedContactsHeader() {
    return Container(
      width: SizeConfig.screenWidth,
      color: Color(0xffd9d9d9),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'SELECTED CONTACTS',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  Widget _buildAllContactsListView() {
    return _isGettingContacts
        ? Expanded(
            child: Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 4),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: isSearching == true
                    ? contactsFiltered.length
                    : contacts.length,
                itemBuilder: (context, index) {
                  Contact contact = isSearching == true
                      ? contactsFiltered[index]
                      : contacts[index];

                  return selectedContacts.contains(contact)
                      ? Container()
                      : ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                          title: Text(
                            contact.displayName,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.add_circle_outline_sharp,
                              color: Colors.black,
                              size: 28,
                            ),
                            onPressed: () {
                              setState(() {
                                this.selectedContacts.add(contact);
                              });
                            },
                          ),
                          leading: (contact.avatar != null &&
                                  contact.avatar.length > 0)
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(contact.avatar),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  child: CircleAvatar(
                                    radius: 28,
                                    child: Text(
                                      contact.initials(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                        );
                },
              ),
            ),
          );
  }

  Widget _buildSelectedContactsListView() {
    return Expanded(
      flex: 0,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 4),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: selectedContacts.length,
          itemBuilder: (context, index) {
            Contact contact = selectedContacts[index];
            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 12),
              title: Text(
                contact.displayName,
                style: Theme.of(context).textTheme.headline2,
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.remove_circle,
                  color: Theme.of(context).accentColor,
                  size: 28,
                ),
                onPressed: () {
                  setState(() {
                    this.selectedContacts.remove(contact);
                  });
                },
              ),
              leading: (contact.avatar != null && contact.avatar.length > 0)
                  ? CircleAvatar(
                      backgroundImage: MemoryImage(contact.avatar),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        child: Text(
                          contact.initials(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      this.isSearching = searchController.text.isNotEmpty;
    });
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: isLoading
          ? SizedBox(
              width: 10,
              height: 10,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : IconButton(
              icon: Icon(Icons.check),
              iconSize: 24,
              color: Colors.black,
              onPressed: selectedContacts.length == 0
                  ? null
                  : () async {
                      await sendInvitations();
                    },
            ),
      title: Center(
        child: Text(
          'INVITE CONTACTS',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.close),
          iconSize: 24,
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  sendInvitations() async {
    setState(() {
      isLoading = true;
    });
    List<String> selectedNumbers = selectedContacts
        .map((e) => e.phones.length > 0 ? e.phones.elementAt(0).value : '')
        .toList();
    ApiResponse r = await TeamApi.sendInvitation(
        {'team_id': widget.id, 'invitations': selectedNumbers});
    setState(() {
      isLoading = false;
    });
    if (r.hasErrors()) {
      Fluttertoast.showToast(
        msg: 'Something went wrong. Please try again!',
        backgroundColor: Theme.of(context).accentColor,
      );
      return;
    }
    Fluttertoast.showToast(
        msg: r.getMessage(), backgroundColor: Theme.of(context).primaryColor);
    Navigator.pop(context);
  }
}
