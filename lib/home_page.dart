import 'package:flutter/material.dart';
import 'movie.dart';
import 'movie_card.dart';

const _bg = Color(0xFF080D20);
const _panel = Color(0xFF101831);
const _border = Color(0xFF222D50);
const _purple = Color(0xFFBE83F7);
const _pink = Color(0xFFEF55B8);
const _muted = Color(0xFFA5B0D8);

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = '';
  String selectedSection = 'Home';
  String selectedGenre = 'All';
  bool favoritesOnly = false;
  final Set<String> favoriteMovies = {};

  @override
  Widget build(BuildContext context) {
    final genres = <String>{'All', ...movies.map((m) => m.genre)}.toList();
    final filtered = movies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(searchText.toLowerCase()) ||
          movie.genre.toLowerCase().contains(searchText.toLowerCase());
      final matchesGenre = selectedGenre == 'All' || movie.genre == selectedGenre;
      final matchesFavorites = !favoritesOnly || favoriteMovies.contains(movie.title);
      return matchesSearch && matchesGenre && matchesFavorites;
    }).toList();

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1000;
          return Row(children: [
            if (wide) _sidebar(genres),
            Expanded(child: Column(children: [
              _topBar(wide),
              Expanded(child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(wide ? 26 : 16, 16, wide ? 26 : 16, 28),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _hero(wide),
                  const SizedBox(height: 24),
                  if (!wide) _mobileFilters(genres),
                  Row(children: [
                    const Icon(Icons.auto_awesome, color: _purple, size: 23),
                    const SizedBox(width: 10),
                    Text(favoritesOnly ? 'Your Favorites' : selectedGenre == 'All' ? 'Popular Movies' : selectedGenre,
                      style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: Color(0xFFE9E5FF))),
                    const Spacer(),
                    Text('${filtered.length} titles', style: const TextStyle(color: _muted, fontSize: 12)),
                    const SizedBox(width: 12),
                    TextButton.icon(
                      onPressed: () => setState(() { selectedGenre = 'All'; favoritesOnly = false; selectedSection = 'Movies'; }),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('View All'),
                      style: TextButton.styleFrom(foregroundColor: _purple),
                    ),
                  ]),
                  const SizedBox(height: 14),
                  if (filtered.isEmpty)
                    const Padding(padding: EdgeInsets.all(48), child: Center(child: Column(children: [
                      Icon(Icons.movie_filter_outlined, size: 48, color: _purple),
                      SizedBox(height: 12), Text('No movies found', style: TextStyle(color: _muted, fontSize: 16)),
                    ])))
                  else
                    LayoutBuilder(builder: (context, gridConstraints) {
                      final columns = gridConstraints.maxWidth >= 1050 ? 3 : gridConstraints.maxWidth >= 650 ? 2 : 1;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          mainAxisExtent: 232,
                        ),
                        itemBuilder: (context, index) {
                          final movie = filtered[index];
                          return MovieCard(
                            movie: movie,
                            isFavorite: favoriteMovies.contains(movie.title),
                            onFavoritePressed: () => setState(() {
                              if (!favoriteMovies.add(movie.title)) favoriteMovies.remove(movie.title);
                            }),
                          );
                        },
                      );
                    }),
                ]),
              )),
            ])),
          ]);
        }),
      ),
    );
  }

  Widget _topBar(bool wide) => Container(
    padding: EdgeInsets.symmetric(horizontal: wide ? 26 : 16, vertical: 14),
    decoration: const BoxDecoration(color: Color(0xFF0C1229), border: Border(bottom: BorderSide(color: _border))),
    child: Row(children: [
      if (!wide) ...[
        const Icon(Icons.movie_creation_rounded, color: _purple, size: 30), const SizedBox(width: 9),
        const Text('Movie Library', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white)),
        const SizedBox(width: 16),
      ],
      if (wide) const SizedBox(width: 4),
      Expanded(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 560), child: TextField(
        onChanged: (value) => setState(() => searchText = value),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search for movies...', hintStyle: const TextStyle(color: Color(0xFF7F8AB5)),
          prefixIcon: const Icon(Icons.search, color: _purple), filled: true, fillColor: const Color(0xFF191E3C),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
      ))),
      const SizedBox(width: 16),
      Container(width: 40, height: 40, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF39266E)),
        child: const Icon(Icons.person, color: _purple)),
    ]),
  );

  Widget _sidebar(List<String> genres) => Container(
    width: 226, color: const Color(0xFF0A1024), padding: const EdgeInsets.fromLTRB(16, 22, 14, 16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [Icon(Icons.movie_creation_rounded, color: _purple, size: 32), SizedBox(width: 9),
        Text('Movie Library', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic))]),
      const SizedBox(height: 34),
      _nav('Home', Icons.home_rounded, onTap: () => setState(() { selectedSection = 'Home'; favoritesOnly = false; selectedGenre = 'All'; })),
      _nav('Movies', Icons.local_movies_rounded, onTap: () => setState(() { selectedSection = 'Movies'; favoritesOnly = false; selectedGenre = 'All'; })),
      _nav('Favorites', Icons.favorite_rounded, onTap: () => setState(() { favoritesOnly = true; selectedSection = 'Favorites'; })),
      _nav('Watchlist', Icons.bookmark_rounded, onTap: () => setState(() { favoritesOnly = true; selectedSection = 'Watchlist'; })),
      _nav('Genres', Icons.grid_view_rounded, onTap: () => setState(() { selectedGenre = 'All'; favoritesOnly = false; })),
      const Padding(padding: EdgeInsets.symmetric(vertical: 18), child: Divider(color: _border)),
      const Padding(padding: EdgeInsets.only(left: 10, bottom: 12), child: Text('GENRES', style: TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.4))),
      ...genres.where((g) => g != 'All').map((g) => InkWell(
        borderRadius: BorderRadius.circular(10), onTap: () => setState(() { selectedGenre = g; favoritesOnly = false; }),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9), child: Row(children: [
          Container(width: 9, height: 9, decoration: BoxDecoration(color: _genreColor(g), shape: BoxShape.circle)),
          const SizedBox(width: 12), Expanded(child: Text(g, style: TextStyle(color: selectedGenre == g ? _purple : const Color(0xFFD6D9F2), fontSize: 13))),
        ])),
      )),
      const Spacer(),
      const Icon(Icons.movie_filter_rounded, size: 48, color: Color(0xFF6C4E9C)),
      const SizedBox(height: 8), const Text('Good Movies\nBetter Days', textAlign: TextAlign.center,
        style: TextStyle(color: _purple, fontSize: 19, fontStyle: FontStyle.italic, height: 1.35)),
    ]),
  );

  Widget _nav(String label, IconData icon, {required VoidCallback onTap}) {
    final active = selectedSection == label;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF392568) : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: active ? Colors.white : const Color(0xFFA5A5D2)),
              const SizedBox(width: 13),
              Text(
                label,
                style: TextStyle(
                  color: active ? Colors.white : const Color(0xFFD0D3F0),
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mobileFilters(List<String> genres) => Padding(padding: const EdgeInsets.only(bottom: 18), child: SingleChildScrollView(
    scrollDirection: Axis.horizontal, child: Row(children: genres.map((g) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(
      label: Text(g), selected: selectedGenre == g, onSelected: (_) => setState(() { selectedGenre = g; favoritesOnly = false; }),
      selectedColor: const Color(0xFF392568), backgroundColor: _panel, labelStyle: TextStyle(color: selectedGenre == g ? Colors.white : _muted), side: const BorderSide(color: _border),
    ))).toList()),
  ));

  Widget _hero(bool wide) => Container(
    height: wide ? 220 : 190, width: double.infinity, clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFF34244F)),
      gradient: const LinearGradient(colors: [Color(0xFF25133D), Color(0xFF111831), Color(0xFF35152F)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
    child: Stack(children: [
      Positioned(right: -8, top: -36, child: Icon(Icons.movie_creation_rounded, size: wide ? 245 : 180, color: Colors.white.withOpacity(.045))),
      Positioned(left: 22, top: 25, child: Icon(Icons.auto_awesome, color: _pink.withOpacity(.55), size: 30)),
      Padding(padding: EdgeInsets.all(wide ? 28 : 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('DISCOVER SOMETHING AMAZING', style: TextStyle(color: _pink, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
        const SizedBox(height: 10),
        Text('Your Next Favorite Movie', style: TextStyle(color: Colors.white, fontSize: wide ? 31 : 24, fontWeight: FontWeight.w900, height: 1.1)),
        const SizedBox(height: 10),
        const Text('A world of unforgettable stories, just a click away.', style: TextStyle(color: Color(0xFFD0D1ED), fontSize: 13)),
        const SizedBox(height: 18),
        FilledButton.icon(onPressed: () => setState(() { selectedGenre = 'All'; favoritesOnly = false; selectedSection = 'Movies'; }),
          icon: const Icon(Icons.play_arrow_rounded, size: 18), label: const Text('Explore Movies'),
          style: FilledButton.styleFrom(backgroundColor: _purple, foregroundColor: const Color(0xFF1A1030), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12))),
      ])),
    ]),
  );

  Color _genreColor(String genre) {
    switch (genre.toLowerCase()) {
      case 'action': return const Color(0xFFFF426D);
      case 'comedy': return const Color(0xFFF2A1A1);
      case 'drama': return const Color(0xFFB45BFA);
      case 'horror': return const Color(0xFF43C99B);
      case 'sci-fi': return const Color(0xFF39A5FF);
      case 'romance': return _pink;
      default: return _purple;
    }
  }
}
