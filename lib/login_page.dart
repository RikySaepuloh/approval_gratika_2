import 'package:approval_gratika/constants.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Container(
            color: Color.fromRGBO(176, 0, 0, 1),
            child: Column(
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Gratika",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Text(
                        "Approval System",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 8,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Card(
                      elevation: 10,
                      margin: EdgeInsets.zero,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(30, 40, 30, 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Masuk",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 30),
                                child: TextFormField(
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    labelText: "Username",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                  ),
                                )
                                // TextField(
                                //   controller: controller,
                                //   decoration: InputDecoration(
                                //       hintText: "Username",
                                //       hintStyle: ,
                                //       border: OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(10),
                                //       )),
                                // ),
                                ),
                            Container(
                                margin: EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: "Password",
                                    suffixIcon: Icon(Icons.visibility),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                  ),
                                )),
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(value: true, onChanged: null),
                                      Text(
                                        "Tetap Masuk",
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "Lupa password",
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
    ;
  }
}
