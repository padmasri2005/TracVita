import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/main.dart';
import 'package:provider/provider.dart';
import './firebaseAUTH/auth.dart'; // Import the Authentication class
import 'styles.dart'; // Import the styles

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!value.endsWith('@gmail.com')) {
      return 'Invalid Email: Must end with @gmail.com';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the Form

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.jpg', // Path to your image asset
              width: 40, // Adjust width as needed
              height: 40, // Adjust height as needed
            ),
            const SizedBox(width: 10), // Add spacing between the logo and text
            const Text(
              'TracVita',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color:
                    Color.fromRGBO(76, 15, 119, 1), // Set text color to whitee
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white, // Set AppBar background color to purple
        elevation: 0, // Remove shadow for a clean look
      ),
      backgroundColor: Colors.grey[200], // Grey background for the page
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey, // Set key for the Form
            autovalidateMode:
                AutovalidateMode.onUserInteraction, // Enable auto validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/log.jpg',
                    height: 300, // Set your desired height here
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'Welcome back!',
                          style: AppStyles.titleStyle,
                        ),
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                        validator: widget.validateEmail,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: widget.validatePassword,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Add navigation logic for forgot password
                          },
                          style: AppStyles.textButtonStyle,
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _signIn();
                          }
                        },
                        icon: Icon(Icons.arrow_forward),
                        label: const Text('Login'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey[200],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Color(0xFF4C0F77),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    // Check if the password is less than 6 characters
    if (password.length < 6) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Password'),
            content: Text('Password should contain at least 6 characters'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Stop further execution
    }

    // Proceed with sign-in if the password is valid
    User? user = await _auth.signInWithEmailAndPassword(email, password);
    if (user != null) {
      print("success");
      // Fetch the username and medication reminder times from Firestore
      String username = await _auth.fetchUsernameFromFirestore(user.uid);
      List<DateTime> medicationTimes =
          await _auth.fetchTimesDataFromFirestore(user.uid);
      // Update the provider with the fetched username and medication reminder times
      Provider.of<UsernameProvider>(context, listen: false)
          .setUsername(username);

      Navigator.pushNamed(context, "/AndriodPrototype");
    } else {
      // Show popup for incorrect credentials
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Incorrect Credentials'),
            content: Text('Incorrect credentials, try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
