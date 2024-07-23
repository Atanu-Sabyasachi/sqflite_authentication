import 'package:flutter/material.dart';
import 'package:sqflite_authentication/constants.dart';
import 'package:sqflite_authentication/db_helper.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Signup",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: Colors.pinkAccent,
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Colors.pinkAccent,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.email_rounded,
                      color: Colors.pinkAccent,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.password_rounded,
                      color: Colors.pinkAccent,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.pinkAccent),
                        elevation:
                            MaterialStateProperty.resolveWith((states) => 0)),
                    onPressed: () async {
                      Map<String, dynamic> user = {
                        'name': nameController.text,
                        'email': emailController.text,
                        'password': passwordController.text,
                      };

                      await DBHelper.instance.setUser(user);

                      if (context.mounted) {
                        Navigator.pop(context);
                        Constants().showInSnackBar(
                            context, "Signup successful !", Colors.greenAccent);
                      }
                    },
                    child: const Text(
                      "Signup",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
