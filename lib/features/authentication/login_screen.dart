import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gate_access/config/app_colors.dart';
import 'package:gate_access/services/authentication_service.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'loginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _employeeCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RoundedLoadingButtonController _loginController = RoundedLoadingButtonController();

  final AuthService authService = AuthService();

  void _login() async {
    String email = _employeeCodeController.text;
    String password = _passwordController.text;

    User? user = await authService.signInWithEmailAndPassword(email, password);

    if (user != null) {
      _loginController.success();
      Navigator.pushReplacementNamed(context, 'scanMenuScreen');
      if (kDebugMode) {
        print('User authenticated: ${user.uid}');
      }
    } else {
      _loginController.error();
      if (kDebugMode) {
        print('Failed to authenticate user');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Image.asset(
                'assets/images/app-logo.png',
                width: MediaQuery.of(context).size.width * 0.50,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Welcome Back',
                style: TextStyle(
                    color: AppColors.fontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                style: const TextStyle(color: AppColors.fontColor),
                autofocus: false,
                controller: _employeeCodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Employee Code",
                  prefixIcon: Icon(Icons.person, color: AppColors.fontColor),
                  contentPadding: EdgeInsets.all(10),
                ),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              TextFormField(
                style: const TextStyle(color: AppColors.fontColor),
                autofocus: false,
                controller: _passwordController,
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock, color: AppColors.fontColor),
                  contentPadding: EdgeInsets.all(10),
                ),

              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              RoundedLoadingButton(
                  elevation: 0,
                  borderRadius: 15,
                  controller: _loginController,
                  successColor: AppColors.fontColor,
                  onPressed: () async {
                    _login();
                  },
                  color: AppColors.mainColor,
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white),
                  )),
              const SizedBox(
                height: 15,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
