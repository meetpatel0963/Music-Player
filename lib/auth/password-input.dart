import 'package:flutter/material.dart';

const TextStyle kBodyText =
    TextStyle(fontSize: 22, color: Colors.white, height: 1.5);

const Color kWhite = Colors.white;
const Color kBlue = Color(0xff5663ff);

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key key,
    @required this.icon,
    @required this.hint,
    this.inputType,
    this.inputAction,
    this.validator,
    this.onSaved,
    this.formKey,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Function validator;
  final Function onSaved;
  final formKey;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.8,
      child: Center(
        child: TextFormField(
          key: formKey,
          decoration: InputDecoration(
            contentPadding:
                new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            filled: true,
            fillColor: Colors.grey[500].withOpacity(0.5),
            border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(16.0),
              ),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                icon,
                size: 28,
                color: kWhite,
              ),
            ),
            hintText: hint,
            hintStyle: kBodyText,
            errorStyle: TextStyle(
              fontSize: 16.0,
            ),
          ),
          obscureText: true,
          style: kBodyText,
          keyboardType: inputType,
          textInputAction: inputAction,
          validator: validator,
          onSaved: onSaved,
        ),
      ),
    );
  }
}
