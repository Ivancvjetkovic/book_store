import 'dart:convert';
import 'package:book_store/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HttpService {
  final String baseApi = 'fakerapi.it';
  final String bookEndpoint = '/api/v1/books';
  // final Uri bookUrl = Uri.http('jsonplaceholder.typicode.com', '/posts');

  Future<List<BookPosts>> getBookPosts({int quantity = 10}) async {
    Response res =
        await get(Uri.http(baseApi, bookEndpoint, {'_quantity': '$quantity'}));

    print(res.body);
    // print(jsonDecode(res.body)['data'].map(
    //   (json) {
    //     BookPosts.fromJson(json);
    //   },
    // ).toList()[0]);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)['data'];
      List<BookPosts> bookPosts =
          body.map((dynamic item) => BookPosts.fromJson(item)).toList();
      return bookPosts;
    } else {
      throw 'Cant get posts';
    }
  }
}
