import 'package:approval_gratika/constants.dart';
import 'package:approval_gratika/model/profile.dart';
import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../repository/repository.dart';
import '../../shared_preferences_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Repository repository = Repository();
  UserModel? _userData;
  //
  @override
  void initState() {
    fetchData();
    super.initState();
  }
  // //
  void fetchData() async {
    try {
      final userData = await repository.getProfile();
      setState(() {
        _userData = userData;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 12,
            ),
            Center(
                child: Text(
              "Profil",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )),
            SizedBox(height: 40,),
            Container(width: 76, height: 76, child: CircleAvatar(
              backgroundImage: NetworkImage(_userData?.user[0].foto ?? ""),
              backgroundColor: Colors.transparent,
            )),
            SizedBox(height: 14,),
            Text(_userData?.user[0].nama ?? "", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
            SizedBox(height: 12,),
            Text(_userData?.user[0].jabatan ?? "", style: TextStyle(fontSize: 10),),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.fromLTRB(16, 6, 16, 6),
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 25.75,),
                  Text("Data Pribadi")
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 6, 16, 6),
              child: Row(
                children: [
                  Icon(Icons.key),
                  SizedBox(width: 25.75,),
                  Text("Username dan Password")
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 6, 16, 6),
              child: Row(
                children: [
                  Icon(Icons.fingerprint),
                  SizedBox(width: 25.75,),
                  Text("Masuk dengan Sidik Jari")
                ],
              ),
            ),
            SizedBox(height: 30,),
            GestureDetector(onTap: () async {
              await SharedPreferencesUtils.clearLoginToken();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },child: Text("Keluar", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),))

          ],
        ),
      ),
    );
  }
}
