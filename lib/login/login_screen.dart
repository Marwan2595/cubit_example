import 'package:cubit/users_List/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_state.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: SizedBox(
          width: 450, //#Mass123
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              MainTextField(
                                textController: emailController,
                                title: "Name",
                                validation: (value) {
                                  if (value!.isEmpty) {
                                    return "Can't Be Empty";
                                  }
                                },
                              ),
                              MainTextField(
                                textController: passController,
                                title: "Job",
                                validation: (value) {
                                  if (value!.isEmpty) {
                                    return "Can't Be Empty";
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              MainButton(
                                title: "Add User",
                                color: Colors.blue,
                                textColor: Colors.white,
                                onPressFunction: () {
                                  if (_formKey.currentState!.validate()) {
                                    LoginCubit.get(context).login(
                                        email: emailController.text,
                                        password: passController.text,
                                        navigationFunction: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const UsersScreen(),
                                            ),
                                          );
                                        });
                                  } else {}
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  LoginCubit.get(context).state is LoginLoading
                      ? const Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                              strokeWidth: 8,
                            ),
                          ),
                        )
                      : const SizedBox(
                          width: 0,
                          height: 0,
                        ),
                  LoginCubit.get(context).state is LoginError
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text("Error Message"),
                            ],
                          ),
                        )
                      : const SizedBox(
                          width: 0,
                          height: 0,
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

class MainButton extends StatelessWidget {
  MainButton({
    required this.title,
    required this.color,
    required this.textColor,
    this.isDisabled = false,
    required this.onPressFunction,
    Key? key,
  }) : super(key: key);
  final String title;
  final Color color;
  final Color textColor;
  bool isDisabled;
  final void Function() onPressFunction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: isDisabled ? () {} : onPressFunction,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(300, 50),
          primary: isDisabled ? Colors.grey : color,
          onSurface: textColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                12,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
        ),
      ),
    );
  }
}

class MainTextField extends StatelessWidget {
  const MainTextField({
    Key? key,
    required this.title,
    required this.textController,
    this.type = TextInputType.text,
    this.isPassword = false,
    required this.validation,
  }) : super(key: key);

  final TextEditingController textController;
  final String title;
  final bool isPassword;
  final TextInputType type;
  final validation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          obscureText: isPassword,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.black,
          ),
          controller: textController,
          cursorHeight: 25,
          decoration: InputDecoration(
            errorStyle: TextStyle(
              color: Colors.red,
              fontSize: 15,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red)),
            fillColor: Colors.transparent,
            filled: true,
          ),
          validator: validation,
        ),
      ],
    );
  }
}
