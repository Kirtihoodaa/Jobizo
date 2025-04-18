import 'package:flutter/material.dart';
import '../../Design contraints/app color.dart';
import '../../Design contraints/FontSizes.dart';
import '../../app_bar.dart';
import '../NavBar.dart';
import '../Profle pages/MyProfile.dart';
import 'ChangePassword.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _biometric = false;
  bool _pushNotif = true;
  bool _emailNotif = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        name: 'Deepak',
        location: 'Chandigarh',
        profileImageUrl: '',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.gold,
                    backgroundImage: NetworkImage(
                        'https://i.imgur.com/BoN9kdC.png'), // replace with real image
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Priya Kumar',
                          style: TextStyle(
                            fontSize: secondary(),
                            fontWeight: FontWeight.w600,
                            color: Colors.green[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'priya@email.com',
                          style: TextStyle(
                            fontSize: tertiary(),
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 0,
                    ),
                    onPressed: () {

                    },
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: tertiary(),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Account
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Account',
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Personal Information',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=> MyProfilePage()));
              },
            ),Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Language',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'English',
                    style: TextStyle(fontSize: tertiary(), color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right),
                ],
              ),

              onTap: () {

              },
            ),
             Divider(height: 8, thickness: 15, color: Colors.grey[200]),

            // Security
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Security',
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Change Password',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=>Changepassword()));

              },
            ),
            Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Biometric Login',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              trailing: Switch(
                value: _biometric,
                activeColor: AppColors.gold,
                inactiveThumbColor: Colors.white,
                onChanged: (v) => setState(() => _biometric = v),
              ),
            ),
            Divider(height: 8, thickness: 15, color: Colors.grey[200]),

            // Notifications
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: secondary(),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Push Notifications',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),

              trailing: Switch(
                value: _pushNotif,
                activeColor: AppColors.gold,
                inactiveThumbColor: Colors.white,
                onChanged: (v) => setState(() => _pushNotif = v),
              ),
            ),
            Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Email Notifications',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              trailing: Switch(
                value: _emailNotif,
                activeColor: AppColors.gold,
                inactiveThumbColor: Colors.white,
                onChanged: (v) => setState(() => _emailNotif = v),
              ),
            ),
            Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                'Sound & Vibration',
                style: TextStyle(fontSize: tertiary(), color: Colors.black),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_right),
                ],
              ),

              onTap: () {
              },
            ),
            Divider(height: 8, thickness: 15, color: Colors.grey[200]),
            SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          minimumSize: Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                        ),
                        onPressed: (){},
                        child: Text("Logout",style: TextStyle(
                          fontSize: secondary(),
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                    ),
                    SizedBox(height: 20),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.gold,width: 1),
                            minimumSize: Size.fromHeight(45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ),
                        onPressed: (){},
                        child: Text("Delete Account",style: TextStyle(
                            fontSize: secondary(),
                            color:  AppColors.gold,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
      bottomNavigationBar: NavBarLabour(currentIndex: 3),
    );
  }
}
