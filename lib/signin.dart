import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_authentication/bloc/customer/customer_bloc.dart';
import 'package:sqflite_authentication/customer_list.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        label: Text("Email"),
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
                        final emailRegExp =
                            RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');

                        if (value!.isEmpty) {
                          return 'Email cannot be empty';
                        } else if (value != "u@g.c") {
                          return 'Invalid email address !';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      label: Text("Password"),
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
                      if (value!.isEmpty) {
                        return 'Password cannot be empty';
                      } else if (value != '123') {
                        return 'Invalid password !';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  BlocBuilder<CustomerBloc, CustomerState>(
                    builder: (context, state) {
                      return SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.pinkAccent),
                              elevation: MaterialStateProperty.resolveWith(
                                  (states) => 0)),
                          onPressed: () async {
                            // if (_formKey.currentState!.validate()) {
                            context
                                .read<CustomerBloc>()
                                .add(AllCustomersEvent());

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CustomerList(),
                              ),
                            );
                            // }
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const Text("Don't have an account ? "),
                  //     TextButton(
                  //       onPressed: () {
                  //         Navigator.of(context).push(
                  //           MaterialPageRoute(
                  //             builder: (context) => const Signup(),
                  //           ),
                  //         );
                  //       },
                  //       child: const Text(
                  //         "Signup",
                  //         style:
                  //             TextStyle(color: Colors.pinkAccent, fontSize: 16),
                  //       ),
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
































// import 'package:flutter/material.dart';
// import 'package:sqflite_authentication/constants.dart';
// import 'package:sqflite_authentication/db_helper.dart';
// import 'package:sqflite_authentication/customer_list.dart';
// import 'package:sqflite_authentication/signup.dart';
// import 'package:uuid/uuid.dart';

// class Signin extends StatefulWidget {
//   const Signin({super.key});

//   @override
//   State<Signin> createState() => _SigninState();
// }

// class _SigninState extends State<Signin> {
//   TextEditingController emailController = TextEditingController(),
//       passwordController = TextEditingController();
//   @override
//   void dispose() {
//     super.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(50),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   "Login",
//                   style: TextStyle(
//                     fontSize: 40,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.pinkAccent,
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//                 TextFormField(
//                   controller: emailController,
//                   decoration: const InputDecoration(
//                     label: Text("Email"),
//                     icon: Icon(
//                       Icons.email_rounded,
//                       color: Colors.pinkAccent,
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(20),
//                       ),
//                     ),
//                   ),
//                   validator: (value) {
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: passwordController,
//                   decoration: const InputDecoration(
//                     label: Text("Password"),
//                     icon: Icon(
//                       Icons.password_rounded,
//                       color: Colors.pinkAccent,
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(20),
//                       ),
//                     ),
//                   ),
//                   validator: (value) {
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 50),
//                 SizedBox(
//                   height: 50,
//                   width: 100,
//                   child: ElevatedButton(
//                     style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.resolveWith(
//                             (states) => Colors.pinkAccent),
//                         elevation:
//                             MaterialStateProperty.resolveWith((states) => 0)),
//                     onPressed: () async {
//                       String email = emailController.text;
//                       String password = passwordController.text;

//                       Map<String, dynamic>? user =
//                           await DBHelper.instance.getUser(email);

//                       if (user != null && user['password'] == password) {
                       
//                         if (context.mounted) {
//                           Constants().showInSnackBar(context,
//                               "Logged in successfully !", Colors.greenAccent);
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) => CustomerList(
//                                 userName: user["name"],
//                               ),
//                             ),
//                           );
//                         }
//                       } else {
//                         if (context.mounted) {
//                           Constants().showInSnackBar(
//                               context,
//                               "Check your email or password !",
//                               Colors.pinkAccent);
//                         }
//                       }
//                     },
//                     child: const Text(
//                       "Login",
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 80),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Don't have an account ? "),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => const Signup(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         "Signup",
//                         style:
//                             TextStyle(color: Colors.pinkAccent, fontSize: 16),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
