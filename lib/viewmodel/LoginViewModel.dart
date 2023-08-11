import 'dart:convert';
import 'package:approval_gratika/constants.dart';
import 'package:approval_gratika/shared_preferences_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class LoginViewModel extends ChangeNotifier {
  String username = '';
  String password = '';
  bool isTetapMasuk = true;
  bool isLoading = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginViewModel() {
    usernameController.text = username;
    passwordController.text = password;
  }



  Future<void> login(Function() navigateToHome) async {
    isLoading = true;
    notifyListeners();

    // Simulate a delay to show loading indicator
    await Future.delayed(const Duration(seconds: 2));

    // Perform login logic here
    const loginUrl = '${Constants.apiURL}/siaga-auth/login';
    final response = await http.post(Uri.parse(loginUrl), body: {
      'nik': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      // Login successful
      final responseData = json.decode(response.body);
      final loginToken = responseData['token'];
      print(responseData); // Log the API response in the console

      // Save the token to SharedPreferences
      await SharedPreferencesUtils.saveLoginToken(loginToken);
      if(isTetapMasuk){
        await SharedPreferencesUtils.saveUsername(username);
        await SharedPreferencesUtils.savePassword(password);
      }
      print(loginToken);

      // You can navigate to the home screen or perform any other necessary actions
      navigateToHome();
    } else {
      // Login failed
      print('Invalid username or password!');
    }

    isLoading = false;
    notifyListeners();
  }
}


