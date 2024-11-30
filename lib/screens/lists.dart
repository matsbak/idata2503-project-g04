import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/providers/lists_provider.dart';
import 'package:project/widgets/lists/my_list/my_list.dart';
import 'package:project/widgets/lists/watchlist/watchlist.dart';

class ListsScreen extends ConsumerStatefulWidget {
  const ListsScreen({super.key});

  @override
  ConsumerState<ListsScreen> createState() {
    return _ListsScreenState();
  }
}

class _ListsScreenState extends ConsumerState<ListsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Watchlist and My List
      child: Column(
        children: [
          // TabBar for switching between Watchlist and My List
          TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(
                text: 'Watchlist',
                icon: Icon(Icons.watch_later_outlined),
              ),
              Tab(
                text: 'My List',
                icon: Icon(Icons.list_alt),
              ),
            ],
          ),
          // Expanded to display TabBarView with the respective lists
          Expanded(
            child: TabBarView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.all(16.0), // Adjust padding as needed
                  child: Watchlist(
                    movies: ref.watch(watchlistProvider),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.all(16.0), // Adjust padding as needed
                  child: MyList(
                    movies: ref.watch(myListProvider),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
