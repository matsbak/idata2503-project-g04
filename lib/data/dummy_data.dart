import 'package:project/models/movie.dart';

var dummyMovies = [
  Movie(
    title: 'Cars 2',
    description:
        'On the way to the biggest race of his life, a hotshot rookie race car gets stranded in a rundown town and learns that winning isn\'t everything in life.',
    rating: 5.0,
    genre: Genre.action,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BMTUzNTc3MTU3M15BMl5BanBnXkFtZTcwMzIxNTc3NA@@._V1_FMjpg_UX1000_.jpg',
  ),
  Movie(
    title: 'Wall-E',
    description:
        'A robot who is responsible for cleaning a waste-covered Earth meets another robot and falls in love with her. Together, they set out on a journey that will alter the fate of mankind.',
    rating: 4.5,
    genre: Genre.scienceFiction,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BMjExMTg5OTU0NF5BMl5BanBnXkFtZTcwMjMxMzMzMw@@._V1_.jpg',
  ),
  Movie(
    title: 'The Lord of the Rings: The Fellowship of the Ring',
    description:
        'A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.',
    rating: 5,
    genre: Genre.fantasy,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BNzIxMDQ2YTctNDY4MC00ZTRhLTk4ODQtMTVlOWY4NTdiYmMwXkEyXkFqcGc@._V1_.jpg',
  ),
  Movie(
    title: 'Spy Kids',
    description:
        'Two kids become spies in attempt to save their ex-spies parents from an evil mastermind. Armed with a bag of high tech gadgets, Carmen and Juni will bravely crisscross the globe on a mission to save their parents and maybe even the world.',
    rating: 2.5,
    genre: Genre.action,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BZTQ4YTM0MTAtZGNlMy00YmI5LThkOTktYjRjODI0M2EzMGU2XkEyXkFqcGc@._V1_.jpg',
  ),
  Movie(
    title: 'Jumanji: Welcome to the Jungle',
    description:
        'Four teenagers are sucked into a magical video game, and the only way they can escape is to work together to finish the game.',
    rating: 3.5,
    genre: Genre.comedy,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BZjI5MzdmODctYjA4NS00ZmMxLWJlOWUtOGVhMjA0OGMxMWYzXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg',
  ),
  Movie(
    title: 'Zoolander',
    description:
        'At the end of his career, a clueless fashion model is brainwashed to kill the Prime Minister of Malaysia.',
    rating: 3.0,
    genre: Genre.comedy,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BODI4NDY2NDM5M15BMl5BanBnXkFtZTgwNzEwOTMxMDE@._V1_.jpg',
  ),
  Movie(
    title: 'Star Wars: Episode IV - A New Hope',
    description:
        'Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee and two droids to save the galaxy from the Empires world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth Vader.',
    rating: 5.0,
    genre: Genre.scienceFiction,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BOGUwMDk0Y2MtNjBlNi00NmRiLTk2MWYtMGMyMDlhYmI4ZDBjXkEyXkFqcGc@._V1_.jpg',
  ),
  Movie(
    title: 'Dune: Part One',
    description:
        'A noble family becomes embroiled in a war for control over the galaxys most valuable asset while its heir becomes troubled by visions of a dark future.',
    rating: 4.0,
    genre: Genre.scienceFiction,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BNWIyNmU5MGYtZDZmNi00ZjAwLWJlYjgtZTc0ZGIxMDE4ZGYwXkEyXkFqcGc@._V1_.jpg',
  ),
  Movie(
    title: 'Pirates of the Caribbean: The Curse of the Black Pearl',
    description:
        'Blacksmith Will Turner teams up with eccentric pirate "Captain" Jack Sparrow to save Elizabeth Swann, the governors daughter and his love, from Jacks former pirate allies, who are now undead.',
    rating: 4.0,
    genre: Genre.fantasy,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BNDhlMzEyNzItMTA5Mi00YWRhLThlNTktYTQyMTA0MDIyNDEyXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg',
  ),
  Movie(
    title: 'Harry Potter and the Philosophers Stone',
    description:
        'An orphaned boy enrolls in a school of wizardry, where he learns the truth about himself, his family and the terrible evil that haunts the magical world.',
    rating: 4.0,
    genre: Genre.fantasy,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BNTU1MzgyMDMtMzBlZS00YzczLThmYWEtMjU3YmFlOWEyMjE1XkEyXkFqcGc@._V1_.jpg',
  ),
  Movie(
    title: 'It',
    description:
        'In the summer of 1989, a group of bullied kids band together to destroy a shape-shifting monster, which disguises itself as a clown and preys on the children of Derry, their small Maine town.',
    rating: 4.0,
    genre: Genre.horror,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BZGZmOTZjNzUtOTE4OS00OGM3LWJiNGEtZjk4Yzg2M2Q1YzYxXkEyXkFqcGc@._V1_.jpg',
  ),
  Movie(
    title: 'Die Hard',
    description:
        'A New York City police officer tries to save his estranged wife and several others taken hostage by terrorists during a Christmas party at the Nakatomi Plaza in Los Angeles.',
    rating: 4.5,
    genre: Genre.action,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BMGNlYmM1NmQtYWExMS00NmRjLTg5ZmEtMmYyYzJkMzljYWMxXkEyXkFqcGc@._V1_.jpg',
  ),
  Movie(
    title: 'Scary Movie',
    description:
        'A year after disposing of the body of a man they accidentally killed, a group of dumb teenagers are stalked by a bumbling serial killer.',
    rating: 3.5,
    genre: Genre.comedy,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BZGRmMGRhOWMtOTk3Ni00OTRjLTkyYTAtYzA1M2IzMGE3NGRkXkEyXkFqcGc@._V1_.jpg',
  ),
  Movie(
    title: 'Interstellar',
    description:
        'When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans.',
    rating: 5.0,
    genre: Genre.scienceFiction,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BYzdjMDAxZGItMjI2My00ODA1LTlkNzItOWFjMDU5ZDJlYWY3XkEyXkFqcGc@._V1_.jpg',
  ),
  Movie(
    title: 'Mamma Mia!',
    description:
        'Donna, an independent hotelier, is preparing for her daughters wedding with the help of two old friends. Meanwhile Sophie, the spirited bride, has a plan. She invites three men from her mothers past in hope of meeting her real father.',
    rating: 4.0,
    genre: Genre.drama,
    posterUrl:
        'https://m.media-amazon.com/images/M/MV5BMTA2MDU0MjM0MzReQTJeQWpwZ15BbWU3MDYwNzgwNzE@._V1_.jpg',
  ),
];
