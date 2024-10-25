import 'package:chat_todo/features/auth/provider/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInPage extends StatefulHookConsumerWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    if (!RegExp(emailRegex).hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter a password';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (prev, next) {
      next.maybeWhen(
          orElse: () => null,
          authenticated: (user) => {context.go("/")},
          unauthenticated: (message) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message!),
              behavior: SnackBarBehavior.floating,
            ));
          });
    });

    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: TextFormField(
                        validator: _validateEmail,
                        controller: _emailController,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              size: 24,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            labelText: "Enter email",
                            hintText: "ermiasmesfin@gmail.com",
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 24),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                                )),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                  width: 1,
                                ))),
                      ),
                    ),
                    TextFormField(
                      validator: _validatePassword,
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 24,
                            color: Theme.of(context).primaryColor,
                          ),
                          suffixIcon: Icon(
                            Icons.remove_red_eye,
                            size: 24,
                            color: Theme.of(context).primaryColor,
                          ),
                          labelText: "Enter password",
                          hintText: "ermiasmesfin@gmail.com",
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 24),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
                              )),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                width: 1,
                              ))),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final email = _emailController.text;
                            final password = _passwordController.text;
                            ref
                                .read(authNotifierProvider.notifier)
                                .signIn(email: email, password: password);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)))),
                        child: Center(
                          child: Text(
                            "SignIn With Email",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                          ),
                        )),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 7,
                          child: Divider(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Center(
                            child: Text(
                              "OR",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          child: Divider(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    OutlinedButton(
                        onPressed: () {
                          ref
                              .read(authNotifierProvider.notifier)
                              .continueWithGoogle();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            side: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer)),
                        child: Center(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Image.asset(
                                  "assets/icons/google-signin.png",
                                  height: 32,
                                  width: 32,
                                ),
                              ),
                              Text(
                                "Continue With Google",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 24,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: RichText(
                          text: TextSpan(
                              text: "New here?  ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                )
                              ]),
                        ))
                  ],
                ),
              )),
        ],
      ),
    ));
  }
}
