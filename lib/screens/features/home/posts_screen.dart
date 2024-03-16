import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_application_1/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:flutter_application_1/blocs/react_to_post_bloc/react_to_post_bloc.dart';
import 'package:flutter_application_1/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:flutter_application_1/components/post_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late String picture;
  bool pictureChanged = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        if (state is UpdatePictureSuccess) {
          picture = state.userImage;
          pictureChanged = true;
        }
      },
      child: BlocBuilder<GetPostBloc, GetPostState>(
        builder: (context, state) {
          if (state is GetPostSuccess && state.list.isNotEmpty) {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                      width: double.infinity,
                      child: BlocProvider(
                        create: (context) => ReactToPostBloc(
                            postRepository: FirebasePostRepository()),
                        child: PostCard(
                          userName:
                              '${state.list[index].myUser.firstName.replaceFirst(state.list[index].myUser.firstName[0], state.list[index].myUser.firstName[0].toUpperCase())} ${state.list[index].myUser.lastName.replaceFirst(state.list[index].myUser.lastName[0], state.list[index].myUser.lastName[0].toUpperCase())}',
                          createdAt: state.list[index].createdAt,
                          postContent: state.list[index].postContent,
                          userPicture: !pictureChanged
                              ? state.list[index].myUser.picture
                              : picture,
                          postPicture: state.list[index].picture,
                          likes: state.list[index].likes,
                          postId: state.list[index].postId,
                          reactorId: context.read<AuthBloc>().state.user!.uid,
                          isLiked: state.list[index].peopleWhoLiked.contains(
                              context.read<AuthBloc>().state.user!.uid),
                        ),
                      )),
                );
              },
            );
          } else if (state is GetPostSuccess && state.list.isEmpty) {
            return const Center(
              child: Text('No posts added yet !'),
            );
          } else if (state is GetPostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetPostFailure) {
            return const Center(
              child: Text('Something went wrong :('),
            );
          }
          return Container();
        },
      ),
    );
  }
}
