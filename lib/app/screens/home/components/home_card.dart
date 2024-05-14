import 'package:assistant_app/app/api/api.dart';
import 'package:assistant_app/app/api/local_data.dart';
import 'package:assistant_app/app/screens/home/components/home_information_page.dart';
import 'package:assistant_app/app/widgets/appbar/custom_appbar.dart';
import 'package:assistant_app/app/widgets/buttons/custom_button.dart';
import 'package:assistant_app/const/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeCard extends StatelessWidget {
  final data;
  final bool? isUser;
  const HomeCard({super.key, required this.data, this.isUser = false});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = data['date'].toDate();
    String formattedDate = DateFormat('dd MMMM HH:mm').format(dateTime);
    return Center(
        child: Container(
      width: MediaQuery.of(context).size.width / 1.1,
      // height: MediaQuery.of(context).size.height / 3.7,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Column(
            children: [
              ClipOval(
                child: SizedBox.fromSize(
                  size: Size.fromRadius(28), // Image radius
                  child: Image.network(
                      (data['image'] != '')
                          ? data['image'] ??
                              'https://artscimedia.case.edu/wp-content/uploads/sites/79/2016/12/14205134/no-user-image.gif'
                          : 'https://artscimedia.case.edu/wp-content/uploads/sites/79/2016/12/14205134/no-user-image.gif',
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                data['name'],
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    data['title'],
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                formattedDate,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: Text(
                        '🗣: ' + data['description'],
                        maxLines: 2,
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Phone 📞 : ' + data['phone']),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Location 📍 : ' + data['address']),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: CustomButton(
                    text: 'Information',
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeInformationPage(
                                  data: data,
                                )),
                      );
                    },
                  )),
              SizedBox(
                height: 10,
              ),
              (isUser == true)
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: CustomButton(
                        text: 'Inactive',
                        function: () async {
                          data['isEnable'] = 'false';
                          print(data);
                          await ApiClient()
                              .updateData('posts', data['postsId'], data);
                        },
                      ))
                  : SizedBox()
            ],
          ),
        ],
      ),
    ));
  }
}
