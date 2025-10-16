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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding:  EdgeInsets.symmetric(vertical:screenHeight * 0.001 ),
      child: SizedBox(
        height: screenHeight * 0.09,
        width: double.infinity,
        child: TextFormField(
          scrollPadding: EdgeInsets.all(screenWidth * 0.04),
          validator:widget.validator ,
          controller: widget.controller,
          onChanged: widget.onChanged,
          obscureText: widget.isPassword ? _obscureText : false,
          style: const TextStyle(color: ColorApp.greyColor),
          decoration: InputDecoration(

            helperText: ' ',
            helperStyle: const TextStyle(height: 0.7),
            errorStyle: const TextStyle(height: 0.7, color: Colors.redAccent),


            filled: true,
            fillColor: ColorApp.textFieldBackgroundColor,
            hintText: widget.hintText,
            hintStyle:  TextStyle(
              color: ColorApp.greyColor,
              fontWeight: FontWeight.w400,
              fontSize: screenWidth * 0.035,
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
                      size: screenWidth * 0.055,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.05),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.05),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.05),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
