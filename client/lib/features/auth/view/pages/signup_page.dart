import 'package:client/core/theme/app_pallet.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Handles the Loading state
    final isLoading = ref.watch(
      authViewModelProvider.select((val) => val?.isLoading == true),
    );

    //Handles Action states -> listening to the view model class for possible changes in state;
    // It tracks the previous state of the VM and next(current) state of the VM
    ref.listen(authViewModelProvider, (_, current) {
      current?.when(
        data: (data) {
          showSnackBar(context, 'Account created Successfully,  Please login');

          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => LoginPage()),
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
                    const SizedBox(height: 30),
                    CustomTextField(
                      hintText: "Name",
                      controller: nameController,
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
                      buttonText: "Sign Up",
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          await ref
                              .read(authViewModelProvider.notifier)
                              .signUp(
                                name: nameController.text,
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
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.titleMedium,
                          text: 'Already have an account ',
                          children: [
                            TextSpan(
                              text: "sign in ",
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
