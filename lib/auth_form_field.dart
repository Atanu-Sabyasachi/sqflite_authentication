// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthFormField extends StatelessWidget {
  AuthFormField(
      {super.key,
      this.lable,
      required this.title,
      required this.hintText,
      this.suffixIcon,
      this.obscureText,
      this.validator,
      required this.controller,
      this.textInputAction,
      this.readOnly,
      this.onFieldSubmitted,
      this.inputFormatters,
      this.enabled,
      this.onTap,
      required this.keyboardtype});
  String title;
  Widget? lable;
  String hintText;
  Widget? suffixIcon;
  bool? obscureText;
  TextInputAction? textInputAction;
  String? Function(String?)? validator;
  TextEditingController controller;
  Function(String)? onFieldSubmitted;
  bool? readOnly;
  List<TextInputFormatter>? inputFormatters;
  bool? enabled;
  void Function()? onTap;
  TextInputType? keyboardtype;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              // const TextSpan(
              //   text: "*",
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     color: Colors.red,
              //   ),
              // ),
              // const WidgetSpan(
              //   child: SizedBox(width: 5),
              // ),
              TextSpan(
                text: title,
                style: Theme.of(context).textTheme.labelLarge?.merge(
                      const TextStyle(
                        color: Colors.black,
                      ),
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 400,
          child: TextFormField(
            enabled: enabled,
            onTap: onTap,
            readOnly: readOnly ?? false,
            obscureText: obscureText ?? false,
            cursorColor: Colors.black,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            decoration: InputDecoration(
              floatingLabelStyle: const TextStyle(color: Colors.black),
              label: lable,
              suffixIcon: suffixIcon ?? const SizedBox(),
              hintText: hintText,
              errorStyle: const TextStyle(color: Colors.red),
              hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 173, 173, 245),
                  fontWeight: FontWeight.normal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              errorMaxLines: 3,
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: keyboardtype,
            autofocus: false,
            validator: validator,
            controller: controller,
            onSaved: (value) {},
            onFieldSubmitted: onFieldSubmitted,
            textInputAction: textInputAction ?? TextInputAction.next,
            inputFormatters: inputFormatters,
          ),
        ),
      ],
    );
  }
}
