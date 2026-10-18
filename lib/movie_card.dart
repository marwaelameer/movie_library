import 'package:flutter/material.dart';
import 'movie.dart';

const _card = Color(0xFF101831);
const _stroke = Color(0xFF222D50);
const _purple = Color(0xFFBE83F7);
const _pink = Color(0xFFEF55B8);
const _muted = Color(0xFFA5B0D8);

class MovieCard extends StatefulWidget {
  final Movie movie;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  const MovieCard({super.key, required this.movie, required this.isFavorite, required this.onFavoritePressed});
  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, hovered ? -3 : 0, 0),
        decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: hovered ? _purple : _stroke),
          boxShadow: [if (hovered) BoxShadow(color: _purple.withOpacity(.12), blurRadius: 18, spreadRadius: 1)]),
        clipBehavior: Clip.antiAlias,
        child: Padding(padding: const EdgeInsets.all(10), child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ClipRRect(borderRadius: BorderRadius.circular(11), child: SizedBox(width: 102, child: Stack(fit: StackFit.expand, children: [
            Container(color: const Color(0xFF1A2140)),
            Image.asset(movie.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.movie_outlined, color: _purple, size: 36))),
            Positioned(
              left: 5,
              top: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xD9101428),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFFFC43D), size: 13),
                    const SizedBox(width: 2),
                    Text(
                      movie.rating.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ]))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Text(movie.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFFE9E5FF), fontSize: 14, fontWeight: FontWeight.w800, height: 1.15))),
              InkWell(onTap: widget.onFavoritePressed, borderRadius: BorderRadius.circular(20), child: Padding(padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Icon(widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 19, color: widget.isFavorite ? _pink : _muted))),
            ]),
            const SizedBox(height: 5),
            Text('${movie.year}  •  ${movie.genre}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _muted, fontSize: 11)),
            const SizedBox(height: 9),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF282147), borderRadius: BorderRadius.circular(20)),
              child: Text(movie.genre, style: const TextStyle(color: _purple, fontSize: 10, fontWeight: FontWeight.w600))),
            const SizedBox(height: 8),
            Expanded(child: Text(movie.description, maxLines: 3, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFFB6BFDF), fontSize: 11, height: 1.35))),
            const SizedBox(height: 7),
            Row(children: [
              Expanded(child: FilledButton.icon(onPressed: () => _showDetails(context), icon: const Icon(Icons.play_arrow_rounded, size: 15), label: const Text('Details', maxLines: 1),
                style: FilledButton.styleFrom(backgroundColor: _purple, foregroundColor: const Color(0xFF1A1030), padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8), textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), minimumSize: const Size(0, 32)))),
              const SizedBox(width: 6),
              IconButton(tooltip: 'Movie info', onPressed: () => _showDetails(context), padding: EdgeInsets.zero, constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                icon: const Icon(Icons.info_outline_rounded, color: _muted, size: 18)),
            ]),
          ])),
        ])),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF111831),
      title: Text(widget.movie.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      content: Text('${widget.movie.year}  •  ${widget.movie.genre}\n\nRating: ${widget.movie.rating}\n\n${widget.movie.description}',
        style: const TextStyle(color: Color(0xFFD0D6F0), height: 1.5)),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close', style: TextStyle(color: _purple)))],
    ));
  }
}
