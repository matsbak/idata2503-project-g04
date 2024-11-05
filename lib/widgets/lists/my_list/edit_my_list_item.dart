import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/models/rating.dart';

class EditMyListItem extends StatefulWidget {
  const EditMyListItem(this.movie, {super.key});

  final Movie movie;

  @override
  State<EditMyListItem> createState() => _EditMyListItemState();
}

class _EditMyListItemState extends State<EditMyListItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredScore = 1.0;
  var _enteredComment = "";
  var userId = "testUser";

  /// Saves/adds a new rating to the selected movie and updates the movie
  void _saveRating() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newRating = Rating(
        score: _enteredScore,
        comment: _enteredComment,
        userId: userId,
        date: DateTime.now(),
      );
      widget.movie.addReview(newRating);
      Navigator.of(context).pop(newRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Give ${widget.movie.title} a Rating"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<double>(
                decoration: const InputDecoration(
                  label: Text("Rating/Score"),
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                value: _enteredScore,
                items: List.generate(
                  10,
                  (index) => DropdownMenuItem(
                    value: (index + 1) * 0.5,
                    child: Text(((index + 1) * 0.5).toString()),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _enteredScore = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value <= 0) {
                    return "Must be a valid positive number between 0.5 - 5";
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredScore = value!;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                maxLength: 100,
                decoration: const InputDecoration(
                  label: Text("Write a review"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 100) {
                    return "Must be between 1 and 100 characters";
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredComment = value!;
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: _saveRating,
                    child: const Text("Save Rating"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
