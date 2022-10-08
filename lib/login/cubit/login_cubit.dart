import 'package:cubit/http_handler.dart';
import 'package:cubit/login/cubit/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  HttpHandler httpHandler = HttpHandler();

  void toInitial() {
    emit(LoginInitial());
  }

  void login({
    required String email,
    required String password,
    required VoidCallback navigationFunction,
  }) async {
    emit(LoginLoading());
    await httpHandler.post(
      "api/users",
      body: {
        "name": email,
        "job": password,
      },
    ).then((value) {
      if (value == null) {
        print("null login");
        emit(LoginError());
      } else {
        print("not null login");
        //User loggedUser = User.fromJson(value["data"]);
        // StorageManager.storeUserData(
        //   user: loggedUser,
        // );
        emit(LoginSuccess());
        Logger().d(value);
        navigationFunction();
      }
    }).catchError((error) {
      emit(LoginError());
    });
  }
}
