import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SnackBarHelper {
  static void showSnackBar({required String title, required String message, bool isError = false,Function(SnackbarStatus?)? onStatusChange}) {
    Get.showSnackbar(GetSnackBar(
      borderRadius: 20,
      duration: Duration(seconds: 1),
      isDismissible: true,
      animationDuration: Duration(seconds: 1),
      margin: EdgeInsets.symmetric(horizontal: 16),
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Icon(
          isError ? Icons.error_rounded : Icons.verified,
          size: 40,
          color: isError ? Colors.red : Colors.green,
        ),
      ),
      snackbarStatus: onStatusChange,
      titleText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          title,
          style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w900,color: Colors.white),
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          message,
          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.white),
        ),
      ),
    ));
  }
}
