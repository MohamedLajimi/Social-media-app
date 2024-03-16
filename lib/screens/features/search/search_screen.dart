import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_application_1/blocs/follow_bloc/follow_bloc.dart';
import 'package:flutter_application_1/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:flutter_application_1/blocs/search_bloc/search_bloc.dart';
import 'package:flutter_application_1/components/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friendship_repository/friendship_repository.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.95,
                child: SearchBar(
                  onChanged: (value) {
                    context.read<SearchBloc>().add(SearchRequired(value));
                  },
                  elevation: MaterialStateProperty.all(0),
                  hintText: 'Search...',
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade100),
                  controller: searchController,
                  trailing: const [Icon(Icons.search)],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchFailure) {
                return const Center(
                  child: Text('Something went wrong :()'),
                );
              }
              if (state is SearchResult) {
                return state.searchResult.isNotEmpty
                    ? Expanded(
                        flex: 1,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: state.searchResult.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (BuildContext context) =>
                                            FollowBloc(
                                                friendshipRepository:
                                                    FirebaseFriendshipRepository()),
                                        child: ProfileScreen(
                                            imgUrl: state
                                                .searchResult[index].picture!,
                                            fullName:
                                                '${state.searchResult[index].firstName[0].toUpperCase()}${state.searchResult[index].firstName.substring(1)} ${state.searchResult[index].lastName[0].toUpperCase()}${state.searchResult[index].lastName.substring(1)}',
                                            followersNumber: 1578,
                                            followingNumber: 756,
                                            onPressed: () {
                                              context.read<FollowBloc>().add(
                                                  FollowRequested(
                                                      context
                                                          .read<AuthBloc>()
                                                          .state
                                                          .user!
                                                          .uid,
                                                      state.searchResult[index]
                                                          .id));
                                            },
                                            postsNumber: 563,
                                            isMyAccount: false),
                                      ),
                                    ));
                              },
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 3),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(state
                                            .searchResult[index].picture!)),
                                    shape: BoxShape.circle),
                              ),
                              title: Text(
                                '${state.searchResult[index].firstName[0].toUpperCase()}${state.searchResult[index].firstName.substring(1)} ${state.searchResult[index].lastName[0].toUpperCase()}${state.searchResult[index].lastName.substring(1)}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Text('Users not found :('),
                      );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
