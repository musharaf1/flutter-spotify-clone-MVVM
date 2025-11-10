import 'package:client/core/theme/app_pallet.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authViewModelProvider.select((val) => val?.isLoading == true),
    );
    ref.listen(authViewModelProvider, (_, current) {
      current?.when(
        data: (data) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => HomePage()),
            (_) => false,
          );
        },
        error: (error, stacktrace) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Loader()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign Up. ",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: "email",
                      controller: emailController,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: "Password",
                      controller: passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),
                    AuthGradientButton(
                      buttonText: "Sign In",
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          await ref
                              .read(authViewModelProvider.notifier)
                              .login(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 15),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => SignupPage()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.titleMedium,
                          text: "Don't have an account ",
                          children: [
                            TextSpan(
                              text: "sign Up ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppPallet.gradient2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
