import 'package:flutter/material.dart';

import '../color_constant.dart';


class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: AppColor.secondary,
      ),
    );
  }
}
