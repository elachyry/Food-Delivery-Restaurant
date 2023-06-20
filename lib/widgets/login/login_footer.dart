import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'or_continue_with'.tr,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // GestureDetector(
              //   onTap: () {
              //     AuthController.instance.signUpWithGoogle();
              //   },
              //   child: const SquareTile(
              //     imagePath: ImageConstants.google,
              //   ),
              // ),
              // const SizedBox(width: 25),
              // GestureDetector(
              //   onTap: () {},
              //   child: const SquareTile(
              //     imagePath: ImageConstants.facebook,
              //   ),
              // ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       'not_a_member'.tr,
        //       style: TextStyle(color: Colors.grey[700]),
        //     ),
        //     const SizedBox(width: 4),
        //     InkWell(
        //       onTap: () {
        //         Get.offNamed(AppRoutes.signupScreenRoute);
        //       },
        //       child: Text(
        //         'register_now'.tr,
        //         style: TextStyle(
        //           color: Theme.of(context).primaryColor,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
