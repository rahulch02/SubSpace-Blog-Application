import 'package:blog_app/features/home/bloc/home_bloc.dart';
import 'package:blog_app/features/home/models/blog_product_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../data/favourite_blogs.dart';

class BlogPage extends StatefulWidget {
  BlogPage({super.key, required this.blogDataModel});
  late BlogDataModel blogDataModel;

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  late bool isFavourite;

  @override
  void initState() {
    isFavourite =
        favouriteBlogs.any((element) => element == widget.blogDataModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(
              widget.blogDataModel.imageUrl,
              height: 200, // Adjust the height as per your requirement
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: width - 50,
                        child: Text(
                          widget.blogDataModel.name,
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.visible),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: width - 100,
                    color: Colors.black,
                    height: 1,
                    margin: EdgeInsets.symmetric(vertical: 30),
                  ),
                  // SizedBox(height: 10.0),
                  Text(
                    'Sample Description of the blog',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
