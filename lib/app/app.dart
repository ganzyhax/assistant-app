import 'package:assistant_app/app/screens/create/bloc/create_bloc.dart';
import 'package:assistant_app/app/screens/navigator/bloc/main_navigator_bloc.dart';
import 'package:assistant_app/app/screens/splash/splash_screen.dart';
import 'package:assistant_app/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistantApp extends StatelessWidget {
  const AssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainNavigatorBloc()..add(MainNavigatorLoad()),
        ),
        BlocProvider(
          create: (context) => CreateBloc()..add(CreateLoad()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Assistant App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
          primaryColor: AppColors.primaryColor,
          dividerColor: AppColors.primaryColor,
        ),
        home: MediaQuery(
          child: SplashScreen(),
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        ),
      ),
    );
  }
}
