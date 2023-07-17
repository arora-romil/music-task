import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_task/MVVM/ViewModel/audio_player_view_model.dart';
import 'package:music_task/widgets/bottom_player.dart';
import 'package:music_task/widgets/discover_music.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void dispose() {
    context.read<AudioPlayerViewModel>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF3A6073),
            Color(0xFF16222A),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const BottomPlayer(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DiscoverMusic(),
              FutureBuilder(
                future: context
                    .read<AudioPlayerViewModel>()
                    .fetchSongsFromFirebaseStorage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: ((context, index) {
                      final song =
                          context.read<AudioPlayerViewModel>().playlist[index];
                      return GestureDetector(
                        onTap: () {
                          context
                              .read<AudioPlayerViewModel>()
                              .setCurrentIndex(index);
                          context.read<AudioPlayerViewModel>().play();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.network(
                                song.image,
                                fit: BoxFit.cover,
                                height: 180,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                              child: Text(
                                song.title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                              child: Text(
                                song.artist,
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    itemCount:
                        context.read<AudioPlayerViewModel>().playlist.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
