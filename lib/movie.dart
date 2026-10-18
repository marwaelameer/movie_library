class Movie {
final String title;
final String genre;
final int year;
final double rating;
final String image;
final String description;

const Movie({
required this.title,
required this.genre,
required this.year,
required this.rating,
required this.image,
required this.description,
});
}

final List<Movie> movies = [
Movie(
title: 'Inception',
genre: 'Sci-Fi',
year: 2010,
rating: 8.8,
image: 'assets/posters/inception.jpg',
description: 'A thief enters dreams to steal secrets.',
),
Movie(
title: 'Interstellar',
genre: 'Sci-Fi',
year: 2014,
rating: 8.7,
image: 'assets/posters/interstellar.jpg',
description: 'A journey through space to save humanity.',
),
Movie(
title: 'The Dark Knight',
genre: 'Action',
year: 2008,
rating: 9.0,
image: 'assets/posters/dark_knight.jpg',
description: 'Batman faces the dangerous Joker.',
),
Movie(
title: 'Avatar',
genre: 'Fantasy',
year: 2009,
rating: 7.9,
image: 'assets/posters/avatar.jpg',
description: 'A soldier discovers the world of Pandora.',
),
Movie(
title: 'Titanic',
genre: 'Romance',
year: 1997,
rating: 7.9,
image: 'assets/posters/titanic.jpg',
description: 'A love story aboard a famous ship.',
),
Movie(
title: 'Joker',
genre: 'Drama',
year: 2019,
rating: 8.3,
image: 'assets/posters/joker.jpg',
description: 'A troubled man transforms into the Joker.',
),
Movie(
title: 'The Avengers',
genre: 'Action',
year: 2012,
rating: 8.0,
image: 'assets/posters/avengers.jpg',
description: 'Heroes team up to protect the world.',
),
Movie(
title: 'Finding Nemo',
genre: 'Animation',
year: 2003,
rating: 8.2,
image: 'assets/posters/nemo.jpg',
description: 'A clownfish searches the ocean for his son.',
),
];
