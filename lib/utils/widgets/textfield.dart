import 'package:flutter/material.dart';

class Mytextform extends StatelessWidget {
  const Mytextform(
      {Key? key,
      required this.controller,
      required this.iconData,
      required this.hint,
      this.obscure,
      required this.label})
      : super(key: key);

  final TextEditingController controller;
  final Widget iconData;
  final String label;
  final bool? obscure;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure ?? false,
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: iconData,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isObscure;
  final IconData icon;
  const MyTextField(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.isObscure,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.amber,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.amber,
            ),
          )),
    );
  }
}
