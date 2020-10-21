import 'package:couchya/api/auth.dart';
import 'package:couchya/api/team.dart';
import 'package:couchya/presentation/common/alert.dart';
import 'package:couchya/presentation/common/form_field.dart';
import 'package:couchya/utilities/api_response.dart';
import 'package:couchya/utilities/app_theme.dart';
import 'package:couchya/utilities/size_config.dart';
import 'package:couchya/utilities/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  final AsyncSnapshot snapshot;

  const LoginScreen(this.snapshot);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double _screenPadding = SizeConfig.heightMultiplier * 2;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  bool _isLoading = false;
  String _email = "";
  String _password = "";

  @override
  void dispose() {
    this._emailController.dispose();
    this._passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: this._screenPadding, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBackButton(),
                    _buildLoginForm(),
                  ],
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildBackButton() {
    return Container(
      child: GestureDetector(
        child: Icon(
          Icons.chevron_left,
          color: Colors.black,
          size: 38,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: this._formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin:
                EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 4),
            child: Text(
              'LogIn',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          CustomFormField(
            hint: 'Email',
            controller: _emailController,
            validator: (value) {
              return Validator.email(value);
            },
          ),
          CustomFormField(
            hint: 'Password',
            isPassword: true,
            controller: _passwordController,
            validator: (value) {
              return Validator.password(value);
            },
          ),
          GestureDetector(
            onTap: () {
              if (!_isLoading && _formKey.currentState.validate()) {
                this._handleLogin();
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.heightMultiplier * 3),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.inactiveGreyColor,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Center(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        'LOGIN',
                        style: Theme.of(context).textTheme.headline2.copyWith(
                              color: AppTheme.inactiveGreyColor,
                            ),
                      ),
              ),
            ),
          ),
          Container(
            child: Center(
              child: Text(
                'Forgot Password?',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildFooter() {
    return Container(
      height: SizeConfig.heightMultiplier * 18,
      width: MediaQuery.of(context).size.width,
      color: Color(0xfff6f6f6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, 'register');
            },
            child: Text(
              "Sign Up",
              style: Theme.of(context).textTheme.headline2,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    var data = {
      'email': _emailController.text,
      'password': _passwordController.text
    };

    try {
      ApiResponse apiResponse = await Auth.login(data);
      if (apiResponse.hasErrors()) {
        Fluttertoast.showToast(
            msg: apiResponse.getMessage() != ""
                ? apiResponse.getMessage()
                : 'Something went wrong. Please try again!',
            backgroundColor: Theme.of(context).accentColor);
      } else {
        if ((widget.snapshot != null && widget.snapshot.hasData)) {
          var uri = Uri.parse(widget.snapshot.data);
          var list = uri.queryParametersAll;
          int id = int.parse(list['id'][0]);
          String path = uri.path;

          if (path == "/team/join" && id != null) {
            _joinTeam(id);
          }
        }
        Navigator.of(context)
            .pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
      }
    } catch (e) {
      print(e);
      alert(context, "Please check your internet connection!");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future _joinTeam(id) async {
    Fluttertoast.showToast(
      msg: "Joining Team!",
      backgroundColor: AppTheme.accentColor,
    );
    ApiResponse r = await TeamApi.join(id);
    if (r.hasErrors()) {
      Fluttertoast.showToast(
        msg: r.getMessage() != ""
            ? r.getMessage()
            : 'Something went wrong. Please try again!',
        backgroundColor: AppTheme.accentColor,
      );
      return null;
    }
    Fluttertoast.showToast(
      msg: r.getMessage() != ""
          ? r.getMessage()
          : 'You have joined the team successfully!',
      backgroundColor: Theme.of(context).primaryColor,
    );
    return null;
  }
}
