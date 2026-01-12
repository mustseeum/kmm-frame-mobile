import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_page.dart';
import 'package:kacamatamoo/core/utils/function_helper.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/controllers/login_screen_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/heading_card_widget.dart';

class LoginScreen extends BasePage<LoginScreenController> {
  const LoginScreen({super.key});

  @override
  Widget buildPage(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Get.find<LoginScreenController>();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // heading logo and title
                      HeadingCardWidget(
                        containerWidth: FunctionHelper.getContainerWidth(
                          constraints,
                        ),
                        isTablet: FunctionHelper.isTablet(constraints),
                      ),

                      // login form container
                      Container(
                        width: FunctionHelper.getContainerWidth(
                          constraints,
                        ).clamp(320.0, 720.0),
                        padding: EdgeInsets.all(
                          FunctionHelper.isTablet(constraints) ? 36 : 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Login'.tr,
                              style: TextStyle(
                                fontSize: FunctionHelper.isTablet(constraints)
                                    ? 32
                                    : 18,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'login_wording'.tr,
                              style: TextStyle(
                                fontSize: FunctionHelper.isTablet(constraints)
                                    ? 16
                                    : 18,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'email'.tr,
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 14,
                                      ),
                                    ),
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? 'please_enter_email'.tr
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: passCtrl,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'password'.tr,
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 14,
                                      ),
                                    ),
                                    validator: (v) =>
                                        (v == null || v.length < 6)
                                        ? 'password_warning'.tr
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                  Obx(() {
                                    return ElevatedButton(
                                      onPressed: auth.isLoading.value
                                          ? null
                                          : () {
                                              if (formKey.currentState
                                                      ?.validate() ??
                                                  false) {
                                                auth.login(
                                                  email: emailCtrl.text.trim(),
                                                  password: passCtrl.text,
                                                );
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(48),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: auth.isLoading.value
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              'sign_in'.tr,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: FunctionHelper.isTablet(constraints) ? 24 : 12,
                          ),
                          child: Text(
                            'copy_right'.tr,
                            style: TextStyle(
                              fontSize: FunctionHelper.isTablet(constraints)
                                  ? 14
                                  : 12,
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
