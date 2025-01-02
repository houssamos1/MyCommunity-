import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycommunity/components/my_button.dart';
import 'package:mycommunity/components/my_textfield.dart';
import 'package:mycommunity/helper/helper_funcyions.dart';

class RegisterPage extends StatefulWidget {

  final void Function()? onTap;

  const RegisterPage({super.key , required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController UsernameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController ConfirmPwdController = TextEditingController();

 //methode de registeration
  void registerUser() async {
  //Show loading circle
    showDialog(context: context,
        builder: (context) => const Center(
          child:CircularProgressIndicator() ,
        ),
    );

  //make sure password and confirm password are the same
    if (passwordController.text != ConfirmPwdController.text) {
     //pop loading circle
      Navigator.pop(context);
      //show error message to user
      displayMessageToUser("Passwords do not match", context);
    }
    // if it match
    else {
      //try creating user
      try {
        //create user
        UserCredential? userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );

        //creat a user documentt and add to firestore
        createUserDocument(userCredential);
        //pop loading circle
        if (context.mounted) Navigator.pop(context);

      }on FirebaseAuthException catch (e) {
        //pop loading circle
        Navigator.pop(context);
        //show error message to user
        displayMessageToUser(e.code, context);
      }

    }

  }
//create user document and collect them in firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {

      //create user document
      await FirebaseFirestore.instance.collection("users").
      doc(userCredential.user!.email).
      set({
        "email": userCredential.user!.email,
        "username": UsernameController.text,
      });

      //navigate to home page
      Navigator.pushReplacementNamed(context, "/home_page");
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
                  // Username
                  MyTextField(
                    hintText: "Username",
                    obscureText: false,
                    controller: UsernameController,
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  // Confirm Password
                  MyTextField(
                    hintText: "Confirm Password",
                    obscureText: true,
                    controller: ConfirmPwdController,
                  ),

                  // Forgot password

                  const SizedBox(height: 25),
                  // Register button
                  MyButton(text: "Register",
                      onTap: registerUser),

                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'I already have an account',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),

                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login Here',
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
