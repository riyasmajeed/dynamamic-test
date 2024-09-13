import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart'; // For accessing platform-specific code

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const TextPost(),
    const VideoPost(),
    const ImagePost(),
  ];

  @override
  void initState() {
    super.initState();
    if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      _handleDesktopDeepLink();
    }
  }

  // Handle deep links manually for desktop
  void _handleDesktopDeepLink() {
    // On desktop platforms, command-line arguments may contain deep link information
    final List<String> args = PlatformDispatcher.instance.arguments;

    // Check if any arguments contain a deep link URL
    if (args.isNotEmpty) {
      Uri? uri = Uri.tryParse(args.first);
      if (uri != null) {
        _navigateToPost(uri);
      }
    }
  }

  // Navigate to the appropriate post based on the deep link
  void _navigateToPost(Uri uri) {
    String? postId = uri.queryParameters['id'];

    if (postId == 'text_post_id') {
      setState(() {
        _selectedIndex = 0;
      });
    } else if (postId == 'video_post_id') {
      setState(() {
        _selectedIndex = 1;
      });
    } else if (postId == 'image_post_id') {
      setState(() {
        _selectedIndex = 2;
      });
    } else {
      print('Unknown Post ID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('GuideUs Posts',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: 'Text'),
          BottomNavigationBarItem(icon: Icon(Icons.video_library), label: 'Video'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Image'),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

extension on PlatformDispatcher {
  List<String> get arguments => HttpHeaders.entityHeaders;
}

// Share post function
void sharePost(String postId) {
  final String link = 'myapp://post?id=$postId';
  Share.share('Check out this post: $link');
}

// Text Post
class TextPost extends StatelessWidget {
  const TextPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('write about something',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.bold),),
        ElevatedButton(
          onPressed: () => sharePost('text_post_id'),
          child: const Text('Share Text Post'),
        ),
      ],
    );
  }
}

// Video Post
class VideoPost extends StatelessWidget {
  const VideoPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage('https://images.squarespace-cdn.com/content/v1/5acd17597c93273e08da4786/1547847934765-ZOU5KGSHYT6UVL6O5E5J/Shrek+Poster.png'),
                        ),
                        color: const Color.fromARGB(70, 44, 206, 228),
                      ),
                    ),
        const Text('This is a Video Post (replace with video player)',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.bold)),
        ElevatedButton(
          onPressed: () => sharePost('video_post_id'),
          child: const Text('Share Video Post'),
        ),
      ],
    );
  }
}

// Image Post
class ImagePost extends StatelessWidget {
  const ImagePost({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage('https://images.squarespace-cdn.com/content/v1/5acd17597c93273e08da4786/1547847934765-ZOU5KGSHYT6UVL6O5E5J/Shrek+Poster.png'),
                        ),
                        color: const Color.fromARGB(70, 44, 206, 228),
                      ),
                    ),
        const Text('This is an Image Post (replace with image display)',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.bold)),
        ElevatedButton(
          onPressed: () => sharePost('image_post_id'),
          child: const Text('Share Image Post'),
        ),
      ],
    );
  }
}
