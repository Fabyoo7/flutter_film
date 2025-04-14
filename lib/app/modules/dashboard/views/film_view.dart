import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class FilmView extends StatefulWidget {
  const FilmView({super.key});

  @override
  State<FilmView> createState() => _FilmViewState();
}

class _FilmViewState extends State<FilmView> {
  List<dynamic> movies = [];
  bool isLoading = true;

  final String apiKey = 'baaa37583292e10f8694ea5ad6323027';

  final Map<int, String> genreMap = {
    28: "Action",
    12: "Adventure",
    16: "Animation",
    35: "Comedy",
    80: "Crime",
    99: "Documentary",
    18: "Drama",
    10751: "Family",
    14: "Fantasy",
    36: "History",
    27: "Horror",
    10402: "Music",
    9648: "Mystery",
    10749: "Romance",
    878: "Sci-Fi",
    10770: "TV Movie",
    53: "Thriller",
    10752: "War",
    37: "Western",
  };

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=1'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          movies = (data['results'] as List)
              .whereType<Map<String, dynamic>>()
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      setState(() => isLoading = false);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('Gagal memuat data: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1B1F),
        elevation: 0,
        title: Text(
          "Daftar Film Populer",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Film Terbaru",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      itemCount: movies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.5,
                      ),
                      itemBuilder: (context, index) {
                        return MovieCard(
                          movie: movies[index],
                          genreMap: genreMap,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Map<String, dynamic> movie;
  final Map<int, String> genreMap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.genreMap,
  });

  @override
  Widget build(BuildContext context) {
    final posterPath = movie['poster_path'] as String?;
    final posterUrl = posterPath != null
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : null;

    final genreIds =
        (movie['genre_ids'] as List?)?.whereType<int>().toList() ?? [];
    final genreNames = genreIds
        .map((id) => genreMap[id] ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
    final genreDisplay = genreNames.isNotEmpty ? genreNames.join(', ') : '-';

    final releaseDate = movie['release_date'] as String?;
    final releaseYear = (releaseDate != null && releaseDate.isNotEmpty)
        ? releaseDate.substring(0, 4)
        : '-';

    final title = movie['title'] ?? '-';
    final voteAverage = movie['vote_average']?.toDouble() ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: posterUrl != null
              ? Image.network(
                  posterUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey,
                    child: const Icon(Icons.broken_image, color: Colors.white),
                  ),
                )
              : Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey,
                  child: const Icon(Icons.broken_image, color: Colors.white),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          "Genre: $genreDisplay",
          style: GoogleFonts.poppins(
            color: Colors.orangeAccent,
            fontSize: 10,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          "Tahun: $releaseYear",
          style: GoogleFonts.poppins(
            color: Colors.blueAccent,
            fontSize: 10,
          ),
        ),
        Text(
          "Rating: ${voteAverage.toStringAsFixed(1)}",
          style: GoogleFonts.poppins(
            color: Colors.greenAccent,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
