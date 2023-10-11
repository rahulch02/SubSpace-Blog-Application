import 'package:blog_app/features/home/bloc/home_bloc.dart';
import 'package:blog_app/features/home/models/blog_product_data.dart';
import 'package:blog_app/features/home/ui/blog_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../data/favourite_blogs.dart';
import 'blog_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLoaded extends StatefulWidget {
  HomeLoaded({super.key, required this.bloc, required this.successState});
  final HomeBloc bloc;
  final HomeLoadingSuccessState successState;

  @override
  State<HomeLoaded> createState() => _HomeLoadedState();
}

class _HomeLoadedState extends State<HomeLoaded> {
  late List<BlogDataModel> _blogs;
  List<BlogDataModel> _results = [];
  ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    _blogs = widget.successState.blogs;
    _results = _blogs;
    super.initState();
  }

  void _handleSearch(String input) {
    late List<BlogDataModel> search = [];
    if (input.isEmpty) {
      search = _blogs;
    } else {
      for (var blog in _blogs) {
        if (blog.name.toLowerCase().contains(input.toLowerCase())) {
          setState(() {
            search.add(blog);
          });
        }
      }
    }
    setState(() {
      _results = search;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Rebuilt Home loaded screen');
    final AppBar appBar = AppBar(
        title: const Text('Blog Application'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                widget.bloc.add(HomeFavouritesNavigateEvent());
              },
              icon: const Icon(Icons.favorite_border))
        ]);
    final height =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: widget.bloc,
      buildWhen: (previous, current) =>
          current is HomeLoadingSuccessState ||
          previous is HomeLoadingSuccessState,
      listenWhen: (previous, current) => current is HomeActionState,
      listener: (context, state) {
        if (state is NavigateToBlogActionState) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlogPage(
                    blogDataModel: state.blogDataModel,
                  )));
        }
      },
      builder: (context, state) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (listScrollController.hasClients) {
              final position = listScrollController.position.minScrollExtent;
              listScrollController.jumpTo(position);
            }
          },
          isExtended: true,
          tooltip: "Scroll to Bottom",
          child: Icon(Icons.arrow_upward),
        ),
        body: Container(
          height: height,
          child: Column(
            children: [
              TextField(
                onChanged: _handleSearch,
                style: const TextStyle(
                  color: Color(0xff020202),
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xfff1f1f1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Search for Blogs...",
                  hintStyle: const TextStyle(
                      color: Color(0xffb2b2b2),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                      decorationThickness: 6),
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Colors.black,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    controller: listScrollController,
                    itemCount: _results.length,
                    itemBuilder: (context, index) => favouriteBlogs
                            .any((element) => element == _results[index])
                        ? InkWell(
                            onTap: () => widget.bloc.add(HomeBlogClickedEvent(
                                clickedBlog: _results[index])),
                            child: BlogTile(
                                blogDataModel: _results[index],
                                isFavourite: true),
                          )
                        : InkWell(
                            onTap: () => widget.bloc.add(HomeBlogClickedEvent(
                                clickedBlog: _results[index])),
                            child: BlogTile(
                                blogDataModel: _results[index],
                                isFavourite: false),
                          )),
              ),
            ],
          ),
        ),
        appBar: appBar,
      ),
    );
    ;
  }
}
