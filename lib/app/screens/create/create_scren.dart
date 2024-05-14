import 'package:assistant_app/app/api/api.dart';
import 'package:assistant_app/app/api/local_data.dart';
import 'package:assistant_app/app/screens/create/bloc/create_bloc.dart';
import 'package:assistant_app/app/widgets/appbar/custom_appbar.dart';
import 'package:assistant_app/app/widgets/buttons/custom_button.dart';
import 'package:assistant_app/app/widgets/custom_indicator.dart';
import 'package:assistant_app/app/widgets/map/map_dialog.dart';
import 'package:assistant_app/app/widgets/textfields/custom_textfiled.dart';
import 'package:assistant_app/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();

  int selectedType = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.kPrimaryBackgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<CreateBloc, CreateState>(
            builder: (context, state) {
              if (state is CreateLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(children: [
                    Center(
                        child: Text(
                      'Post',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    )),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                      title: Text(
                        'I need help',
                        style: TextStyle(fontSize: 18),
                      ),
                      leading: Radio<int>(
                        value: 0,
                        groupValue: selectedType,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          setState(() {
                            selectedType = 0;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'I want to help',
                        style: TextStyle(fontSize: 18),
                      ),
                      leading: Radio<int>(
                        value: 1,
                        activeColor: AppColors.primary,
                        groupValue: selectedType,
                        onChanged: (value) {
                          setState(() {
                            selectedType = 1;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextField(hintText: 'Title', controller: title),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        hintText: 'Description', controller: description),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextField(hintText: 'Address', controller: address),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        hintText: 'Phone for contact', controller: phone),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primary,
                          size: 30,
                        ),
                        TextButton(
                            onPressed: () async {
                              await WebMapPicker()
                                  .showModalBottomSheetMap(context);
                            },
                            child: Text('Select location'))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    (state.location.length != 0)
                        ? Row(
                            children: [
                              Text('Location coordinate : '),
                              Text(state.location[0].toStringAsFixed(4)),
                              SizedBox(
                                width: 10,
                              ),
                              Text(state.location[1].toStringAsFixed(4))
                            ],
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      text: 'Post',
                      function: () async {
                        String userId =
                            await SecureStorage().getData('userId') ?? '';
                        if (userId != '') {
                          ApiClient().createData('posts', {
                            'title': title.text,
                            'description': description.text,
                            'author': userId,
                            'phone': phone.text,
                            'date': DateTime.now(),
                            'location': state.location,
                            'type': selectedType.toString(),
                            'isEnable': 'true',
                            'address': address.text
                          });
                          const snackBar = SnackBar(
                            content: Text('Created successfully!'),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          title.text = '';
                          description.text = '';
                          address.text = '';
                          phone.text = '';
                        }
                      },
                    )
                  ]),
                );
              }
              return Center(
                child: CustomIndicator(),
              );
            },
          ),
        ));
  }
}
