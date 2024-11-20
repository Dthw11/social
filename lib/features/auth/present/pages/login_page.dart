import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/auth/present/compoments/my_button.dart';
import 'package:social_app/features/auth/present/compoments/my_text_field.dart';
import 'package:social_app/features/auth/present/cubits/auth_cubit.dart';


class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({
    super.key,
    required this.togglePages,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  void login() {
    //prepare email & pw
    final email = emailController.text;
    final pw = pwController.text;

    //auth cubit
    final authCubit = context.read<AuthCubit>();

    //ensure that the email & pw firels are not empty
    if (email.isNotEmpty && pw.isNotEmpty) {
      //login!
      authCubit.login(email, pw);
    }

    //display error if some field are empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter both Email and Password!')));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            children: [
              Icon(
                Icons.lock_open_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                "Welcome back, you've been missed!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              MyTextField(
                controller: emailController,
                hinText: "Email",
                obscureText: false,
              ),

              const SizedBox(
                height: 25,
              ),
              MyTextField(
                controller: pwController,
                hinText: "Password",
                obscureText: true,
              ),
              const SizedBox(
                height: 50,
              ),
              //login button
              MyButton(
                onTap: login,
                text: "Login",
              ),

              const SizedBox(
                height: 25,
              ),
              // not a member? Register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text(
                      " Register now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inverseSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
