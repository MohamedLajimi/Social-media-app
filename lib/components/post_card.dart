import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/react_to_post_bloc/react_to_post_bloc.dart';
import 'package:flutter_application_1/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCard extends StatefulWidget {
  final String postId;
  final String reactorId;
  final String userName;
  final String? userPicture;
  final String postContent;
  final String postPicture;
  final DateTime createdAt;
  int likes;
  bool isLiked;

  PostCard(
      {super.key,
      required this.userName,
      required this.userPicture,
      required this.postContent,
      required this.createdAt,
      required this.postPicture,
      required this.likes,
      required this.postId,
      required this.reactorId,
      required this.isLiked});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        surfaceTintColor: tertiaryColor,
        elevation: 5,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(widget.userPicture!),
                            fit: BoxFit.cover)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        widget.createdAt.toString().substring(0, 16),
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
              widget.postContent != ""
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.postContent,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.postPicture != ""
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            width: 350,
                            height: 250,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    widget.postPicture,
                                  ),
                                  fit: BoxFit.cover,
                                )))
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 5,
              ),
              BlocListener<ReactToPostBloc, ReactToPostState>(
                  listener: (context, state) {
                    if (state is PostIsLiked) {
                      setState(() {
                        widget.likes += 1;
                        widget.isLiked = state.isLiked;
                      });
                    }
                    if (state is PostIsUnliked) {
                      setState(() {
                        widget.likes -= 1;
                        widget.isLiked = state.isLiked;
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<ReactToPostBloc>().add(UserReactedToPost(
                              widget.postId, widget.reactorId));
                        },
                        icon: widget.isLiked
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_outline),
                        color: primaryColor,
                        iconSize: 30,
                      ),
                      Text(
                        '${widget.likes}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ))
            ])));
  }
}
