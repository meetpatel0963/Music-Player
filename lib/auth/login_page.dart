import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'text-field-input.dart';
import 'password-input.dart';
import 'rounded-button.dart';

const TextStyle kBodyText =
    TextStyle(fontSize: 22, color: Colors.white, height: 1.5);

const Color bgColor = Color(0xFF111111);
const Color kWhite = Colors.white;
const Color kBlue = Color(0xff5663ff);

class FirstNameValidator {
  static String validate(String value) {
    return value.isEmpty ? 'First Name can\'t be empty' : null;
  }
}

class LastNameValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Last Name can\'t be empty' : null;
  }
}

class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({this.onSignedIn});
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

enum FormType {
  login,
  register,
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _firstName;
  String _lastName;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        final BaseAuth auth = AuthProvider.of(context).auth;
        if (_formType == FormType.login) {
          final String userId =
              await auth.signInWithEmailAndPassword(_email, _password);
          print('Signed in: $userId');
        } else {
          final String userId =
              await auth.createUserWithEmailAndPassword(_email, _password);
          await FirebaseFirestore.instance
              .collection('user')
              .add({
                'firstname': _firstName,
                'lastname': _lastName,
                'userId': userId,
              })
              .then((value) => print("User Added"))
              .catchError((error) => print("Failed to add user: $error"));
          print('Registered user: $userId');
        }
        widget.onSignedIn();
      } catch (e) {
        print('Error: $e');
        await Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: formKey,
          child: Scaffold(
            backgroundColor: bgColor,
            body: ListView(
              children: [
                SizedBox(height: 80),
                Center(
                  child: Text(
                    'Foodybite',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 75),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: buildInputs() + buildSubmitButtons(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildUserNameInputs() {
    if (_formType == FormType.register) {
      return <Widget>[
        TextInputField(
          icon: FontAwesomeIcons.user,
          hint: 'First Name',
          validator: FirstNameValidator.validate,
          onSaved: (String value) => _firstName = value,
          formKey: Key('firstName'),
        ),
        TextInputField(
          icon: FontAwesomeIcons.user,
          hint: 'Last Name',
          validator: LastNameValidator.validate,
          onSaved: (String value) => _lastName = value,
          formKey: Key('lastName'),
        ),
      ];
    }
    return <Widget>[];
  }

  List<Widget> buildInputs() {
    return buildUserNameInputs() +
        <Widget>[
          TextInputField(
            icon: FontAwesomeIcons.envelope,
            hint: 'Email',
            inputType: TextInputType.emailAddress,
            inputAction: TextInputAction.next,
            validator: EmailFieldValidator.validate,
            onSaved: (String value) => _email = value,
            formKey: Key('Email'),
          ),
          PasswordInput(
            icon: FontAwesomeIcons.lock,
            hint: 'Password',
            inputAction: TextInputAction.done,
            validator: PasswordFieldValidator.validate,
            onSaved: (String value) => _password = value,
            formKey: Key('Password'),
          ),
          SizedBox(
            height: 25,
          ),
        ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return <Widget>[
        RoundedButton(
          buttonName: 'Login',
          onPressed: () => validateAndSubmit(),
        ),
        SizedBox(
          height: 25,
        ),
        GestureDetector(
          onTap: () => moveToRegister(),
          child: Container(
            child: Text(
              'Create New Account',
              style: kBodyText,
            ),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: kWhite))),
          ),
        ),
        SizedBox(height: 25),
      ];
    } else {
      return <Widget>[
        RoundedButton(
          buttonName: 'Create Account',
          onPressed: () => validateAndSubmit(),
        ),
        SizedBox(
          height: 25,
        ),
        GestureDetector(
          onTap: () => moveToLogin(),
          child: Container(
            child: Text(
              'Already have an account? Login',
              style: kBodyText,
            ),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: kWhite))),
          ),
        ),
        SizedBox(height: 50),
      ];
    }
  }
}
