// ignore_for_file: use_build_context_synchronously

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfa_parkinson/components/my_textfield.dart';
import 'package:pfa_parkinson/components/my_button.dart';
import 'package:pfa_parkinson/components/square_tile.dart';
import 'package:pfa_parkinson/pages/home_page.dart';
import 'package:pfa_parkinson/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // sign user in method

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    // try {
      // await _auth.signInWithEmailAndPassword(
      //   email: _emailController.text,
      //   password: _passwordController.text,
      // );
      // If successful, navigate to the next screen or perform the desired action.
      print("Sign in successful!");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
    // } 
    // on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     // ScaffoldMessenger.of(context).showSnackBar(
    //     //   const SnackBar(
    //     //     content: Text('No user found for that email.'),
    //     //     backgroundColor: Colors.red,
    //     //   ),
    //     // );
    //     print('No user found for that email.');
    //   } else if (e.code == 'wrong-password') {
    //     // ScaffoldMessenger.of(context).showSnackBar(-
    //     //   const SnackBar(
    //     //     content: Text('Wrong password provided for that user.'),
    //     //     backgroundColor: Colors.red,
    //     //   ),
    //     // );
    //     print('Wrong password provided for that user.');
    //   }
    // } catch (e) {
    //   print("Error: $e");
    //   // Handle sign-in errors.
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 74),

          Column(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/logo.png', // Replace with the correct path to your image
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 25),
              // Other widgets in your UI
            ],
          ),
          Text(
            'Bienvenue, tu nous as manqué !',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 25),
          // username textfield
          MyTextField(
            controller: _emailController,
            hintText: 'Email',
            obscureText: false,
          ),

          const SizedBox(height: 10),
          // password textfield
          MyTextField(
            controller: _passwordController,
            hintText: 'Mot de passe',
            obscureText: true,
          ),

          const SizedBox(height: 10),

          // forgot password?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Mot de passe oublié?',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // sign in button
          MyButton(
            text: "Sign In",
            onTap: () => _signInWithEmailAndPassword(context),
          ),
          const SizedBox(height: 25),

          // or continue with
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Ou continuez avec',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // google + apple sign in buttons
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // google button
              SquareTile(imagePath: 'assets/images/google.png'),

              SizedBox(width: 25),

              // apple button
              SquareTile(imagePath: 'assets/images/apple.png')
            ],
          ),
          const SizedBox(height: 25),

          // not a member? register now
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pas un membre?',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(width: 4),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ));
                  },
                  child: const Text(
                    'S\'inscrire maintenant',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          )
        ]),
      ),
    );
  }
}
