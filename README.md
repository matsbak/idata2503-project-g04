# IDATA2503 Project G04

Project in course
[IDATA2503 Mobile applications](https://www.ntnu.edu/studies/courses/IDATA2503#tab=omEmnet) at
[NTNU](https://www.ntnu.edu/). The project is done by group 4.

## Movie Rating App

A Flutter/Dart application to rate movies. This app lets you expolore different movies and see
their details. Find a movie you like and add it to your watchlist. Done watching? Move the movie to
a completed list and give it a revivew.

The application uses the API provided by [TMBD](https://www.themoviedb.org/) as the source of data
and images. See the [TMBD API](https://developer.themoviedb.org/docs/getting-started) documentation
for more information.

## Installation

1. Clone the github repository:

```bash
  git clone https://github.com/matsbak/idata2503-project-g04.git
  cd idata2503-project-g04
```
2. Install dependencies:

```bash
  flutter pub get
```

## How to run

1. Open the project folder in your preferred IDE
2. Open an emulator or connect to a device etc.
3. Run the command ```flutter run```

#### Troubleshooting

If the project fails to build, repeat step 3.

### Project structure
The main components of the app is slit up into differnet parts:

- <b>lib/data</b> contains the dummy data used in the app.

- <b>lib/models</b> contains the data classes or objects inside the app. These classes represents
the data, e.g. the movies or reviews.

- <b>lib/screens</b> contains the different screens the user can navigate inside the app.

- <b>lib/widgets</b> contains all the different widgets used. These widgets are either large
widgets or reused in different areas inside the app.
