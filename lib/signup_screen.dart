import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  SignUpScreen({super.key});

  void signUp(BuildContext context) async {
    final user = ParseUser(emailCtrl.text.trim(), passCtrl.text.trim(), emailCtrl.text.trim());
    final response = await user.signUp();

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signed up! Please login.')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passCtrl, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => signUp(context), child: Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
