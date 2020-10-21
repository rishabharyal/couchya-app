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

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final double _screenPadding = SizeConfig.heightMultiplier * 2;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  bool _isLoading = false;
  bool _isTermsChecked = false;

  @override
  void dispose() {
    this._emailController.dispose();
    this._passwordController.dispose();
    this._nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            // height: SizeConfig.screenHeight,
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
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      height: SizeConfig.heightMultiplier * 8,
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
    return Container(
      height: SizeConfig.heightMultiplier * 70,
      child: Form(
        key: this._formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.heightMultiplier * 4),
              child: Text(
                'Sign Up',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            CustomFormField(
              hint: 'Name',
              isWhiteSpaceAllowed: true,
              controller: _nameController,
              validator: (value) {
                return Validator.username(value);
              },
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
            Container(
              child: CheckboxListTile(
                checkColor: Colors.white,
                activeColor: Theme.of(context).primaryColor,
                title: RichText(
                  text: TextSpan(
                    text: 'I agree with the',
                    style: Theme.of(context).textTheme.bodyText2,
                    children: [
                      TextSpan(
                        text: ' Terms & Conditions ',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
                value: _isTermsChecked,
                contentPadding: EdgeInsets.all(0),
                onChanged: (newValue) {
                  setState(() {
                    _isTermsChecked = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_isTermsChecked &&
                    !_isLoading &&
                    _formKey.currentState.validate()) {
                  this._handleRegister();
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
                          'SIGN UP',
                          style: Theme.of(context).textTheme.headline2.copyWith(
                                color: AppTheme.inactiveGreyColor,
                              ),
                        ),
                ),
              ),
            ),
          ],
        ),
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
            "Already have an account?",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, 'login');
            },
            child: Text(
              "Sign In",
              style: Theme.of(context).textTheme.headline2,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    var data = {
      'email': _emailController.text,
      'password': _passwordController.text,
      'name': _nameController.text,
    };

    try {
      ApiResponse response = await Auth.register(data);
      if (response.hasErrors()) {
        String error = "";
        response.getErrors().forEach((k, v) => error = error + v[0]);
        Fluttertoast.showToast(
            msg: error ?? 'Something went wrong. Please try again!',
            backgroundColor: Theme.of(context).accentColor);
      } else {
        Navigator.pushNamed(context, 'home');
      }
    } catch (e) {
      alert(context, "Please check your internet connection!");
    }

    setState(() {
      _isLoading = false;
    });
  }
}
