import '../models/movie.dart';

const featuredMovie = Movie(
  title: 'Beyond the Stars',
  genre: 'Sci-Fi • Adventure',
  year: '2026',
  rating: 8.9,
  description: 'An extraordinary journey into the unknown begins.',
  imageUrl: 'https://picsum.photos/id/1018/800/1200',
  videoUrl:
      'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
);

const trendingMovies = <Movie>[
  Movie(
    title: 'Midnight Run',
    genre: 'Action',
    year: '2026',
    rating: 8.7,
    description: 'One night. One impossible mission.',
    imageUrl: 'https://picsum.photos/id/1071/500/750',
    videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
  ),
  Movie(
    title: 'The Last Signal',
    genre: 'Mystery',
    year: '2025',
    rating: 9.1,
    description: 'A message changes everything.',
    imageUrl: 'https://picsum.photos/id/1015/500/750',
    videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
  ),
  Movie(
    title: 'Wild Horizon',
    genre: 'Adventure',
    year: '2026',
    rating: 8.5,
    description: 'The world is waiting to be discovered.',
    imageUrl: 'https://picsum.photos/id/1016/500/750',
    videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
  ),
  Movie(
    title: 'Crimson Night',
    genre: 'Thriller',
    year: '2025',
    rating: 8.3,
    description: 'Every secret has a shadow.',
    imageUrl: 'https://picsum.photos/id/1003/500/750',
    videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
  ),
];

const newReleases = <Movie>[
  Movie(
    title: 'Ocean Echoes',
    genre: 'Drama',
    year: '2026',
    rating: 8.8,
    description: 'A story of courage and connection.',
    imageUrl: 'https://picsum.photos/id/1011/500/750',
    videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
  ),
  Movie(
    title: 'Golden Hour',
    genre: 'Romance',
    year: '2026',
    rating: 8.2,
    description: 'Some moments last forever.',
    imageUrl: 'https://picsum.photos/id/1000/500/750',
    videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
  ),
  Movie(
    title: 'Neon City',
    genre: 'Sci-Fi',
    year: '2026',
    rating: 8.6,
    description: 'Tomorrow is closer than you think.',
    imageUrl: 'https://picsum.photos/id/1048/500/750',
    videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
  ),
];

const allMovies = <Movie>[featuredMovie, ...trendingMovies, ...newReleases];
