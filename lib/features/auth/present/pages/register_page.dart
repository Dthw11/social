import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/auth/present/compoments/my_button.dart';
import 'package:social_app/features/auth/present/compoments/my_text_field.dart';
import 'package:social_app/features/auth/present/cubits/auth_cubit.dart';


class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({
    super.key,
    required this.togglePages,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPwController = TextEditingController();

  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String pw = pwController.text;
    final String confirmPw = confirmPwController.text;

    //authcubit
    final authCubit = context.read<AuthCubit>();
    if (email.isNotEmpty &&
        name.isNotEmpty &&
        pw.isNotEmpty &&
        confirmPw.isNotEmpty) {
      //ensure passwords match
      if (pw == confirmPw) {
        authCubit.register(name, email, pw);
      }

      // passwords don't match
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords do not macth!")));
      }
    }

    // fields are empty -> display error
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please complete all fiels")));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    pwController.dispose();
    confirmPwController.dispose();
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
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(
                height: 50,
              ),
              //create account message
              Text(
                "Let's create account !",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              MyTextField(
                controller: nameController,
                hinText: "Name",
                obscureText: false,
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
                height: 25,
              ),
              MyTextField(
                controller: confirmPwController,
                hinText: "Confirm Password",
                obscureText: true,
              ),
              const SizedBox(
                height: 25,
              ),
              //Register button
              MyButton(
                onTap: register,
                text: "Register",
              ),
              const SizedBox(
                height: 25,
              ),
              // already a member? login now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already member?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text(
                      " Login now",
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
