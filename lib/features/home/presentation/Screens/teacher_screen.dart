import 'package:flutter/material.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';

class TeacherScreen extends StatelessWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      color: Colors.blueGrey,
      child:  Center(
        child: Text(
          l10n.teacherScreen,
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
