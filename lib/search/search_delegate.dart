import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () => query = '', icon: const Icon(Icons.clear_outlined))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('Build results');
  }

  Widget _emptyContainer() {
    return Container(
        child: const Center(
      child: Icon(
        Icons.movie_creation_outlined,
        color: Colors.black38,
        size: 150,
      ),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
        future: moviesProvider.searchMovies(query),
        builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
          if (!snapshot.hasData) {
            return _emptyContainer();
          }

          final movies = snapshot.data;

          return ListView.builder(
              itemCount: movies?.length,
              itemBuilder: (_, index) => _MovieItem(movies![index]));
        });
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem(this.movie);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'),
          image: NetworkImage(movie.fullPosterImg),
          width: 50,
          fit: BoxFit.contain,
        ),
        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        onTap: () {
          Navigator.pushNamed(context, 'details', arguments: movie);
        });
  }
}
