import 'package:flutter/material.dart';

class PageTransitionAnimation extends StatefulWidget {
  const PageTransitionAnimation({Key? key}) : super(key: key);

  @override
  State<PageTransitionAnimation> createState() =>
      _PageTransitionAnimationState();
}

class _PageTransitionAnimationState extends State<PageTransitionAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hero Clip Animation'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Super Heroes',
                style: TextStyle(fontSize: 24, letterSpacing: 3),
              ),

              ///
              /// hero card
              Expanded(
                child: HeroCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
* --------------------------------------------------
* hero card
* --------------------------------------------------
* */
class HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ///
        /// go to hero details page
        Navigator.push(
          context,
          PageRouteBuilder(pageBuilder: (context, a, b) => HeroDetailsPage()),
        );
      },
      child: Stack(
        children: <Widget>[
          ///
          /// has a clip path attached to the container
          /// this is the curved container
          /// the background clipper widget is a custom clipper
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BackgroundClipper(),
              child: Hero(
                tag: 'background',
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8 * 1.33,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.deepOrangeAccent],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                ),
              ),
            ),
          ),

          ///
          /// image widget
          /// also a hero widget with scale animation
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.8 * 0.5,
              ),
              child: Hero(
                tag: 'image_hero',
                child: Image.asset(
                  'assets/images/iron_man.png',
                  scale: 1.5,
                ),
              ),
            ),
          ),

          ///
          /// bottom texts
          Positioned(
            bottom: 20,
            left: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Iron Man',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Click for more details',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*
* -------------------------------------------------
* background clipper
* -------------------------------------------------
* */
class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var roundnessFactor = 50.0;

    var path = Path();

    ///
    /// moving the center to different point
    path.moveTo(
      0,
      size.height * 0.33,
    );

    ///
    /// creating first point p0 of the bezier curve
    /// creating the other two point p1 and p2 later on
    path.lineTo(
      0,
      size.height - roundnessFactor,
    );
    path.quadraticBezierTo(
      0,
      size.height,
      roundnessFactor,
      size.height,
    );

    ///
    /// repeating the curve creation process again
    path.lineTo(
      size.width - roundnessFactor,
      size.height,
    );
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height - roundnessFactor,
    );

    ///
    /// curve creation
    path.lineTo(
      size.width,
      roundnessFactor * 2,
    );
    path.quadraticBezierTo(
      size.width - 10,
      roundnessFactor,
      size.width - roundnessFactor * 1.5,
      roundnessFactor * 1.5,
    );

    ///
    /// curve creation
    path.lineTo(
      roundnessFactor * 0.6,
      size.height * 0.33 - roundnessFactor * 0.3,
    );
    path.quadraticBezierTo(
      0,
      size.height * 0.33,
      0,
      size.height * 0.33 + roundnessFactor,
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

/*
* ------------------------------------------------
* details page
* ------------------------------------------------
* */
class HeroDetailsPage extends StatefulWidget {
  @override
  _HeroDetailsPageState createState() => _HeroDetailsPageState();
}

class _HeroDetailsPageState extends State<HeroDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///
      /// background and image working as stack
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ///
          /// hero widget for the background
          Hero(
            tag: 'background',
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.deepOrangeAccent],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
            ),
          ),

          ///
          /// image using hero widget
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///
                /// image widget
                Align(
                  alignment: Alignment.topRight,
                  child: Hero(
                    tag: 'image_hero',
                    child: Image.asset(
                      'assets/images/iron_man.png',
                    ),
                  ),
                ),

                ///
                /// name text
                Text(
                  'Iron Man',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    letterSpacing: 2,
                  ),
                ),

                ///
                /// details text
                Text(
                  'Some character details, some more details to check multiline',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),

          ///
          /// close button on top of screen
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}