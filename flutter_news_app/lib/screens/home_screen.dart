import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_news_app/providers/news_provider.dart';
import 'package:flutter_news_app/widgets/article_list_item.dart';
import 'package:flutter_news_app/widgets/error_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchTopHeadlines();
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<NewsProvider>(context, listen: false).toggleDarkMode();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
              onSubmitted: (value) {
                Provider.of<NewsProvider>(context, listen: false).searchNews(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<NewsProvider>(
              builder: (context, newsProvider, child) {
                if (newsProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (newsProvider.error.isNotEmpty) {
                  return ErrorView(
                    error: newsProvider.error,
                    onRetry: () {
                      newsProvider.fetchTopHeadlines();
                    },
                  );
                }
                
                if (newsProvider.articles.isEmpty) {
                  return const Center(child: Text('No articles found'));
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    await newsProvider.fetchTopHeadlines();
                  },
                  child: ListView.builder(
                    itemCount: newsProvider.articles.length,
                    itemBuilder: (context, index) {
                      return ArticleListItem(article: newsProvider.articles[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
