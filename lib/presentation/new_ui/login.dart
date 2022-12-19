import 'package:flutter/material.dart';

class LoginNewDesign extends StatefulWidget {
  const LoginNewDesign({Key? key}) : super(key: key);

  @override
  State<LoginNewDesign> createState() => _LoginNewDesignState();
}

class _LoginNewDesignState extends State<LoginNewDesign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_background.jpg'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
