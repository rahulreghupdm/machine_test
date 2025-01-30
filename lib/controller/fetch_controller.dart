import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sample_machine_test/controller/db_helper.dart';

import 'package:sample_machine_test/model/post_model.dart';

class FetchController with ChangeNotifier {
  List<Post> _posts = [];
  String? _errorMessage;

  List<Post> get posts => _posts;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void _setloading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  FetchController() {
    fetchAndStorePosts();
  }

  void _setPosts(List<Post> post) {
    _posts = post;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _posts = [];
    notifyListeners();
  }

  Future<void> fetchAndStorePosts() async {
    const apiUrl = 'https://jsonplaceholder.typicode.com/posts';

    try {
      _setloading(true);
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<Post> postList =
            jsonResponse.map((data) => Post.fromJson(data)).toList();

        final dbHelper = DatabaseHelper.instance;
        await dbHelper.clearDatabase();

        for (var post in postList) {
          await dbHelper.insertPost(post);
        }
        loadPostsFromDatabase().then((_) {
          _setloading(false);
        }).onError((error, stackTrace) {
          _setloading(false);
        });
      } else {
        _setloading(false);

        _setError("Failed to load posts. Server error: ${response.statusCode}");
      }
    } catch (e) {
      _setloading(false);

      _setError("No Internet or API issue: $e");
    }
  }

  Future<void> loadPostsFromDatabase() async {
    try {
      final dbHelper = DatabaseHelper.instance;

      List<Post> dbPosts = await dbHelper.fetchPosts();
      if (dbPosts.isNotEmpty) {
        _setPosts(dbPosts);
      } else {
        _setError("No data found in local storage.");
      }
    } catch (e) {
      _setError("Database error: $e");
    }
  }
}
