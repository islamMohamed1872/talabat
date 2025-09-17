import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodapp/components/const.dart';
import 'package:foodapp/components/custom_scaffold.dart';
import 'package:foodapp/components/custom_textformfield.dart';
import 'package:foodapp/components/default_button.dart';
import 'package:foodapp/modules/auth/login/cubit/login_cubit.dart';
import 'package:foodapp/modules/auth/login/cubit/login_states.dart';
import 'package:foodapp/modules/auth/register/register_screen.dart';
import 'package:foodapp/modules/home/screens_holder.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit,LoginStates>(
        builder: (context, state) {
          final cubit = LoginCubit.get(context);
          final loginFormKey = GlobalKey<FormState>();
          return CustomScaffold(
            body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 35.h,
                          ),
                          Center(
                            child: Container(
                              width: 269,
                              height: 136,
                              decoration: BoxDecoration(color: const Color(0xFFD9D9D9)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          text14Style(text: "welcome_message".tr(),),
                          SizedBox(
                            height: 15,
                          ),
                          text14Style(text: "login".tr(),),
                          SizedBox(
                            height: 25,
                          ),
                          CustomTextFormField(
                              controller: cubit.emailController,
                              hintText: "email".tr(),
                          keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if(value!.isEmpty){
                                return "required".tr();
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          CustomTextFormField(
                            controller: cubit.passwordController,
                            hintText: "password".tr(),
                            validator: (value) {
                              if(value!.isEmpty){
                                return "required".tr();
                              }
                              return null;
                            },
                            obscureText: cubit.hidePassword,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  cubit.togglePassword();
                                }, icon: Icon(cubit.hidePassword? Icons.visibility_outlined:Icons.visibility_off_outlined)),
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              TextButton(
                                onPressed: () {

                                },
                               child:  Text("forgot_password".tr(),
                                 style: TextStyle(
                                   decoration: TextDecoration.underline,
                                   fontFamily: "madMd",
                                   fontSize: 10.sp,
                                 color: Colors.black
                                 ),
                               )
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ConditionalBuilder(
                              condition: state is !LoginLoadingState,
                              builder: (context) => DefaultButton(
                                text: "login_button".tr(),
                                onPressed: () {
                                  if(loginFormKey.currentState!.validate()){
                                    cubit.login();
                                  }
                                },
                              ),
                              fallback: (context) => Center(
                                child: CircularProgressIndicator(
                                  color: Color(mainColor),
                                ),
                              ),),
                          SizedBox(
                            height: 30.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Color(0xffDCDCDC),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                                child: Text("or_login_with".tr(),
                                  style: TextStyle(
                                      fontFamily: "madReg",
                                      fontSize: 12.sp,
                                      color: Color(0xffDCDCDC)
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Color(0xffDCDCDC),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: double.infinity,
                              height: 50.h,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1, color: Color(0xFFDBDBDB)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FontAwesomeIcons.google),
                                  SizedBox(width: 10),
                                  text12Style(text: "login_with_google".tr()),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 30.h,
                          ),
                        Center(
                          child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "dont_have_account".tr(),
                                    style: TextStyle(
                                        fontFamily:"madMd",
                                        fontSize: 12.sp,
                                    color: Colors.black
                                    ),
                                  ),
                                  TextSpan(
                                    text: "register_now".tr(),
                                    style: TextStyle(
                                        fontFamily:"madMd",
                                        fontSize: 12.sp,
                                    color: Color(mainColor)
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        navigateTo(context, RegisterScreen());
                                      },
                                  ),
                                ]
                              ),
                          ),
                        ),
                        ],
                      ),
                    ),
                  ),
                )
            ),
          );
        },
      listener: (context, state) {
        if(state is LoginSuccessState){
          navigateAndFinish(context, ScreensHolder());
        }
      },
    );
  }
}
