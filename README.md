# IDATA2503 Project G04

Project in course
[IDATA2503 Mobile applications](https://www.ntnu.edu/studies/courses/IDATA2503#tab=omEmnet) at
[NTNU](https://www.ntnu.edu/). The project is done by group 4.

## Movie Rating App
A flutter/Dart application to rate movies. This app lets you expolore different movies and see their details. Find a movie you like and add it to your watchlist. Done watching? Move the movie to a completed list and give it a revivew.

## Installation
1. Clone the github repository:
```bash
    git clone https://github.com/matsbak/idata2503-project-g04.git
    cd your-repo-name
```
2. Install dependencies:
```bash
    flutter pub get
```

## How to run the application

1. Open the project folder in your preferred IDE
2. Open an Android emulator or connect to an Android device etc.
3. Run the command: 
```bash
    flutter run
```

#### Troubleshooting

If the project fails to build, repeat step 3.

### Project structure
The main components of the app is slit up into differnet pars:
-  <b>lib/data</b> Contains the dummy data used in the app

- <b>lib/models</b> Contains the data classes or objects inside the app. These classes represents the data, e.g. the movies or reviews

- <b>lib/screens</b>: Contains the different screens the user can navigate inside the app

- <b>lib/widgets</b> Contains all the different widgets used. These widget are either large widgets or reused in different areas inside the app.