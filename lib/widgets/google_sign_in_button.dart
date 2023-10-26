import 'package:flutter/material.dart';
import 'package:we_go/theme/appTheme.dart';

class GoogleSigninButton extends StatelessWidget {
  final void Function()? onPressed;
  const GoogleSigninButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(241, 241, 241, 1),
                ),
              ),
              onPressed: onPressed,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continue with Google",
                        style: AppTheme.normalTextStyle
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Positioned(
                    child: Image.asset(
                      'lib/assets/Google.png',
                      width: 22,
                      height: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
