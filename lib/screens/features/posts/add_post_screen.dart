import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/create_post_bloc/create_post_bloc.dart';
import 'package:flutter_application_1/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:flutter_application_1/components/custom_alert_dialog.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_repository/post_repository.dart';

class AddPostScreen extends StatefulWidget {
  int index;
  
  AddPostScreen({required this.index,
    super.key,
  });

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool pictureUploaded = false;
  late Post post;
  String file = "";
  var postController = TextEditingController();
  bool createPostRequired = false;
  @override
  void initState() {
    post = Post.empty;
    post.myUser = context.read<MyUserBloc>().state.user!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostLoading) {
          setState(() {
            createPostRequired = true;
          });
        } else if (state is CreatePostSuccess) {
          setState(() {
            createPostRequired = false;
            showDialog(
              context: context,
              builder: (context) {
                return const CustomAlertDialog('Success', primaryColor,
                    'Your post has been successfully created', 'OK');
              },
            );
          });
        } else if (state is CreatePostFailure) {
          setState(() {
            createPostRequired = false;
            showDialog(
              context: context,
              builder: (context) {
                return const CustomAlertDialog(
                    'Success', Colors.red, 'Something went wrong', 'Try Again');
              },
            );
          });
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              const Text(
                'Tell Your Friends What\'s On Your Mind Here.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Text(
                    'Upload image',
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker imagePicker = ImagePicker();
                        final XFile? image = await imagePicker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 40,
                            maxHeight: 500,
                            maxWidth: 500);
                        if (image != null) {
                          CroppedFile? croppedFile =
                              await ImageCropper().cropImage(
                            sourcePath: image.path,
                            aspectRatio:
                                const CropAspectRatio(ratioX: 1, ratioY: 1),
                            aspectRatioPresets: [CropAspectRatioPreset.square],
                            uiSettings: [
                              AndroidUiSettings(
                                  toolbarTitle: 'Cropper',
                                  toolbarColor: primaryColor,
                                  toolbarWidgetColor: Colors.white,
                                  initAspectRatio:
                                      CropAspectRatioPreset.original,
                                  lockAspectRatio: false),
                              IOSUiSettings(
                                title: 'Cropper',
                              ),
                            ],
                          );
                          if (croppedFile != null) {
                            setState(() {
                              file = croppedFile.path;
                              pictureUploaded = true;
                            });
                          }
                        }
                      },
                      icon: !pictureUploaded
                          ? const Icon(
                              Icons.add_a_photo_outlined,
                              color: primaryColor,
                              size: 28,
                            )
                          : const Icon(
                              Icons.photo,
                              color: primaryColor,
                              size: 28,
                            ))
                ],
              ),
              TextField(
                controller: postController,
                maxLines: 10,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'Write Somthing...',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: primaryColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: primaryColor)),
                ),
              ),
              !createPostRequired
                  ? SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      child: MyButton(() {
                        if (postController.text.isNotEmpty || file.isNotEmpty) {
                          post.postContent = postController.text;
                          post.myUser = context.read<MyUserBloc>().state.user!;
                          context
                              .read<CreatePostBloc>()
                              .add(CreatePostRequired(post, file));
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const CustomAlertDialog(
                                  'Empty Post',
                                  Colors.red,
                                  'Please enter somthing to post',
                                  'OK');
                            },
                          );
                        }
                      }, 'Post', secondaryColor))
                  : const CircularProgressIndicator()
            ]),
          ),
        ),
      ),
    );
  }
}
