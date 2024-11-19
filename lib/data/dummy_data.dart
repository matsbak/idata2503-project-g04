import 'package:flutter/material.dart';

import 'package:project/models/movie.dart';
import 'package:project/models/rating.dart';

var dummyMovies = [
  Movie(
    id: 1,
    title: 'Cars',
    description:
        'On the way to the biggest race of his life, a hotshot rookie race car gets stranded in a rundown town and learns that winning isnt everything in life.',
    ratings: [
      Rating(
        score: 5.0,
        comment: "Bil",
        userId: "Andre",
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 2,
    title: 'Cars 2',
    description:
        'On the way to the biggest race of his life, a hotshot rookie race car gets stranded in a rundown town and learns that winning isn\'t everything in life.',
    ratings: [
      Rating(
        score: 4.5,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 4.0,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 5.0,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 3,
    title: 'Wall-E',
    description:
        'A robot who is responsible for cleaning a waste-covered Earth meets another robot and falls in love with her. Together, they set out on a journey that will alter the fate of mankind.',
    ratings: [
      Rating(
        score: 4.5,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 4.0,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 5.0,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 4,
    title: 'The Lord of the Rings: The Fellowship of the Ring',
    description:
        'A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.',
    ratings: [
      Rating(
        score: 4.5,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 4.0,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 5.0,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 5,
    title: 'Spy Kids',
    description:
        'Two kids become spies in attempt to save their ex-spies parents from an evil mastermind. Armed with a bag of high tech gadgets, Carmen and Juni will bravely crisscross the globe on a mission to save their parents and maybe even the world.',
    ratings: [
      Rating(
        score: 1,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 3,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 2.5,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 6,
    title: 'Jumanji: Welcome to the Jungle',
    description:
        'Four teenagers are sucked into a magical video game, and the only way they can escape is to work together to finish the game.',
    ratings: [
      Rating(
        score: 2.5,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 3.0,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 3.5,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 7,
    title: 'Zoolander',
    description:
        'At the end of his career, a clueless fashion model is brainwashed to kill the Prime Minister of Malaysia.',
    ratings: [
      Rating(
        score: 3.5,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 3.0,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 2.0,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 8,
    title: 'Star Wars: Episode IV - A New Hope',
    description:
        'Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee and two droids to save the galaxy from the Empires world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth Vader.',
    ratings: [
      Rating(
        score: 4.5,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 4.5,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 5.0,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 5.0,
        comment: "Nice movie",
        userId: 'user4',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 9,
    title: 'Dune: Part One',
    description:
        'A noble family becomes embroiled in a war for control over the galaxys most valuable asset while its heir becomes troubled by visions of a dark future.',
    ratings: [
      Rating(
        score: 4.5,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 4.0,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 3.5,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 10,
    title: 'Pirates of the Caribbean: The Curse of the Black Pearl',
    description:
        'Blacksmith Will Turner teams up with eccentric pirate "Captain" Jack Sparrow to save Elizabeth Swann, the governors daughter and his love, from Jacks former pirate allies, who are now undead.',
    ratings: [
      Rating(
        score: 3.5,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 4.0,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 4.5,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 11,
    title: 'Harry Potter and the Philosophers Stone',
    description:
        'An orphaned boy enrolls in a school of wizardry, where he learns the truth about himself, his family and the terrible evil that haunts the magical world.',
    ratings: [
      Rating(
        score: 3.5,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 4.0,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 4.5,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 12,
    title: 'It',
    description:
        'In the summer of 1989, a group of bullied kids band together to destroy a shape-shifting monster, which disguises itself as a clown and preys on the children of Derry, their small Maine town.',
    ratings: [
      Rating(
        score: 4.5,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 4.0,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 3.0,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 13,
    title: 'Die Hard',
    description:
        'A New York City police officer tries to save his estranged wife and several others taken hostage by terrorists during a Christmas party at the Nakatomi Plaza in Los Angeles.',
    ratings: [
      Rating(
        score: 4.5,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 4.0,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 5.0,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 14,
    title: 'Scary Movie',
    description:
        'A year after disposing of the body of a man they accidentally killed, a group of dumb teenagers are stalked by a bumbling serial killer.',
    ratings: [
      Rating(
        score: 2.5,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 3.0,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 3.5,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
   poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 15,
    title: 'Interstellar',
    description:
        'When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans.',
    ratings: [
      Rating(
        score: 4.5,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 5.0,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 5.0,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
  Movie(
    id: 16,
    title: 'Mamma Mia!',
    description:
        'Donna, an independent hotelier, is preparing for her daughters wedding with the help of two old friends. Meanwhile Sophie, the spirited bride, has a plan. She invites three men from her mothers past in hope of meeting her real father.',
    ratings: [
      Rating(
        score: 4.5,
        comment: "Nice movie",
        userId: 'user1',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Rating(
        score: 4.0,
        comment: "Nice movie",
        userId: 'user2',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Rating(
        score: 5.0,
        comment: "Nice movie",
        userId: 'user3',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    poster: Image.asset('wall-e.jpg'),
  ),
];
