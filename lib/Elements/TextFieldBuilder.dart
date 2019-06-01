import 'package:flutter/material.dart';



class TextFieldBuilder extends StatelessWidget {
  final BuildContext context;
  final Function onChanged;
  final String text;
  final bool isPassword;
  final bool isError;
  final String error;
  final IconData icon;

  const TextFieldBuilder(
      {Key key,
      this.onChanged,
      this.text,
      this.isPassword = false,
      this.isError = false,
      this.error,
      this.icon,@required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        onChanged: onChanged,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          labelText: text,
          labelStyle: TextStyle(
              fontFamily: 'PT Sans',
              color: Theme.of(context).textTheme.body1.color),
              errorText: isError ? error : null,
          prefixIcon: Icon(icon,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}
