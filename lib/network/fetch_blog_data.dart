import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/blog_data.dart';

Future<List<List<Map<String, dynamic>>>> fetchBlogs() async {
  const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
  const String adminSecret =
      '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';
  try {
    final response = await http.get(Uri.parse(url), headers: {
      'x-hasura-admin-secret': adminSecret,
    });
    var blogPagesJson = (jsonDecode(response.body)['blogs'] as List<dynamic>)
        .map((e) =>
            {"id": e['id'], "title": e['title'], "image_url": e['image_url']})
        .toList();
    if (response.statusCode == 200) {
      return [
        blogPagesJson,
        [
          {'string': response.statusCode.toString()}
        ]
      ];
    } else {
      return [
        [],
        [
          {'string': response.statusCode.toString()}
        ]
      ];
    }
  } catch (e) {
    return [
      [
        {'string': e.toString()}
      ]
    ];
  }
}
