import 'package:assistant_app/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomIndicator extends StatelessWidget {
  final bool? isWhite;
  final double? size;
  const CustomIndicator({super.key, this.isWhite, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (size == null) ? 50 : size,
      width: (size == null) ? 50 : size,
      child: LoadingIndicator(
          indicatorType: Indicator.ballScale,
          colors: (isWhite == true)
              ? [AppColors.kPrimaryWhite]
              : [AppColors.kPrimaryGreen],
          strokeWidth: 2,
          backgroundColor: Colors.black.withOpacity(0),
          pathBackgroundColor: Colors.black),
    );
  }
}
