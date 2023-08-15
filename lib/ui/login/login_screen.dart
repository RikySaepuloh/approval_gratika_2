import 'package:approval_gratika/constants.dart';
import 'package:approval_gratika/ui/main/main_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/LoginViewModel.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}





class _LoginScreenState extends State<LoginScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late String FCMToken = "";
  final LoginViewModel viewModel = LoginViewModel();

  bool _obscureText = true;

  Future<void> _authenticateWithBiometrics() async {
    final localAuth = LocalAuthentication();

    try {
      // Check if biometric authentication is available on the device
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (canCheckBiometrics) {
        // Authenticate the user with biometrics
        bool isBiometricAuthenticated = await localAuth.authenticate(
          localizedReason: 'Login menggunakan fingerprint',
          // stickyAuth: true, // Android-specific option to prevent user from manually dismissing the authentication
        );

        if (isBiometricAuthenticated) {
          // Authentication successful, proceed with login
          // print('Authentication successful!');
        } else {
          // Authentication failed
          // print('Authentication failed!');
        }
      } else {
        // Biometric authentication is not available
        Fluttertoast.showToast(
          msg: "Perangkat ini tidak mengusung otentikasi biometrik.",
          toastLength: Toast.LENGTH_SHORT, // Duration for which the toast should be visible
          gravity: ToastGravity.BOTTOM, // Position of the toast message on the screen
          backgroundColor: Colors.grey[700], // Background color of the toast message
          textColor: Colors.white, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message text
        );

        print('Biometric authentication not available on this device.');
      }
    } catch (e) {
      // Handle exceptions that may occur during authentication
      Fluttertoast.showToast(
        msg: "Error during biometric authentication: $e",
        toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
        gravity: ToastGravity.BOTTOM, // Position of the toast message on the screen
        backgroundColor: Colors.grey[700], // Background color of the toast message
        textColor: Colors.white, // Text color of the toast message
        fontSize: 16.0, // Font size of the toast message text
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final viewModel = Provider.of<LoginViewModel>(context);

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return AppColors.primaryColor;
      }
      return AppColors.primaryColor;
    }

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Gratika", style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("Approval System", style: TextStyle(fontSize:14,color: Colors.white, fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.zero,
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20),
                              child: Text("Masuk", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                          Container(
                            margin: EdgeInsets.only(top: 32),
                            child: TextField(style: TextStyle(fontSize: 12),
                              controller: viewModel.usernameController,
                              onChanged: (value) => viewModel.username = value,
                              cursorColor: AppColors.primaryColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: AppColors.primaryColor),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.primaryColor,
                                    width: 1
                                  )
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8))),
                                labelText: 'Username',
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: TextField(style: TextStyle(fontSize: 12),
                              controller: viewModel.passwordController,
                              obscureText: _obscureText,
                              onChanged: (value) => viewModel.password = value,
                              textInputAction: TextInputAction.send,
                              cursorColor: AppColors.primaryColor,
                              decoration: InputDecoration(
                                suffixIconColor: AppColors.primaryColor,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureText ? Icons.visibility_off : Icons.visibility,
                                  ),
                                ),
                                labelStyle: TextStyle(color: AppColors.primaryColor),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 1
                                    )
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8))),
                                labelText: 'Password',
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(fillColor: MaterialStateProperty.resolveWith(getColor),value: viewModel.isTetapMasuk, onChanged: (bool? value){
                                setState(() {
                                  viewModel.isTetapMasuk = value!;
                                });
                              }),
                              Text("Tetap Masuk", style: TextStyle(fontSize: 10),),
                              Spacer(),
                              Text("Lupa Password", style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          // Checkbox(value: value, onChanged: (){})
                          SizedBox(height: 24),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                                onPressed: (){
                                  viewModel.login(FCMToken,() {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
                                    // Navigator.pushReplacementNamed(context, AppRoutes.main);
                                  });
                                },
                                // onPressed: viewModel.isLoading ? null : viewModel.login((){),
                                child: viewModel.isLoading
                                    ? CircularProgressIndicator(color: Colors.white)
                                    : Text('Masuk'),
                              ),
                            ),
                          ),
                          SizedBox(height: 36),
                          Center(child: Text("atau Masuk Menggunakan", style: TextStyle(fontSize: 10),)),
                          SizedBox(height: 24),
                          Center(
                            child: InkWell(
                              onTap: () {
                                _authenticateWithBiometrics();
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.2), // Button background color
                                ),
                                child: IconTheme(
                                  data: IconThemeData(
                                    color: Colors.black, // Icon color
                                    size: 24, // Icon size
                                  ),
                                  child: Icon(Icons.fingerprint), // Fingerprint icon
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Center(child: Text("Versi 1.0.0", style: TextStyle(fontSize: 10),))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
      FCMToken = token!;
      // Send this token to your server
    });
    super.initState();
  }
}
//
//
// Scaffold(
// body: Padding(
// padding: EdgeInsets.all(16),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// TextField(
// onChanged: (value) => viewModel.username = value,
// decoration: InputDecoration(
// labelText: 'Username',
// ),
// ),
// SizedBox(height: 16),
// TextField(
// onChanged: (value) => viewModel.password = value,
// obscureText: true,
// decoration: InputDecoration(
// labelText: 'Password',
// ),
// ),
// SizedBox(height: 24),
// ElevatedButton(
// onPressed: viewModel.isLoading ? null : viewModel.login,
// child: viewModel.isLoading
// ? CircularProgressIndicator()
//     : Text('Login'),
// ),
// ],
// ),
// ),
// )