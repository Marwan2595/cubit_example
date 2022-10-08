import 'package:cubit/models/user.dart';
import 'package:cubit/users_List/cubit/users_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/users_cubit.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit()..getUsers(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cubit"),
        ),
        body: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              children: [
                UserCubit.get(context).state is UserLoading
                    ? const Padding(
                        padding: EdgeInsets.only(top: 150),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                            strokeWidth: 8,
                          ),
                        ),
                      )
                    : UserCubit.get(context).state is UserError
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
                        : Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: ((context, index) {
                                User user =
                                    UserCubit.get(context).usersList[index];
                                //Logger().i("User in Loop : $user");
                                return ListItem(user: user);
                                // return Text(user.name.toString());
                              }),
                              itemCount:
                                  UserCubit.get(context).usersList.length,
                            ),
                          ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(25),
        padding: const EdgeInsets.all(10),
        color: Colors.black.withOpacity(.4),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
              // child: Image.network(user.avatar!),
              backgroundImage: NetworkImage(user.avatar!),
              radius: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            // Image.network("https://reqres.in/img/faces/10-image.jpg"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.firstName!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                const Text(" "),
                Text(
                  user.lastName!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              user.email!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
