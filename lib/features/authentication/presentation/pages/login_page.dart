import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:news_app/config/routes/all_pages.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/core/constants/common_widgets.dart';
import 'package:news_app/core/constants/custom_text.dart';
import 'package:news_app/core/constants/custom_text_button.dart';
import 'package:news_app/core/constants/custom_textfield.dart';
import 'package:news_app/core/constants/keyboard_util.dart';
import 'package:news_app/core/constants/screen_padding.dart';
import 'package:news_app/features/news_article/presentation/pages/main_page/main_page.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/credential/credential_cubit.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_slash_fill;
  String? _errorMsg;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                  return loginForm();
                }
              },
            );
          }

          return loginForm();
        },
      ),
    );
  }

  loginForm() {
    return ScreenPadding(
      childWidget: Column(
        children: [
          const Spacer(),
          CustomText(
            text: 'Login',
            textSize: 35.sp,
            textColor: greenColor,
          ),
          Divider(
            thickness: 1.sp,
          ),
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
          10.verticalSpace,
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
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AllPages.forgotPage);
              },
              child: CustomText(
                text: 'Forgot password?',
                textColor: greenColor,
                isBold: true,
              ),
            ),
          ),
          10.verticalSpace,
          CustomTextButton(
            context: context,
            text: "Login", onPressed: _submitLogin,
          ),
          5.verticalSpace,
          Container(
            alignment: Alignment.topRight,
            child: Row(
              children: <Widget>[
                CustomText(
                  text: "Don't have an Account",
                  isBold: true,
                ),
                5.horizontalSpace,
                InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/registration", (route) => false);
                  },
                  child: CustomText(
                      text: 'Register', isBold: true, textColor: greenColor),
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  BlocProvider.of<CredentialCubit>(context).googleAuthSubmit();
                },
                child: Container(
                  height: 50.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.2),
                          offset: const Offset(1.0, 1.0),
                          spreadRadius: 1.r,
                          blurRadius: 1.r,
                        )
                      ]),
                  child: const Icon(
                    Ionicons.logo_google,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void _submitLogin() {
    KeyboardUtil.hideKeyboard(context);
    if (_emailController.text.isEmpty) {
      toast('enter your email');
      return;
    }
    if (_passwordController.text.isEmpty) {
      toast('enter your password');
      return;
    }
    BlocProvider.of<CredentialCubit>(context).signInSubmit(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
}
