import 'package:cubit/http_handler.dart';
import 'package:cubit/users_List/cubit/users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../models/user.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  static UserCubit get(context) => BlocProvider.of(context);

  HttpHandler httpHandler = HttpHandler();

  List<User> usersList = [];

  void getUsers() async {
    emit(UserLoading());
    await httpHandler.getData(
      "api/users",
      params: {
        "page": "1",
        "per_page": "12",
      },
    ).then((value) {
      if (value == null) {
        print("null Data");
        emit(UserError());
      } else {
        print("not null Data");
        Iterable userListJson = value["data"];
        Logger().e(userListJson);
        userListJson.forEach((user) {
          if (user["id"] != null) {
            usersList.add(User.fromJson(user));
          }
        });
        print("usersList");
        emit(UserSuccess());
        //navigationFunction();
      }
    }).catchError((error) {
      emit(UserError());
    });
  }
}
