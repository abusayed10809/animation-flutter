import 'package:flutter/material.dart';

class AnimatedPromptScreen extends StatelessWidget {
  const AnimatedPromptScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icons'),
      ),
      body: const Center(
        child: AnimatedPrompt(
          title: 'Thank you for your order!',
          subTitle: 'Your order will be delivered in 2 days. Enjoy!',
          child: Icon(
            Icons.check,
          ),
        ),
      ),
    );
  }
}

///
///
class AnimatedPrompt extends StatefulWidget {
  final String title;
  final String subTitle;
  final Widget child;

  const AnimatedPrompt({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedPrompt> createState() => _AnimatedPromptState();
}

class _AnimatedPromptState extends State<AnimatedPrompt> with SingleTickerProviderStateMixin {
  // animation controller
  late AnimationController _controller;

  // animations
  // 1. icon scale
  // 2. container scale
  // 3. y animation - offset
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _containerScaleAnimation;
  late Animation<Offset> _yAnimation;

  @override
  void initState() {
    super.initState();
    // setting duration of the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // y animation tween offset 0,0 to 0,-.23
    _yAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.23),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // icon scale animation
    // tween animation
    _iconScaleAnimation = Tween<double>(
      begin: 7,
      end: 6,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // container scale animation
    // the container with green background
    _containerScaleAnimation = Tween<double>(
      begin: 2.0,
      end: 0.4,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // resetting the controller and making a forward animation
    _controller
      ..reset()
      ..forward();

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 100,
            minHeight: 100,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Stack(
            children: [
              ///
              /// title + subtitle
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 160,
                    ),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.subTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              ///
              /// green container with the tick icon
              Positioned.fill(
                ///
                /// slide transition helps slide the icon up the y axis
                child: SlideTransition(
                  position: _yAnimation,
                  ///
                  /// scale transition for the green container
                  child: ScaleTransition(
                    scale: _containerScaleAnimation,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      ///
                      /// scale transition for the icon
                      child: ScaleTransition(
                        scale: _iconScaleAnimation,
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
