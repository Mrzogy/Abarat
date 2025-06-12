// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;

  const SignInButton({super.key, required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap, // ✅ يمنع الضغط إذا فيه تحميل
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey : Color(0xFF0033A0), // ✅ لون رمادي أثناء التحميل
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(
                  "Sign in",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
