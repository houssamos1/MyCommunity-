import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycommunity/components/my_button.dart';
import 'package:mycommunity/components/my_textfield.dart';
import 'package:mycommunity/helper/helper_funcyions.dart';

class LoginPage extends StatefulWidget {

  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
TextEditingController emailController = TextEditingController();

TextEditingController passwordController = TextEditingController();

//login function
void login() async {
  //show loading dialog
  showDialog(context: context,
      builder:(context)=> const Center(
        child: CircularProgressIndicator(),
      ),
  );
  //try sign in
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
    );
    //if successful, navigate to home page
    if(context.mounted) Navigator.pop(context);
  }
  //display error message
  on FirebaseAuthException catch (e) {
    Navigator.pop(context);
    displayMessageToUser(e.code, context);
  }
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  Icon(
                    Icons.person,
                    size: 80,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'CommunitySpace',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Email
                  MyTextField(
                    hintText: "Email",
                    obscureText: false,
                    controller: emailController,
                  ),
                  const SizedBox(height: 10),
                  // Password
                  MyTextField(
                    hintText: "Password",
                    obscureText: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 25),
                  // Forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  MyButton(text: "Login", onTap: () {}),

                  const SizedBox(height: 25),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),

                        ),
                    GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                            'Sign Up Here',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ),

                  ],



              ),
                ]
                ),
        ),
      ),
    ),
    );
  }
}
