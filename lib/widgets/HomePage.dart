import 'package:card_loader/routes.dart';
import 'package:card_loader/widgets/DestinationViewFactory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  final List<MainRoute> routes;
  final DestinationViewFactory destFactory;

  HomePage({this.destFactory, this.routes});

  @override
  _HomePageState createState() => _HomePageState(destFactory, routes);
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  List<Key> _destinationKeys;
  List<AnimationController> _faders;
  AnimationController _hide;
  int _currentIndex = 0;

  final List<MainRoute> routes;
  final DestinationViewFactory destFactory;

  _HomePageState(this.destFactory, this.routes);

  @override
  void initState() {
    super.initState();

    _faders =
        routes.map<AnimationController>((MainRoute destination) {
          return AnimationController(
              vsync: this, duration: Duration(milliseconds: 200));
        }).toList();
    _faders[_currentIndex].value = 1.0;
    _destinationKeys =
        List<Key>.generate(routes.length, (int index) => GlobalKey())
            .toList();
    _hide = AnimationController(vsync: this, duration: kThemeAnimationDuration);
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders) controller.dispose();
    _hide.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0 && notification is UserScrollNotification) {
      final UserScrollNotification userScroll = notification;
      switch (userScroll.direction) {
        case ScrollDirection.forward:
          _hide.forward();
          break;
        case ScrollDirection.reverse:
          _hide.reverse();
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Stack(
            fit: StackFit.expand,
            children: routes.map((MainRoute destination) {
              final Widget view = FadeTransition(
                opacity: _faders[destination.index]
                    .drive(CurveTween(curve: Curves.fastOutSlowIn)),
                child: KeyedSubtree(
                  key: _destinationKeys[destination.index],
                  child: destFactory.create(
                    destination: destination,
                    onNavigation: () {
                      _hide.forward();
                    },
                  ),
                ),
              );
              if (destination.index == _currentIndex) {
                _faders[destination.index].forward();
                return view;
              } else {
                _faders[destination.index].reverse();
                if (_faders[destination.index].isAnimating) {
                  return IgnorePointer(child: view);
                }
                return Offstage(child: view);
              }
            }).toList(),
          ),
        ),
        bottomNavigationBar: ClipRect(
          child: SizeTransition(
            sizeFactor: _hide,
            axisAlignment: -1.0,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: routes.map((MainRoute destination) {
                return BottomNavigationBarItem(
                    icon: Icon(destination.icon),
                    backgroundColor: destination.details.color,
                    title: Text(destination.details.title));
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

