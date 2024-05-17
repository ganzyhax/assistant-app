import 'package:assistant_app/app/api/api.dart';
import 'package:assistant_app/app/api/local_data.dart';
import 'package:assistant_app/app/screens/login/login_screen.dart';
import 'package:assistant_app/app/screens/navigator/main_navigator.dart';
import 'package:assistant_app/app/screens/profile/components/profile_posts.dart';
import 'package:assistant_app/app/screens/splash/splash_screen.dart';
import 'package:assistant_app/app/widgets/appbar/custom_appbar.dart';
import 'package:assistant_app/app/widgets/buttons/custom_button.dart';
import 'package:assistant_app/app/widgets/textfields/custom_textfiled.dart';
import 'package:assistant_app/const/app_colors.dart';
import 'package:assistant_app/function/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _getUserDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;
          final username = userData['name'] ?? '';
          var userImage = userData['image'].toString();
          TextEditingController nameController =
              TextEditingController(text: username);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  InkWell(
                    onTap: () async {
                      String image =
                          await GlobalFunctions().uploadImageToImgBB(context);

                      if (image != 'null') {
                        await ApiClient().updateData(
                            'users', userData['usersId'], {'image': image});
                      } else {
                        // Handle the case where the image upload failed
                      }
                    },
                    child: Center(
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(68),
                          child: Image.network(
                            (userImage == '')
                                ? 'https://artscimedia.case.edu/wp-content/uploads/sites/79/2016/12/14205134/no-user-image.gif'
                                : userImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hintText: 'Name',
                    controller: nameController,
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: 'Change',
                    function: () async {
                      await ApiClient().updateData('users', userData['usersId'],
                          {'name': nameController.text});
                      const snackBar = SnackBar(
                        content: Text('User name updated successfully!'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  // My Posts ListTile
                  _buildListTile(
                    Icons.post_add,
                    'My posts',
                    'Active/All',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePostsPage(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Log Out ListTile
                  _buildListTile(
                    Icons.logout,
                    'Log out',
                    '',
                    () async {
                      await SecureStorage().clear();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => SplashScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Stream<DocumentSnapshot> _getUserDataStream() async* {
    String? userId = await SecureStorage().getData('userId');
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    String subtitle,
    void Function() onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        trailing: Icon(Icons.arrow_right, color: Colors.black),
        subtitle: (subtitle != '')
            ? Text(
                subtitle,
                style: TextStyle(color: Colors.black),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
