import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/auth/present/cubits/auth_cubit.dart';
import 'package:social_app/features/post/present/components/post_tile.dart';
import 'package:social_app/features/post/present/cubits/post_cubit.dart';
import 'package:social_app/features/post/present/cubits/post_sates.dart';
import 'package:social_app/features/profile/present/components/bio_box.dart';
import 'package:social_app/features/profile/present/components/follow_button.dart';
import 'package:social_app/features/profile/present/cubit/profile_cubit.dart';
import 'package:social_app/features/profile/present/cubit/profile_state.dart';
import 'package:social_app/features/profile/present/pages/edit_profile_page.dart';


import '../../../auth/domain/entities/app_user.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // current user
  late AppUser? currentUser = authCubit.currentUser;

  // posts
  int postCount = 0;

  // on startup
  @override
  void initState() {
    super.initState();

    // load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProflieLoaded) {
          //get loaded user
          final user = state.profileUser;
          return Scaffold(
            // App Bar
            appBar: AppBar(
              title: Text(user.name),
              centerTitle: true, // Đưa title ra giữa
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .primary, // Đổi thành màu tertiary
              foregroundColor: Theme.of(context).colorScheme.tertiary,
              actions: [
                //edit profile button
                IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          user: user,
                        ),
                      )),
                  icon: const Icon(Icons.settings),
                )
              ],
            ),

            //body
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          user.email,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary),
                        ),

                        const SizedBox(height: 25),

                        // profile pic
                        CachedNetworkImage(
                          imageUrl: user.profileImageUrl,
                          //loading..
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          //error -> failed to loading
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            size: 72,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          // loaded
                          imageBuilder: (context, ImageProvider) => Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // follow button
                        FollowButton(
                          onPressed: () {},
                          isFollowing: true,
                        ),

                        //bio
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Row(
                            children: [
                              Text(
                                "Bio",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BioBox(text: user.bio),

                        //posts
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Row(
                            children: [
                              Text(
                                "Post",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // list od posts from this user
                        BlocBuilder<PostCubit, PostState>(
                            builder: (context, state) {
                          // posts loaded ..
                          if (state is PostsLoaded) {
                            //filter posts by user id
                            final userPosts = state.posts
                                .where((post) => post.userId == widget.uid)
                                .toList();

                            postCount = userPosts.length;

                            return ListView.builder(
                              itemCount: postCount,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                // get individual post
                                final post = userPosts[index];

                                // return as posts tile UI
                                return PostTile(
                                  post: post,
                                  onDeletePressed: () => context
                                      .read<PostCubit>()
                                      .deletePost(post.id),
                                );
                              },
                            );
                          }

                          // posts loading
                          else if (state is PostsLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return const Center(
                              child: Text("No posts .."),
                            );
                          }
                        })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        // loading ..
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const Center(
            child: Text("No proflie found.."),
          );
        }
      },
    );
  }
}
