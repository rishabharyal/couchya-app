import 'package:couchya/api/team.dart';
import 'package:couchya/app_config.dart';
import 'package:couchya/presentation/common/form_field.dart';
import 'package:couchya/utilities/api_response.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CreateTeamScreen extends StatefulWidget {
  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  bool _isLoading = false;
  TextEditingController _nameController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Center(
        child: Text(
          'NEW TEAM',
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

  Widget _buildNextButton() {
    return Center(
      child: Container(
        height: SizeConfig.heightMultiplier * 7,
        width: SizeConfig.widthMultiplier * 50,
        margin: EdgeInsets.symmetric(vertical: 32),
        child: RaisedButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              this.createTeam();
            }
          },
          child: _isLoading
              ? Center(
                  child: SizedBox(
                    width: SizeConfig.heightMultiplier * 4,
                    height: SizeConfig.heightMultiplier * 4,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Text(
                  'NEXT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.textMultiplier * 2.4,
                  ),
                ),
          elevation: 0,
          color: Theme.of(context).primaryColor.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: CustomFormField(
              hint: 'NAME OF THE TEAM',
              controller: _nameController,
              isPassword: false,
              isWhiteSpaceAllowed: true,
              isCenterAligned: true,
              validator: (value) {
                if (value.length < 3)
                  return 'Name must contain at least 3 letters';
                return null;
              },
            ),
          ),
          _buildNextButton(),
        ],
      ),
    );
  }

  createTeam() async {
    setState(() {
      _isLoading = true;
    });
    ApiResponse r = await TeamApi.create({
      'title': _nameController.text,
    });
    setState(() {
      _isLoading = true;
    });

    if (r.hasErrors()) {
      Fluttertoast.showToast(
          msg: r.getMessage() != ""
              ? r.getMessage()
              : 'Something went wrong. Please try again!',
          backgroundColor: Theme.of(context).accentColor);
      return;
    }

    int id = r.getData()['data']['id'];
    Navigator.pop(context);
    Navigator.pushNamed(context, 'team/invite-members', arguments: id);
  }
}
