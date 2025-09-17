import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodapp/components/const.dart';
import 'package:foodapp/components/custom_phone_field.dart';
import 'package:foodapp/components/custom_scaffold.dart';
import 'package:foodapp/components/custom_textformfield.dart';
import 'package:foodapp/components/default_appbar.dart';
import 'package:foodapp/components/default_button.dart';
import 'package:foodapp/modules/auth/login/cubit/login_cubit.dart';
import 'package:foodapp/modules/auth/login/cubit/login_states.dart';
import 'package:foodapp/modules/auth/login/login_screen.dart';
import 'package:foodapp/modules/auth/register/cubit/register_cubit.dart';

import 'cubit/register_states.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>(
          builder: (context, state) {
            final cubit = RegisterCubit.get(context);
            final registerFormKey = GlobalKey<FormState>();
            return CustomScaffold(
              body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: registerFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultAppBar(
                                title: "create_new_account".tr(),
                                context: context,
                                lang: context.locale.languageCode),
                            SizedBox(
                              height: 50.h,
                            ),
                            CustomTextFormField(
                              controller: cubit.firstNameController,
                              hintText: "first_name".tr(),
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
                              controller: cubit.lastNameController,
                              hintText: "second_name".tr(),
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
                            PhoneNumberField(controller: cubit.phoneController,
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
                            SizedBox(
                              height: 20.h,
                            ),
                            ConditionalBuilder(
                                condition: state is !CreateAccountLoadingState,
                                builder: (context) => DefaultButton(
                                  text: "register".tr(),
                                  onPressed: () {
                                    if(registerFormKey.currentState!.validate()){
                                      cubit.createAccount();
                                    }
                                  },
                                ),
                                fallback: (context) => Center(
                                  child: CircularProgressIndicator(
                                    color: Color(mainColor),
                                  ),
                                ),
                            ),
                            SizedBox(
                              height: 50.h,
                            ),

                          Center(
                            child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "already_have_account".tr(),
                                      style: TextStyle(
                                          fontFamily:"madMd",
                                          fontSize: 12.sp,
                                      color: Colors.black
                                      ),
                                    ),
                                    TextSpan(
                                      text: "login".tr(),
                                      style: TextStyle(
                                          fontFamily:"madMd",
                                          fontSize: 12.sp,
                                      color: Color(mainColor)
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                        Navigator.pop(context);
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
          if(state is CreateAccountSuccessState){
            navigateAndFinish(context, LoginScreen());
          }
        },
      ),
    );
  }
}
