import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:depi_final_project/core/constants/color_app.dart';


class MessageInputField extends StatelessWidget {

  const MessageInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Expanded(
              child: TextField(
                style: textTheme.bodyMedium
                    ?.copyWith(color: ColorApp.whiteColor),
                decoration: InputDecoration(
                  hintText: 'Write your message here...',
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: ColorApp.whiteColor.withOpacity(0.6),
                  ),
                  filled: true,
                  fillColor: inputDecorationTheme.fillColor,


                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),


            Material(
              color: AppColors.teal,
              borderRadius: BorderRadius.circular(30.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(30.0),
                onTap: () {


                },
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.send,
                    color: ColorApp.whiteColor,
                    size: 24.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}