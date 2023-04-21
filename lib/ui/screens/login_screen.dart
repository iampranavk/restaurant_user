import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_user/blocs/auth/sign_in/sign_in_bloc.dart';
import 'package:restaurant_user/ui/screens/home_screen.dart';
import 'package:restaurant_user/ui/screens/register_screen.dart';
import 'package:restaurant_user/ui/widget/custom_alert_dialog.dart';
import 'package:restaurant_user/ui/widget/custom_button.dart';
import 'package:restaurant_user/ui/widget/custom_input_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (Supabase.instance.client.auth.currentUser != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => true,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => SignInBloc(),
          child: BlocConsumer<SignInBloc, SignInState>(
            listener: (context, state) {
              if (state is SignInFailureState) {
                showDialog(
                  context: context,
                  builder: (context) => const CustomAlertDialog(
                    title: "Login Failed",
                    message:
                        'Please check your email and password and try again.',
                    primaryButtonLabel: 'Ok',
                  ),
                );
              } else if (state is SignInSuccessState) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1424847651672-bf20a4b0982b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Text(
                                'Restaurant',
                                style: GoogleFonts.oswald(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Colors.green[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Enter email and password to login',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              const Divider(
                                color: Colors.green,
                                height: 40,
                                thickness: 0.5,
                              ),
                              // Text(
                              //   'Login',
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .headlineSmall!
                              //       .copyWith(
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              // ),
                              // const SizedBox(
                              //   height: 5,
                              // ),

                              CustomInputFormField(
                                controller: _emailController,
                                prefixIcon: Icons.email,
                                labelText: 'Email',
                                validator: (value) {
                                  if (value != null &&
                                      value.trim().isNotEmpty) {
                                    return null;
                                  } else {
                                    return "Please enter an email";
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomInputFormField(
                                controller: _passwordController,
                                isObscure: isObscure,
                                labelText: 'Password',
                                prefixIcon: Icons.lock,
                                validator: (value) {
                                  if (value != null &&
                                      value.trim().isNotEmpty) {
                                    return null;
                                  } else {
                                    return "Please enter password";
                                  }
                                },
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    isObscure = !isObscure;
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomButton(
                                buttonColor: Colors.green,
                                labelColor: Colors.white,
                                label: 'SignIn',
                                isLoading: state is SignInLoadingState,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    String email = _emailController.text.trim();
                                    String password =
                                        _passwordController.text.trim();

                                    BlocProvider.of<SignInBloc>(context).add(
                                      SignInEvent(
                                        email: email,
                                        password: password,
                                      ),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomButton(
                                buttonColor: Colors.grey[200],
                                labelColor: Colors.black,
                                label: 'SignUp',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
