import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lisifyy/login_page.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();

  Future<void> signup(context) async {
    final password = passwordController.text.trim();
    final confirmpass = confirmpassController.text.trim();

    if (password != confirmpass) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 4),
          content: Text("Passwords do not match"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 4),
          content: Text("Account created successfully! Please log in."),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Error signing up";
      if (e.code == 'email-already-in-use') {
        errorMessage = "Email already in use";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password is too weak";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 4),
          content: Text(errorMessage),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Create your new\nAccount ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Enter your email and password to sign up",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 40),
                    Text("Email", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(6)),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(7)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Password", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(6)),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(7)),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Confirm Password", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(6)),
                      child: TextFormField(
                        controller: confirmpassController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(7)),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(MediaQuery.of(context).size.width, 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        onPressed: () {
                          signup(context);
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
