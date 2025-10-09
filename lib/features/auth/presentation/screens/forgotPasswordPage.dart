import 'package:depi_final_project/core/constants/color_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  @override
  final TextEditingController _emailController = TextEditingController();
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formkey = GlobalKey();
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Color(0xff000921),
      appBar: AppBar(backgroundColor: Color(0xff000921), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 51),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                l10n.forgotPassword,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 34,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                l10n.forgotPasswordMessage,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 40),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xffD9D9D9),
                ),
                child: TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterYourEmail;
                    }
                    if (!emailRegex.hasMatch(value)) {
                      return l10n.enterValidEmail;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: l10n.enterYourEmail,
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.email_outlined),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      resetPassword(context);
                      //   if (await isEmailRegistered(controller.text.trim())) {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         content: Text("sucess"),
                      //         duration: Duration(seconds: 3),
                      //       ),
                      //     );
                      //     ResetPassword();
                      //  //   Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePassword()));
                      //   } else {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         content: Text("you not Register"),
                      //         duration: Duration(seconds: 3),
                      //       ),
                      //     );
                      //   }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorApp.splashTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    l10n.sendCode,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    l10n.backToLogin,
                    style: TextStyle(
                      color: ColorApp.splashTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.resetLinkSent),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred";

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No account found with this email address";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address";
          break;
        case 'too-many-requests':
          errorMessage = "Too many requests. Please try again later";
          break;
        default:
          errorMessage = e.message ?? "An error occurred";
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: ColorApp.errorColor,
        gravity: ToastGravity.BOTTOM,
        fontSize: 18,
        textColor: ColorApp.whiteColor,
        timeInSecForIosWeb: 3,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An unexpected error occurred",
        backgroundColor: ColorApp.errorColor,
        gravity: ToastGravity.BOTTOM,
        fontSize: 18,
        textColor: ColorApp.whiteColor,
        timeInSecForIosWeb: 3,
      );
    }
  }
}
