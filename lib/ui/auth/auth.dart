import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/repo/auth_repository.dart';
import 'package:nike_store/data/repo/cart_repository.dart';
import 'package:nike_store/ui/auth/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _usernameController =
      TextEditingController(text: "telecleverguy@gmail.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "123456");

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    const onBackground = Colors.white;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: themeData.copyWith(
          snackBarTheme: SnackBarThemeData(
              backgroundColor: themeData.colorScheme.primary,
              contentTextStyle: const TextStyle(fontFamily: fontName)),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(const Size.fromHeight(56)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
                backgroundColor: MaterialStateProperty.all(onBackground),
                foregroundColor:
                    MaterialStateProperty.all(themeData.colorScheme.secondary)),
          ),
          colorScheme: themeData.colorScheme.copyWith(onSurface: onBackground),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: const TextStyle(color: onBackground),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: themeData.colorScheme.secondary,
            body: BlocProvider<AuthBloc>(
              create: (context) {
                final bloc = AuthBloc(authRepository, cartRepository);
                bloc.stream.forEach((state) {
                  if (state is AuthSuccess) {
                    Navigator.of(context).pop();
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.exception.message),
                      ),
                    );
                  }
                });
                bloc.add(AuthStarted());
                return bloc;
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(48, 24, 48, 0),
                child: BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) {
                    return current is AuthLoading ||
                        current is AuthInitial ||
                        current is AuthError;
                  },
                  builder: (context, state) {
                    return Center(
                      child: SingleChildScrollView(
                        physics: defaultScrollPhysics,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/img/nike_logo.png',
                              color: Colors.white,
                              width: 120,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              state.isLoginMode ? 'خوش آمدید' : 'ثبت نام',
                              style: const TextStyle(
                                  color: onBackground, fontSize: 22),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              state.isLoginMode
                                  ? 'لطفا وارد حساب کاربری خود شوید'
                                  : 'ایمیل و رمز عبور خود را تعیین کنید',
                              style: const TextStyle(
                                  color: onBackground, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextField(
                              controller: _usernameController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  label: Text('آدرس ایمیل')),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            _PasswordTextField(
                                controller: _passwordController,
                                onBackground: onBackground),
                            const SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<AuthBloc>(context).add(
                                  AuthButtonIsClicked(_usernameController.text,
                                      _passwordController.text),
                                );
                              },
                              child: state is AuthLoading
                                  ? const CupertinoActivityIndicator()
                                  : state.isLoginMode
                                      ? const Text('ورود')
                                      : const Text('ثبت نام'),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.isLoginMode
                                      ? 'حساب کاربری ندارید؟'
                                      : 'حساب کاربری دارید؟',
                                  style: TextStyle(
                                    color: onBackground.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<AuthBloc>(context)
                                        .add(AuthModeChangeIsClicked());
                                  },
                                  child: Text(
                                    state.isLoginMode ? 'ثبت نام' : 'ورود',
                                    style: TextStyle(
                                        color: themeData.colorScheme.primary,
                                        decoration: TextDecoration.underline),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    Key? key,
    required this.onBackground,
    required this.controller,
  }) : super(key: key);

  final Color onBackground;
  final TextEditingController controller;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            splashRadius: 18,
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            icon: Icon(
              obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: widget.onBackground.withOpacity(0.6),
            ),
          ),
          label: const Text('رمز عبور')),
    );
  }
}
