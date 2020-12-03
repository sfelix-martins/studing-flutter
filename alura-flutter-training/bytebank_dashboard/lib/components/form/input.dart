import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final String hintText;
  final Function validator;
  final TextCapitalization textCapitalization;

  const InputText({
    Key key,
    this.controller,
    this.keyboardType,
    this.labelText,
    this.hintText,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        textCapitalization: textCapitalization,
        controller: controller,
        style: TextStyle(fontSize: 24.0),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
        ),
        validator: validator,
      ),
    );
  }
}
