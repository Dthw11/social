import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../profile/present/pages/profile_page.dart';
import '../../../auth/present/cubits/auth_cubit.dart';
import 'my_drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              //logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),

              //home tile
              MyDrawerTile(
                title: "H o m e",
                icon: Icons.home,
                onTap: () => Navigator.of(context).pop(),
              ),

              //profile tile
              MyDrawerTile(
                title: "P r o f i l e",
                icon: Icons.person,
                onTap: () {
                  // pop menu drawer
                  Navigator.of(context).pop();

                  // get current user id
                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;

                  //navigater to profile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        uid: uid,
                      ),
                    ),
                  );
                },
              ),

              //setting tile
              MyDrawerTile(
                title: "S e t t i n g s",
                icon: Icons.settings,
                onTap: () {},
              ),

              const Spacer(),
              //logout tile
              MyDrawerTile(
                title: "L o g o u t",
                icon: Icons.login,
                onTap: () => context.read<AuthCubit>().logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
