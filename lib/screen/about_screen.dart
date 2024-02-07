import 'package:flutter/material.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/utils/utils.dart';
import 'package:we_go/widgets/template.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Template(
        title: "About WeGo",
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: [
            RichText(
              text: TextSpan(
                text: "Welcome to WeGo",
                style: AppTheme.normalTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: Utils.aboutUs,
                    style: AppTheme.normalTextStyle.copyWith(height: 2),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
