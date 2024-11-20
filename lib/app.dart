import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/auth/data/firebase_auth_repo.dart';
import 'package:social_app/features/auth/present/cubits/auth_states.dart';
import 'package:social_app/features/auth/present/pages/auth_page.dart';
import 'package:social_app/features/post/data/firebase_post_repo.dart';
import 'package:social_app/features/post/present/cubits/post_cubit.dart';
import 'package:social_app/features/profile/data/firebase_profile_repo.dart';
import 'package:social_app/features/storage/data/firebase_storage_repo.dart';
import 'package:social_app/themes/light_mode.dart';
import 'features/home/present/pages/home_page.dart';
import 'features/auth/present/cubits/auth_cubit.dart';
import 'features/profile/present/cubit/profile_cubit.dart';

class MyApp extends StatelessWidget {
  //auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();
  //profile repo
  final firebaseProfileRepo = FirebaseProfileRepo();
  //storage repo
  final firebaseStorageRepo = FirebaseStorageRepo();
  //post repo
  final firebasePostRepo = FirebasePostRepo();
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //auth Cubit
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        //profile Cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
              profileRepo: firebaseProfileRepo,
              storageRepo: firebaseStorageRepo),
        ),

        // post cubit
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            storageRepo: firebaseStorageRepo,
          ),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);

            //unauthenticated -> authpage (login/register)
            if (authState is Unauthenticated) {
              return const AuthPage();
            }
            // authenticated -> home page
            if (authState is Authenticated) {
              return const HomePage();
            }

            //loading..
            else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },

          //listen for error
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}
