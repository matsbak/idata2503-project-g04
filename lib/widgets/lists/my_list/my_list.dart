import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/providers/lists_provider.dart';
import 'package:project/widgets/lists/my_list/my_list_item.dart';

class MyList extends ConsumerWidget {
  const MyList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(myListProvider);
    //return Expanded(
    //child: Container(
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (ctx, index) => MyListItem(
          movie: movies[index],
        ),
      ),
    );
    //);
  }
}
