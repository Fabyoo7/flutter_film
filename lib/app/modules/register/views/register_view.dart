import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    RegisterController controller = Get.put(RegisterController());
    return Scaffold(
      backgroundColor: HexColor('#121212'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'logo111.png', // Ganti dengan path logo kamu
                height: 80,
              ),
              const SizedBox(height: 30),

              // Title
              Text(
                'Create Your Movie Account',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 40),

              // Full Name Field
              _buildTextField(
                controller: controller.nameController,
                hint: 'Full Name',
              ),
              const SizedBox(height: 20),

              // Email Field
              _buildTextField(
                controller: controller.emailController,
                hint: 'Email',
              ),
              const SizedBox(height: 20),

              // Password Field
              _buildTextField(
                controller: controller.passwordController,
                hint: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 20),

              // Confirm Password Field
              _buildTextField(
                controller: controller.passwordConfirmationController,
                hint: 'Confirm Password',
                isPassword: true,
              ),
              const SizedBox(height: 40),

              // Register Button
              ElevatedButton(
                onPressed: () {
                  controller.registerNow();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  side: BorderSide(color: HexColor('#FFA726')),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'REGISTER NOW',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Already have account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: Colors.white54),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/login'); // Ganti sesuai rute login kamu
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: HexColor('#FFA726'),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor('#FFA726')),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor('#FFA726')),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
