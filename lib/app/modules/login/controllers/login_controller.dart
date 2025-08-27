import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smart_health/app/data/service/snackbar_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/service/SupabaseService.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void loginUser() async {
    if (emailController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty) {
      try {
        isLoading.value = true;
        var response =
            await Supabase.instance.client.auth.signInWithPassword(password: passwordController.text.trim(), email: emailController.text.trim());
        if (response.user != null) {
          await _insertMissingData();
          Get.offAllNamed(Routes.HOME);
        }
        isLoading.value = false;
      } on AuthException catch (error) {
        SnackBarHelper.showSnackBar(title: "Login", message: error.message, isError: true);
        isLoading.value = false;
      }
    } else {
      SnackBarHelper.showSnackBar(title: "Login", message: "Please enter your credentials");
    }
  }

  Future<void> _insertMissingData() async{
    await SupabaseService.instance.insertSleepRecords();
  }
}
