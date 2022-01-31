import 'package:audio_player/components/custom_list_tile.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  _MusicAppState createState() => _MusicAppState();
}

List musicList = [
  {
    'title': 'Serene View',
    'singer': 'by Eugeny MMD',
    'url':
        'https://assets.mixkit.co/music/preview/mixkit-tech-house-vibes-129.mp3',
    'coverUrl':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjtxVomZYTyflYDw4pe_pleBjRXJnlIvDsvA&usqp=CAU',
  },
  {
    'title': 'Dance with me',
    'singer': 'by Alejandro Magaña (A. M.)',
    'url':
        'https://assets.mixkit.co/music/preview/mixkit-tech-house-vibes-130.mp3',
    'coverUrl':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSS570OtrR8u3DsrykCEtnf94bM6AaciEN-w&usqp=CAU',
  },
  {
    'title': 'Tech House',
    'singer': '(A. M.)',
    'url':
        'https://assets.mixkit.co/music/preview/mixkit-hazy-after-hours-132.mp3',
    'coverUrl': 'https://www.bravolyrics.ru/_pu/533/s99770445.jpg',
  },
  {
    'title': 'Deep urban',
    'singer': 'by Max USS (A. M.)',
    'url':
        'https://assets.mixkit.co/music/preview/mixkit-tech-house-vibes-131.mp3',
    'coverUrl':
        'https://muzlive.info/uploads/posts/2020-04/1586706694_cover.jpg',
  },
  {
    'title': 'Complicated',
    'singer': 'by Araluo (A. M.)',
    'url':
        'https://assets.mixkit.co/music/preview/mixkit-tech-house-vibes-133.mp3',
    'coverUrl':
        'https://avatars.mds.yandex.net/get-zen_doc/1781308/pub_5d88980698fe7900b045f305_5d8899d695aa9f00b1375c80/scale_1200',
  },
];

class _MusicAppState extends State<MusicApp> {
  String currentTitle = "";
  String currentCover = "";
  String currentSinger = "";

  IconData btnIcon = Icons.play_arrow;

  Duration duration = Duration();
  Duration position = Duration();
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  String currentSong = "";

  void playMusic(String url) async {
    if (isPlaying && currentSong != url) {
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          currentSong = url;
        });
      }
    } else if (!isPlaying) {
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          isPlaying = true;
        });
      }
    }
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Мой прейлист',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: musicList.length,
                    itemBuilder: (context, index) {
                      return CustomListTile(
                        onTap: () {
                          playMusic(musicList[index]['url']);
                          setState(() {
                            currentTitle = musicList[index]['title'];
                            currentCover = musicList[index]['coverUrl'];
                            currentSinger = musicList[index]['singer'];
                          });
                        },
                        title: musicList[index]['title'],
                        singer: musicList[index]['singer'],
                        url: musicList[index]['url'],
                        coverUrl: musicList[index]['coverUrl'],
                      );
                    })),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Color(0x55212121),
                  blurRadius: 8.0,
                )
              ]),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'С налала ${position.inMinutes % 60}:${position.inSeconds % 60}'),
                        Text(
                            'Длительность ${duration.inMinutes % 60}:${duration.inSeconds % 60}')
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            image: DecorationImage(
                                image: NetworkImage(currentCover))),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentTitle,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            currentSinger,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          )
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            if (isPlaying) {
                              audioPlayer.pause();
                              setState(() {
                                btnIcon = Icons.pause;
                                isPlaying = false;
                              });
                            } else if (!isPlaying) {
                              audioPlayer.resume();
                              setState(() {
                                btnIcon = Icons.play_arrow;
                                isPlaying = true;
                              });
                            }
                          },
                          iconSize: 42,
                          icon: Icon(
                            btnIcon,
                            color: Colors.grey,
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
