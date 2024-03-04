import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/routes/all_pages.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/core/constants/common_widgets.dart';
import 'package:news_app/core/constants/custom_text.dart';
import 'package:news_app/core/constants/custom_text_button.dart';
import 'package:news_app/core/constants/custom_textfield.dart';
import 'package:news_app/features/authentication/domain/entities/user_entity.dart';
import 'package:news_app/features/authentication/presentation/bloc/auth/auth_cubit.dart';
import 'package:news_app/features/authentication/presentation/bloc/credential/credential_cubit.dart';
import 'package:news_app/features/news_article/presentation/pages/main_page/main_page.dart';

class RegistrationPage extends StatefulWidget {
  static const routeName = '/registration';

  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_slash_fill;
  String? _errorMsg;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _passwordAgainController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (credentialState is CredentialFailure) {
            snackBarNetwork(
                msg: "wrong email please check", scaffoldState: scaffoldState);
            _errorMsg = 'Invalid email or password';
          }
        },
        builder: (context, credentialState) {
          if (credentialState is CredentialLoading) {
            return Scaffold(
              body: loadingIndicatorProgressBar(),
            );
          }
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainPage();
                } else {
                  return signupForm();
                }
              },
            );
          }

          return signupForm();
        },
      ),
    );
  }

  Widget signupForm() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 35),
        child: Column(
          children: <Widget>[
            10.verticalSpace,
            CustomText(
              textColor: greenColor,
              text: "Register",
              textSize: 35.sp,
            ),
            10.verticalSpace,
            const Divider(
              thickness: 1,
            ),
            10.verticalSpace,
            CustomTextField(
                controller: _emailController,
                hintText: 'Username',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(CupertinoIcons.mail_solid),
                errorMsg: _errorMsg,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                      .hasMatch(val)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                }),
            10.verticalSpace,
            CustomTextField(
                controller: _emailController,
                hintText: 'Email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(CupertinoIcons.mail_solid),
                errorMsg: _errorMsg,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                      .hasMatch(val)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                }),
            const SizedBox(
              height: 17,
            ),
            const Divider(
              thickness: 2,
              indent: 120,
              endIndent: 120,
            ),
            const SizedBox(
              height: 17,
            ),
            CustomTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: const Icon(CupertinoIcons.lock_fill),
              errorMsg: _errorMsg,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please fill in this field';
                } else if (!RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                    .hasMatch(val)) {
                  return 'Please enter a valid password';
                }
                return null;
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                    if (obscurePassword) {
                      iconPassword = CupertinoIcons.eye_slash_fill;
                    } else {
                      iconPassword = CupertinoIcons.eye_fill;
                    }
                  });
                },
                icon: Icon(iconPassword),
              ),
            ),
            10.verticalSpace,
            CustomTextField(
              controller: _passwordAgainController,
              hintText: 'Password (Again)',
              obscureText: obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: const Icon(CupertinoIcons.lock_fill),
              errorMsg: _errorMsg,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please fill in this field';
                } else if (!RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                    .hasMatch(val)) {
                  return 'Please enter a valid password';
                }
                return null;
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                    if (obscurePassword) {
                      iconPassword = CupertinoIcons.eye_fill;
                    } else {
                      iconPassword = CupertinoIcons.eye_slash_fill;
                    }
                  });
                },
                icon: Icon(iconPassword),
              ),
            ),
            10.verticalSpace,
            CustomTextButton(
              context: context,
              text: "Register",
              onPressed: _submitSignUp,
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Do you have already an account?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, AllPages.loginPage, (route) => false);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: greenColor),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  _submitSignUp() {
    if (_usernameController.text.isEmpty) {
      toast('enter your username');
      return;
    }
    if (_emailController.text.isEmpty) {
      toast('enter your email');
      return;
    }
    if (_passwordController.text.isEmpty) {
      toast('enter your password');
      return;
    }
    if (_passwordAgainController.text.isEmpty) {
      toast('enter your again password');
      return;
    }

    if (_passwordController.text == _passwordAgainController.text) {
    } else {
      toast("both password must be same");
      return;
    }

    BlocProvider.of<CredentialCubit>(context).signUpSubmit(
      user: UserEntity(
        email: _emailController.text,
        name: _usernameController.text,
        password: _passwordController.text,
        isOnline: false,
        status: "Hi! there i'm using this app",
      ),
    );
  }
}
