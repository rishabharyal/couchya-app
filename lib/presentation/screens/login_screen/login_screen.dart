import 'package:couchya/api/auth.dart';
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
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double _screenPadding = SizeConfig.heightMultiplier * 2;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  bool _isLoading = false;

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
          height: SizeConfig.screenHeight - MediaQuery.of(context).padding.top,
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
            isWhiteSpaceAllowed: false,
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
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      width: MediaQuery.of(context).size.width,
      color: Color(0xfff6f6f6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, 'register');
              },
              child: Text(
                "Sign up",
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
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
}
