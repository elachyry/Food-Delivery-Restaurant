import 'package:fde_restaurant_panel/config/size_config.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.4,
      child: Column(
        children: [
          Image.asset(
            'assets/delevry-outline.gif',
            width: 200,
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical,
          ),
          Image.asset(
            'assets/logo.png',
            width: 200,
          ),
        ],
      ),
    );
  }
}
