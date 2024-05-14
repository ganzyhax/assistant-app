import 'package:assistant_app/app/widgets/appbar/custom_appbar.dart';
import 'package:assistant_app/app/widgets/map/custom_map.dart';
import 'package:assistant_app/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeInformationPage extends StatelessWidget {
  final data;
  const HomeInformationPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = data['date'].toDate();

    String formattedDate = DateFormat('dd MMMM HH:mm').format(dateTime);
    return Scaffold(
      backgroundColor: AppColors.kPrimaryBackgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60), child: CustomAppBar()),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customDataShower(context, 'Title', data['title']),
                    customDataShower(
                        context, 'Description', data['description']),
                    customDataShower(context, 'Address', data['address']),
                    Divider(),
                    Text(
                      'Information about user',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    customDataShower(context, 'Author', data['name']),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/kaspi.png',
                              width: 35,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Kaspi')
                          ],
                        ),
                        Text(data['phone'])
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Location in map:',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    WebMap(coordinates: data['location'])
                  ],
                ))),
      ),
    );
  }

  customDataShower(context, title, data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 17),
              )),
          SizedBox(
              width: MediaQuery.of(context).size.width / 3.2,
              child: Text(data,
                  style: TextStyle(color: Colors.black, fontSize: 17))),
        ],
      ),
    );
  }
}
