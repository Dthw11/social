import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/post/domain/entities/comment.dart';
import 'package:social_app/features/post/domain/entities/post.dart';
import 'package:social_app/features/post/domain/repo/post_repo.dart';
import 'package:social_app/features/post/present/cubits/post_sates.dart';
import 'package:social_app/features/storage/domain/storage_repo.dart';


class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({
    required this.postRepo,
    required this.storageRepo,
  }) : super(PostsInitial());

  //create a new post
  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;

    try {
      //handle image upload for mobile paltforms (using file path)
      if (imagePath != null) {
        emit(PostsUploaing());
        imageUrl =
            await storageRepo.uploadProfileImageMobile(imagePath, post.id);
      } else if (imageBytes != null) {
        emit(PostsUploaing());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      //give url image to post
      final newPost = post.copyWith(imageUrl: imageUrl);

      //create post in the backend
      postRepo.createPost(newPost);
    } catch (e) {
      throw Exception("Failed to create post: $e");
    }
  }

  //Fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Failed to fetch posts: $e"));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {}
  }

  //toggle like on a post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostsError("Failed to toggle like: $e"));
    }
  }

  //add a comment t a post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);

      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to add comment : $e"));
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);

      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to delete comment: $e"));
    }
  }
}
