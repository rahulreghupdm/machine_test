import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_machine_test/controller/fetch_controller.dart';

class ListPageView extends StatelessWidget {
  const ListPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post List")),
      body: Consumer<FetchController>(
        builder: (context, fetchController, child) {
          if (fetchController.errorMessage != null) {
            return Center(child: Text(fetchController.errorMessage!));
          }
          if (fetchController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (fetchController.posts.isEmpty) {
            return const Center(child: Text("No data Found"));
          }
          return RefreshIndicator(
            onRefresh: () => fetchController.fetchAndStorePosts(),
            child: ListView.builder(
              itemCount: fetchController.posts.length,
              itemBuilder: (context, index) {
                final post = fetchController.posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
