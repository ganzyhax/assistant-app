import 'package:assistant_app/app/api/local_data.dart';
import 'package:assistant_app/app/screens/home/components/home_card.dart';
import 'package:assistant_app/app/widgets/custom_indicator.dart';
import 'package:assistant_app/const/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePostsPage extends StatefulWidget {
  const ProfilePostsPage({Key? key}) : super(key: key);

  @override
  State<ProfilePostsPage> createState() => _ProfilePostsPageState();
}

class _ProfilePostsPageState extends State<ProfilePostsPage> {
  late Future<String?> userIdFuture;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    userIdFuture = SecureStorage().getData('userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Posts'),
      ),
      body: FutureBuilder<String?>(
        future: userIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final userId = snapshot.data ?? '';

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
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
                          width: (tabIndex == 0)
                              ? 2.0
                              : 0.0, // Underline thickness
                        ))),
                        child: Center(
                          child: Text(
                            "Active",
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
                          width: (tabIndex == 1)
                              ? 2.0
                              : 0.0, // Underline thickness
                        ))),
                        child: Center(
                          child: Text(
                            "All",
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
                // Your tab widgets
                StreamBuilder(
                  stream: (tabIndex == 0)
                      ? FirebaseFirestore.instance
                          .collection('posts')
                          .where('author', isEqualTo: userId)
                          .where('isEnable', isEqualTo: 'true')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('posts')
                          .where('author', isEqualTo: userId)
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
                                Map<String, dynamic> userData =
                                    userSnapshot.data!.data()
                                        as Map<String, dynamic>;

                                // Merge user data with post data
                                Map<String, dynamic> mergedData = {
                                  ...postData,
                                  ...userData
                                };

                                // Assuming HomeCard widget takes a Map<String, dynamic> as its data property
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: HomeCard(
                                    data: mergedData,
                                    isUser: (tabIndex == 0) ? true : false,
                                  ),
                                );
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
          );
        },
      ),
    );
  }
}
