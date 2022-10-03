import 'package:e_imavi/model/model_attendances.dart';
import 'package:e_imavi/pages/detailResource.dart';
import 'package:e_imavi/provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:simple_moment/simple_moment.dart';

class ListReources extends ConsumerWidget {
  final String resourcesLabel;
  ListReources({Key? key, required this.resourcesLabel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _listArticles = ref.watch(articlesProvider);
    final _listNews = ref.watch(newsProvider);
    final _listPrayers = ref.watch(prayersProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(resourcesLabel),
          centerTitle: true,
          leading: BackButton(),
          backgroundColor: Color.fromARGB(255, 106, 0, 124),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         showSearch(context: context, delegate: MySearchDelegate());
          //       },
          //       icon: Icon(Icons.search))
          // ],
        ),
        body: resourcesLabel == 'Articles'
            ? _listArticles.when(
                data: (_data) {
                  return Container(
                    child: ListResources(
                      list: _data,
                    ),
                  );
                },
                error: (err, s) {
                  Center(
                    child: Text(err.toString()),
                  );
                },
                loading: () => Center(
                      child: CircularProgressIndicator(),
                    ))
            : resourcesLabel == 'News'
                ? _listNews.when(
                    data: (_data) {
                      return Container(
                        child: ListResources(
                          list: _data,
                        ),
                      );
                    },
                    error: (err, s) {
                      Center(
                        child: Text(err.toString()),
                      );
                    },
                    loading: () => Center(
                          child: CircularProgressIndicator(),
                        ))
                : resourcesLabel == 'Prayers'
                    ? _listPrayers.when(
                        data: (_data) {
                          return Container(
                            child: ListResourcesCard(
                              list: _data,
                            ),
                          );
                        },
                        error: (err, s) {
                          Center(
                            child: Text(err.toString()),
                          );
                        },
                        loading: () => Center(
                              child: CircularProgressIndicator(),
                            ))
                    : Container());
  }
}

class ListResources extends StatelessWidget {
  final List<ModelResources1> list;

  const ListResources({Key? key, required this.list}) : super(key: key);

  final String urlImage =
      'https://static.imavi.org/komunio/archived/komunio_media/';
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Container(
          child: Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailResource(
                      dataDetails: list[index],
                    ),
                  ),
                );
              },
              child: CustomListItemTwo(
                thumbnail: Container(
                    child: Image.network(
                  urlImage + list[index].imageLink,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/art.png');
                  },
                )),
                title: list[index].title,
                subtitle: list[index].excerpt,
                author: list[index].author,
                publishDate: list[index].publishDate,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ListResourcesCard extends StatelessWidget {
  final List<ModelResources1> list;

  const ListResourcesCard({Key? key, required this.list}) : super(key: key);

  final String urlImage =
      'https://static.imavi.org/komunio/archived/komunio_media/';
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Container(
          child: Card(
            elevation: 2,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailResource(
                      dataDetails: list[index],
                    ),
                  ),
                );
              },
              child: CustomListItemTwoCard(
                title: list[index].title,
                subtitle: list[index].excerpt,
                author: list[index].author,
                publishDate: list[index].publishDate,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  const CustomListItemTwo({
    Key? key,
    required this.thumbnail,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.publishDate,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String author;
  final String publishDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  subtitle: subtitle,
                  author: author,
                  publishDate: publishDate,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomListItemTwoCard extends StatelessWidget {
  const CustomListItemTwoCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.publishDate,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: SizedBox(
        height: 75,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 0.0, 2.0, 0.0),
                child: _CardDescription(
                  title: title,
                  subtitle: subtitle,
                  author: author,
                  publishDate: publishDate,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ArticleDescription extends StatelessWidget {
  const _ArticleDescription({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.publishDate,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;

  @override
  Widget build(BuildContext context) {
    Moment rawDate = Moment.parse(publishDate);
    var date = rawDate.format('dd-MM-yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                author,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardDescription extends StatelessWidget {
  const _CardDescription({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.publishDate,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;

  @override
  Widget build(BuildContext context) {
    Moment rawDate = Moment.parse(publishDate);
    var date = rawDate.format('dd-MM-yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Row(
          children: [
            Container(
              child: Icon(
                Icons.book,
                size: 50,
                color: Color.fromARGB(255, 255, 114, 7),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ))
        // Expanded(
        //   child: Row(
        //     children: [
        //       Container(
        //         padding: EdgeInsets.only(right: 10),
        //         child: Icon(
        //           Icons.book,
        //           size: 50,
        //           color: Color.fromARGB(255, 255, 114, 7),
        //         ),
        //       ),
        //       Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: <Widget>[
        //           Container(
        //             width: MediaQuery.of(context).size.width * 0.75,
        //             child: Text(
        //               title,
        //               maxLines: 2,
        //               overflow: TextOverflow.ellipsis,
        //               style: const TextStyle(
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           ),
        //           const Padding(padding: EdgeInsets.only(bottom: 2.0)),
        //           Container(
        //             width: MediaQuery.of(context).size.width * 0.65,
        //             child: Expanded(
        //               child: Text(
        //                 subtitle,
        //                 maxLines: 2,
        //                 overflow: TextOverflow.ellipsis,
        //                 style: const TextStyle(
        //                   fontSize: 12.0,
        //                   color: Colors.black54,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear));
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<String> suggestions = [];

    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          title: Text('data'),
        );
      },
    );
  }
}
