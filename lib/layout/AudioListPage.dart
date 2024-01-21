import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class AudioListPage extends StatefulWidget {
  const AudioListPage({super.key});

  @override
  State<AudioListPage> createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {

  Color bgColor = Colors.purpleAccent;

  //Audio Plugin
  final OnAudioQuery _onAudioQuery = OnAudioQuery();

  //Audio Player
  final AudioPlayer _audioPlayer = AudioPlayer();

  final blurRadius = 4.0;

  final spreadRadius = 4.0;

  //Song Variables
  List<SongModel> songs = [];
  String actualSongTitle = '';
  int currentIndex = 0;

  bool isPlayerViewVisible = false;

  //method to set the player view visibility
  void _changePlayerViewVisibility(){
    setState(() {
      isPlayerViewVisible = !isPlayerViewVisible;
    });
  }

  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
        _audioPlayer.positionStream, _audioPlayer.durationStream, (position, duration) => DurationState(
        position: position, total: duration?? Duration.zero
      ));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestStoragePermission();

    //update the current playing song index listener
    _audioPlayer.currentIndexStream.listen((index) {
        if(index != null){
          _updateCurrentPlayingSongDetails(index);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    if(isPlayerViewVisible){
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 56, right: 20, left: 20),
            decoration: BoxDecoration(color: bgColor),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: InkWell(
                          onTap: _changePlayerViewVisibility,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: getDecoration(BoxShape.circle, const Offset(2, 2),2.0,0.0),
                            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white70,),
                          ),
                        )
                    ),
                    Flexible(
                        flex: 5,
                        child: Text(
                          actualSongTitle,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 10
                          ),
                        ),
                    )
                  ],
                ),

                //paste here

                //art work Container
                Container(
                  width: 300,
                  height: 300,
                  decoration: getDecoration(BoxShape.circle, const Offset(2, 2), 2.0, 2.0),
                  margin: const EdgeInsets.only(top: 30, bottom: 30),
                  child: QueryArtworkWidget(
                    id: songs[currentIndex].id,
                    type: ArtworkType.AUDIO,
                    artworkBorder: BorderRadius.circular(200),
                  ),

                ),
                Column(
                  children: [
                    Container(
                      padding:  EdgeInsets.zero,
                      margin:  const EdgeInsets.only(bottom: 4.0),
                      decoration: getRectDecoration(BorderRadius.circular(20), const Offset(2, 2), 2, 0),
                      child: StreamBuilder<DurationState>(
                        stream: _durationStateStream,
                        builder: (context, snapshot){
                          final durationState = snapshot.data;
                          final progress = durationState?.position?? Duration.zero;
                          final total = durationState?.total ?? Duration.zero;

                          return ProgressBar(
                            progress: progress,
                            total: total,
                            barHeight: 20.0,
                            baseBarColor: bgColor,
                            thumbColor: Colors.white60.withBlue(99),
                            timeLabelTextStyle: const TextStyle(
                              fontSize: 0,
                            ),
                            onSeek: (duration){
                              _audioPlayer.seek(duration);
                            },
                          );
                        },
                      ),
                    ),

                    //Position progress and total text
                    StreamBuilder<DurationState>(
                        stream: _durationStateStream,
                        builder: (context, snapshot){
                          final durationState = snapshot.data;
                          final progress = durationState?.position?? Duration.zero;
                          final total = durationState?.total ?? Duration.zero;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                  child: Text(
                                    progress.toString().split(".")[0],
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                    ),
                                  )
                              ),
                              Flexible(
                                  child: Text(
                                    total.toString().split(".")[0],
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                    ),
                                  )
                              ),
                            ],
                          );
                        })
                  ],
                ),

                //Play and pause and change the song
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            if(_audioPlayer.hasPrevious){
                              _audioPlayer.seekToPrevious();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: getDecoration(BoxShape.circle, const Offset(2,2), 2.0, 2.0),
                            child: const Icon(Icons.skip_previous, color: Colors.white70,),
                          ),
                        ),
                      ),
                      //Play button
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            if(_audioPlayer.playing){
                              _audioPlayer.pause();
                            }
                            else{
                              if(_audioPlayer.currentIndex != null){
                                _audioPlayer.play();
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(right: 20, left: 20),
                            decoration: getDecoration(BoxShape.circle, const Offset(2,2), 2.0, 2.0),
                            child: StreamBuilder<bool>(
                              stream: _audioPlayer.playingStream,
                              builder: (context, snapshot){
                                bool? playingState = snapshot.data;
                                if(playingState != null && playingState){
                                  return const Icon(Icons.pause, size: 30, color: Colors.white70,);
                                }
                                return const Icon(Icons.play_arrow, size: 30, color: Colors.white70,);
                              },
                            ),
                          ),
                        ),
                      ),

                      //Next button
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            if(_audioPlayer.hasNext){
                              _audioPlayer.seekToNext();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: getDecoration(BoxShape.circle, const Offset(2,2), 2.0, 2.0),
                            child: const Icon(Icons.skip_next, color: Colors.white70,),
                          ),
                        ),
                      )


                    ],
                  ),
                ),



                //playlist, shuffle, repeat all and control button
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            _changePlayerViewVisibility();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: getDecoration(BoxShape.circle, const Offset(2, 2), 2, 2),
                            child: const Icon(Icons.list_alt, color: Colors.white70,),
                          ),
                        ),
                      ),

                      //Shuffle
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            _audioPlayer.setShuffleModeEnabled(true);
                            //Fluttertoast(context, "");
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: getDecoration(BoxShape.circle, const Offset(2, 2), 2, 0),
                            child: const Icon(Icons.shuffle, color: Colors.white70,),
                          ),
                        ),
                      ),

                      //Repeat mode
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            _audioPlayer.loopMode == LoopMode.one ? _audioPlayer.setLoopMode(LoopMode.all): _audioPlayer.setLoopMode(LoopMode.one);
                            //Fluttertoast(context, "");
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: getDecoration(BoxShape.circle, const Offset(2, 2), 2, 0),
                            child: StreamBuilder<LoopMode>(
                              stream: _audioPlayer.loopModeStream,
                              builder: (context, snapshot){
                                final loopMode = snapshot.data;
                                if(LoopMode.one == loopMode){
                                  return const Icon(Icons.repeat_one, color: Colors.white70,);
                                }
                                return const Icon(Icons.repeat, color: Colors.white70,);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: FutureBuilder<List<SongModel>>(
        future: _onAudioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item){
          if(item.data == null){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(item.data!.isEmpty){
            return const Center(child: Text("No Songs Found"),);
          }
          songs.clear();
          songs = item.data!;
          return ListView.builder(
            itemCount: item.data!.length,
            itemBuilder: (context, index){
              return Container(
                margin: const EdgeInsets.only(top: 15.0, left: 12.0, right: 16.0),
                padding: const EdgeInsets.only(top: 30.0,bottom: 30),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4.0,
                      offset: Offset(4, 4),
                      color: Colors.black54,
                    ),
                  ]
                ),
                child: ListTile(
                  textColor: Colors.white,
                  title: Text(item.data![index].title),
                  subtitle: Text(item.data![index].displayName,
                    style: const TextStyle(
                      color: Colors.white38,
                    ),),
                  trailing: const Icon(Icons.more_vert),
                  leading: QueryArtworkWidget(
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                  ),
                  onTap: () async{
                    //Toast(context, "Playing: "+ item.data![index].title);
                   // String? url = item.data![index].uri;
                    //await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url!)));
                    _changePlayerViewVisibility();
                    await _audioPlayer.setAudioSource(
                      createPlayList(item.data),
                      initialIndex: index,
                    );
                    await _audioPlayer.play();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }


  void requestStoragePermission() async {
    //if platform is not web
    if(!kIsWeb){
      bool permissionStatus = await _onAudioQuery.permissionsStatus();
      if(!permissionStatus){
        await _onAudioQuery.permissionsRequest();
      }
    }

    //call the build method
    setState(() {
      
    });
  }

  // Create playlist
  ConcatenatingAudioSource createPlayList(List<SongModel>? songs) {

    List<AudioSource> sources = [];
    for (var song in songs!){
        sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  void _updateCurrentPlayingSongDetails(int index) {
    setState(() {
      if(songs.isNotEmpty){
        actualSongTitle = songs[index].title;
        currentIndex = index;
      }
    });
  }

  getDecoration(BoxShape shape, Offset offset, double d, double e) {
    return BoxDecoration(
      color: bgColor,
      shape: shape,
      boxShadow: [
       BoxShadow(
         offset: -offset,
         color: Colors.white24,
         blurRadius: blurRadius,
         spreadRadius: spreadRadius,
       ),
        BoxShadow(
          offset: offset,
          color: Colors.black,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        )
      ],
    );
  }

  BoxDecoration getRectDecoration(BorderRadius borderRadius, Offset offset, int i, int j) {
    return BoxDecoration(
      borderRadius: borderRadius,
      color: bgColor,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: Colors.white24,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: Colors.black,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        )
      ],
    );
  }

}

class DurationState{
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
