import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/auth/domain/entities/app_user.dart';
import 'package:social_app/features/auth/present/compoments/my_text_field.dart';
import 'package:social_app/features/auth/present/cubits/auth_cubit.dart';
import 'package:social_app/features/post/domain/entities/post.dart';
import 'package:social_app/features/post/present/cubits/post_cubit.dart';
import 'package:social_app/features/post/present/cubits/post_sates.dart';


class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // mobile iamge pick
  PlatformFile? imagePickedFile;

  // web image pick
  Uint8List? webImage;

  //text controller -> caption
  final textController = TextEditingController();

  // current user
  AppUser? currentUser;
  //BUID UI
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  //get current user
  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  // pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  //create & upload post
  void uploadPost() {
    // check if both image and caption are porvided
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Both iamge and caption are required")));
      return;
    }
    final newPost = Post(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    //post cubit
    final postCubit = context.read<PostCubit>();

    //web upaload
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    }

    // mobile upload
    else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    //SCAFFOLD
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        print(state);
        //loading or uploading ..
        if (state is PostsLoading || state is PostsUploaing) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        //build upload page
        return buildUploadPage();
      },
      // go to previus page when upload is done & posts are loaded
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    //SCAFFOLD
    return Scaffold(
      //APP BAR
      appBar: AppBar(
        title: const Text("Create Post"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // upload button
          IconButton(
            onPressed: uploadPost,
            icon: const Icon(Icons.upload),
          ),
        ],
      ),

      //BODY
      body: Center(
        child: Column(
          children: [
            // image preview for web
            if (kIsWeb && imagePickedFile != null) Image.memory(webImage!),

            // image preview for mobile
            if (!kIsWeb && imagePickedFile != null)
              Image.file(File(imagePickedFile!.path!)),
            //pick image button
            MaterialButton(
              onPressed: pickImage,
              color: Colors.black,
              child: const Text("Pick Image"),
            ),

            //caption text box
            MyTextField(
              controller: textController,
              hinText: "Caption",
              obscureText: false,
            ),
          ],
        ),
      ),
    );
  }
}
