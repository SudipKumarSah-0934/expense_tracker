import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/routes/all_pages.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/core/constants/common_widgets.dart';
import 'package:news_app/core/constants/custom_text.dart';
import 'package:news_app/core/constants/custom_text_button.dart';
import 'package:news_app/core/constants/custom_textfield.dart';
import 'package:news_app/core/constants/screen_padding.dart';

class ForgetPassPage extends StatefulWidget {
  static const routeName = '/reset-password';

  const ForgetPassPage({super.key});

  @override
  _ForgetPassPageState createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  final TextEditingController _emailController = TextEditingController();
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  String? _errorMsg;
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ScreenPadding(
          childWidget: Column(
            children: <Widget>[
              30.verticalSpace,
              CustomText(
                  text: 'Forgot Password',
                  textSize: 30.sp,
                  isBold: true,
                  textColor: greenColor),
              10.verticalSpace,
              const Divider(
                thickness: 1,
              ),
              20.verticalSpace,
              Text(
                "Don't worry! Just fill in your email and  will send you a link to rest your password.",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(.6),
                    fontStyle: FontStyle.italic),
              ),
              30.verticalSpace,
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
              20.verticalSpace,
              CustomTextButton(
                  context: context, text: "Reset Password", onPressed: _submit,),
              10.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Remember the account information? ',
                    style:
                        TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, AllPages.loginPage, (route) => false);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: greenColor),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_emailController.text.isEmpty) {
      toast('Enter your email');
      return;
    }
  }
}
