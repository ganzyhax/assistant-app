import 'package:assistant_app/app/screens/navigator/bloc/main_navigator_bloc.dart';
import 'package:assistant_app/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppBar extends StatelessWidget {
  final bool? withButtonAdd;
  const CustomAppBar({super.key, this.withButtonAdd = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Image.asset(
          "assets/images/logo.png",
          color: AppColors.primary,
          width: 120,
        ),
        (withButtonAdd == true)
            ? InkWell(
                onTap: () {
                  BlocProvider.of<MainNavigatorBloc>(context)
                    ..add(MainNavigatorChangePage(index: 1));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              )
            : SizedBox()
      ]),
    );
  }
}
