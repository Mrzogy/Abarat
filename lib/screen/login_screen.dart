import 'package:abarat_app/component/login_component/signIn_button.dart';
import 'package:abarat_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String? error;

  void login() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final success = await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).login(emailController.text, passwordController.text);

    setState(() {
      isLoading = false;
    });

    if (success) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/products');
    } else {
      setState(() {
        error = 'Invalid email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset('lib/images/nagl.png',width: 200,height: 100,),
              const SizedBox(height: 50),
              Text(
                "Welcome Back",
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                  obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(error!, style: TextStyle(color: Colors.red)),
                ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : SignInButton(onTap: login),
            ],
          ),
        ),
      ),
    );
  }
}

  //  backgroundColor: Colors.grey[300],
  //     // appBar: AppBar(title: Text('Login')),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         children: [
  //           TextField(
  //             controller: emailController,
  //             decoration: InputDecoration(labelText: 'Email'),
  //           ),
  //           TextField(
  //             controller: passwordController,
  //             decoration: InputDecoration(labelText: 'Password'),
  //             obscureText: true,
  //           ),
  //           if (error != null)
  //             Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 8),
  //               child: Text(error!, style: TextStyle(color: Colors.red)),
  //             ),
  //           SizedBox(height: 20),
  //           isLoading
  //               ? CircularProgressIndicator()
  //               : ElevatedButton(
  //                   onPressed: login,
  //                   child: Text('Login'),
  //                 ),
  //         ],
  //       ),
  //     ),