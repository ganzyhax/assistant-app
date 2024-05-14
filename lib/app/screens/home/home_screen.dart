import 'dart:async';

import 'package:assistant_app/app/api/api.dart';
import 'package:assistant_app/app/screens/home/components/home_card.dart';
import 'package:assistant_app/app/screens/home/components/home_information_page.dart';
import 'package:assistant_app/app/widgets/appbar/custom_appbar.dart';
import 'package:assistant_app/app/widgets/buttons/custom_button.dart';
import 'package:assistant_app/app/widgets/custom_indicator.dart';
import 'package:assistant_app/const/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          withButtonAdd: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tabIndex = 0;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 5,
                    padding: EdgeInsets.only(
                      bottom: 5, // Space between underline and text
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: AppColors.primary,
                      width: (tabIndex == 0) ? 2.0 : 0.0, // Underline thickness
                    ))),
                    child: Center(
                      child: Text(
                        "Help",
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tabIndex = 1;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 5,
                    padding: EdgeInsets.only(
                      bottom: 5, // Space between underline and text
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: AppColors.primary,
                      width: (tabIndex == 1) ? 2.0 : 0.0, // Underline thickness
                    ))),
                    child: Center(
                      child: Text(
                        "Assist",
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('type', isEqualTo: tabIndex.toString())
                  .where('isEnable', isEqualTo: 'true')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((document) {
                      // Access data fields of the document using document.data()
                      Map<String, dynamic> postData =
                          document.data() as Map<String, dynamic>;

                      // Get the userID from the document data
                      String userID = postData['author'];

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(userID)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CustomIndicator(),
                            );
                          }

                          if (userSnapshot.hasError) {
                            return Text(
                                'Error fetching user data: ${userSnapshot.error}');
                          }

                          if (userSnapshot.hasData &&
                              userSnapshot.data!.exists) {
                            // Access user data
                            Map<String, dynamic> userData = userSnapshot.data!
                                .data() as Map<String, dynamic>;

                            // Merge user data with post data
                            Map<String, dynamic> mergedData = {
                              ...postData,
                              ...userData
                            };

                            // Assuming HomeCard widget takes a Map<String, dynamic> as its data property
                            return HomeCard(data: mergedData);
                          } else {
                            return Text(
                                'User data not found for userID: $userID');
                          }
                        },
                      );
                    }).toList(),
                  );
                } else {
                  return Center(
                    child: Text(
                      'Empty!',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
