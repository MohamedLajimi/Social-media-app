import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_application_1/blocs/create_post_bloc/create_post_bloc.dart';
import 'package:flutter_application_1/blocs/follow_bloc/follow_bloc.dart';
import 'package:flutter_application_1/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:flutter_application_1/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:flutter_application_1/blocs/search_bloc/search_bloc.dart';
import 'package:flutter_application_1/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_application_1/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:flutter_application_1/constants/colors.dart';
import 'package:flutter_application_1/screens/features/friends/friends_screen.dart';
import 'package:flutter_application_1/screens/features/posts/add_post_screen.dart';
import 'package:flutter_application_1/screens/features/home/posts_screen.dart';
import 'package:flutter_application_1/screens/features/search/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friendship_repository/friendship_repository.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_repository/post_repository.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final SearchController searchController = SearchController();
  bool searchrequired = false;
  int index = 0;
  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
        listener: (context, state) {
          if (state is UpdatePictureSuccess) {
            setState(() {
              context.read<MyUserBloc>().state.user!.picture = state.userImage;
            });
          }
        },
        child: Scaffold(
            appBar: AppBar(
                    surfaceTintColor: tertiaryColor,
                    backgroundColor: tertiaryColor,
                    toolbarHeight: 80,
                    title:  const Text(
                      'SocialMed',
                      style: TextStyle(
                          letterSpacing: 1.2,
                          color: secondaryColor,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    actions: [
                        IconButton(
                            onPressed: () {
                              context.read<SignInBloc>().add(SignOutRequired());
                            },
                            icon: const Icon(
                              Icons.logout,
                              color: primaryColor,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: const FaIcon(
                              Icons.notifications_outlined,
                              color: primaryColor,
                              size: 30,
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        BlocBuilder<MyUserBloc, MyUserState>(
                          builder: (context, state) {
                            if (state.status == MyUserStatus.success) {
                              return Row(
                                children: [
                                  state.user!.picture == ""
                                      ? GestureDetector(
                                          onTap: () async {
                                            final ImagePicker imagePicker =
                                                ImagePicker();
                                            final XFile? image =
                                                await imagePicker.pickImage(
                                                    source: ImageSource.gallery,
                                                    imageQuality: 40,
                                                    maxHeight: 1000,
                                                    maxWidth: 1000);
                                            if (image != null) {
                                              CroppedFile? croppedFile =
                                                  await ImageCropper()
                                                      .cropImage(
                                                sourcePath: image.path,
                                                aspectRatio:
                                                    const CropAspectRatio(
                                                        ratioX: 1, ratioY: 1),
                                                aspectRatioPresets: [
                                                  CropAspectRatioPreset.square
                                                ],
                                                uiSettings: [
                                                  AndroidUiSettings(
                                                      toolbarTitle: 'Cropper',
                                                      toolbarColor:
                                                          primaryColor,
                                                      toolbarWidgetColor:
                                                          Colors.white,
                                                      initAspectRatio:
                                                          CropAspectRatioPreset
                                                              .original,
                                                      lockAspectRatio: false),
                                                  IOSUiSettings(
                                                    title: 'Cropper',
                                                  ),
                                                ],
                                              );
                                              if (croppedFile != null) {
                                                setState(() {
                                                  context
                                                      .read<
                                                          UpdateUserInfoBloc>()
                                                      .add(UploadPicture(
                                                          croppedFile.path,
                                                          context
                                                              .read<
                                                                  MyUserBloc>()
                                                              .state
                                                              .user!
                                                              .id));
                                                });
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey.shade300,
                                            ),
                                            child: Icon(
                                              CupertinoIcons.person,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      state.user!.picture!),
                                                  fit: BoxFit.cover)),
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                      ]),
            body: Padding(
                padding: const EdgeInsets.all(10),
                child: PageView(
                  controller: controller,
                  children: [
                    BlocProvider(
                      create: (context) => GetPostBloc(
                          postRepository: FirebasePostRepository())
                        ..add(
                            GetPost(context.read<AuthBloc>().state.user!.uid)),
                      child: const PostsScreen(),
                    ),
                    MultiBlocProvider(providers: [
                      BlocProvider(
                        create: (context) => SearchBloc(
                            friendshipRepository:
                                FirebaseFriendshipRepository()),
                      ),
                      BlocProvider(
                        create: (context) => FollowBloc(
                            friendshipRepository:
                                FirebaseFriendshipRepository()),
                      )
                    ], child: const SearchScreen()),
                    BlocProvider(
                      create: (context) => CreatePostBloc(
                          postRepository: FirebasePostRepository()),
                      child:  AddPostScreen(index: index,),
                    ),
                    const FriendsScreen(),
                  ],
                )),
            bottomNavigationBar: CurvedNavigationBar(
                backgroundColor: tertiaryColor,
                buttonBackgroundColor: primaryColor,
                color: secondaryColor,
                iconPadding: 16,
                height: 80,
                index: index,
                onTap: (value) {
                  setState(() {
                    index = value;
                    controller.animateToPage(index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linear);
                  });
                },
                items: [
                  CurvedNavigationBarItem(
                    child: Container(
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          'assets/icons/home.svg',
                          color: Colors.white,
                          width: 30,
                          height: 30,
                        )),
                  ),
                  CurvedNavigationBarItem(
                    child: Container(
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          'assets/icons/search.svg',
                          color: Colors.white,
                          width: 30,
                          height: 30,
                        )),
                  ),
                  CurvedNavigationBarItem(
                    child: Container(
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          'assets/icons/add.svg',
                          color: Colors.white,
                          width: 30,
                          height: 30,
                        )),
                  ),
                  CurvedNavigationBarItem(
                    child: Container(
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          'assets/icons/heart.svg',
                          color: Colors.white,
                          width: 30,
                          height: 30,
                        )),
                  ),
                ])));
  }
}
