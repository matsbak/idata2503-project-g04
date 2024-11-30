import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/forms/auth_utils.dart';

import 'package:project/models/movie.dart';
import 'package:project/models/rating.dart';
import 'package:project/providers/lists_provider.dart';
import 'package:project/service/firebase_service.dart';
import 'package:project/widgets/starbuilder.dart';

// TODO Make main content area scrollable instead of entire modal
class MyListModal extends ConsumerStatefulWidget {
  const MyListModal(this.movie, {super.key});

  final Movie movie;

  @override
  ConsumerState<MyListModal> createState() {
    return _MyListModalState();
  }
}

class _MyListModalState extends ConsumerState<MyListModal> {
  final _formKey = GlobalKey<FormState>();
  var _enteredScore = 0.5;
  var _enteredReview = '';
  final _userId = 'test User';

  void _removeFromMyList(String title) async {
    try {
      final uid = getUidIfLoggedIn(ref);
      if (uid != null) {
        await FirebaseService.removeMovieFromMylist(widget.movie.id, uid);
        ref.read(myListProvider.notifier).removeFromMyList(widget.movie);

        Navigator.pop(context);

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$title removed from my list'),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to remove movie fomr mylist: $error'),
      ));
    }
  }

  /// Saves user input and adds review to backend.
  void _saveRating() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newRating = Rating(
        score: _enteredScore,
        review: _enteredReview,
        userId: _userId,
        date: DateTime.now(),
      );

      try {
        await FirebaseService.addRatingToMovie(widget.movie.id, newRating);
        Navigator.of(context).pop(newRating);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save rating: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20.0,
      ),
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                size: 28.0,
                color: Colors.white,
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 24.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 250.0,
                  child: widget.movie.poster,
                ),
              ),
            ),
            Text(
              widget.movie.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                StarBuilder(rating: _enteredScore),
                const SizedBox(width: 8),
                Text(
                  _enteredScore.toString(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                )
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Score',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Slider(
                    value: _enteredScore,
                    min: 0.5,
                    max: 5.0,
                    divisions: 9,
                    label: _enteredScore.toString(),
                    onChanged: (value) {
                      setState(() {
                        _enteredScore = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Add a review?',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    maxLength: 100,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ),
                    validator: (value) {
                      if (value == null || value.trim().length > 100) {
                        return 'Must be at most 100 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredReview = value!;
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          _removeFromMyList(widget.movie.title);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.errorContainer,
                        ),
                      ),
                      const Spacer(),
                      FilledButton.tonal(
                        onPressed: () => _formKey.currentState!.reset(),
                        style: FilledButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Clear'),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      FilledButton(
                        onPressed: _saveRating,
                        child: const Text(
                          'Save',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
