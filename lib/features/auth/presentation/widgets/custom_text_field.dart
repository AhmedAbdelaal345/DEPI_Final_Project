import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
 final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.onChanged,
    this.errorText,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: TextFormField(
        scrollPadding: EdgeInsets.all(15),
        validator:widget.validator ,
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: widget.isPassword ? _obscureText : false,
        style: const TextStyle(color: ColorApp.greyColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorApp.textFieldBackgroundColor,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: ColorApp.greyColor,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          errorText: widget.errorText,
          prefixIcon: Icon(widget.prefixIcon, color: ColorApp.greyColor),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: ColorApp.greyColor,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
