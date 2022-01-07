import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GlassEffectScreen extends StatelessWidget {
  const GlassEffectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var cardHeight = (width - 64) * (0.6);
    var bigCircle = width * 0.5;
    var smallCircle = cardHeight * 0.7;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1F29),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: ClipOval(
                  child: Container(
                    width: bigCircle,
                    height: bigCircle,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFFC23993),
                          Color(0xFFFD5939),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: cardHeight * 0.5,
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: cardHeight * 0.6,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: ClipOval(
                  child: Container(
                    width: smallCircle,
                    height: smallCircle,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xFF009EFD),
                          Color(0xFF2AF598),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          GlossyCard(width: width - 32, height: cardHeight)
        ],
      ),
    );
  }
}

class GlossyCard extends StatefulWidget {
  const GlossyCard({Key? key, required this.width, required this.height})
      : super(key: key);

  final double width;
  final double height;

  @override
  State<GlossyCard> createState() => _GlossyCardState();
}

class _GlossyCardState extends State<GlossyCard> {
  double dx = 0.0;
  double dy = 0.0;
  final _angle = pi / 9;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(_angle * dx * -1)
        ..rotateY(_angle * dy * -1),
      child: Listener(
        onPointerDown: _onPointerEnter,
        onPointerUp: _onPointerExit,
        onPointerMove: _onPointerHover,
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(16),
          child: ClipRect(
            clipBehavior: Clip.antiAlias,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.all(24),
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'V I S A',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                    ),
                    const Spacer(),
                    const CardNumberRow(),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          Text(
                            'John Doe',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                          Text(
                            '12/25',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPointerEnter(PointerEvent e) {
    _updateAngles(e);
  }

  void _onPointerExit(PointerEvent e) {
    print('Mouse Exited');
    setState(() {
      dx = 0;
      dy = 0;
    });
  }

  Alignment alignment = Alignment.center;

  void _onPointerHover(PointerEvent e) {
    //print('Local Position = ' + e.localPosition.toString());

    _updateAngles(e);
  }

  void _updateAngles(PointerEvent e) {
    var x = e.localPosition.dx;
    var y = e.localPosition.dy;

    var xLimit = widget.width / 2;
    var yLimit = widget.height / 2;

    if (x < xLimit && y < yLimit) {
      alignment = Alignment.topLeft;
    } else if (x > xLimit && y < yLimit) {
      alignment = Alignment.topRight;
    } else if (x < xLimit && y > yLimit) {
      alignment = Alignment.bottomLeft;
    } else if (x > xLimit && y > yLimit) {
      alignment = Alignment.bottomRight;
    }

    var vx = x % xLimit;
    var vy = y % yLimit;

    if (alignment == Alignment.topLeft || alignment == Alignment.bottomLeft) {
      vx = (xLimit - vx) * -1;
    }

    if (alignment == Alignment.topLeft || alignment == Alignment.topRight) {
      vy = (yLimit - vy);
    } else {
      vy *= -1;
    }

    setState(() {
      dx = vy / yLimit;
      ;
      dy = vx / xLimit;
    });
  }
}

class CardNumberRow extends StatelessWidget {
  const CardNumberRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context)
        .textTheme
        .headline6!
        .copyWith(color: Colors.white, fontWeight: FontWeight.w300);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          '5163',
          style: style,
        ),
        Text(
          '3963',
          style: style,
        ),
        Text(
          '0491',
          style: style,
        ),
        Text(
          '9976',
          style: style,
        ),
      ],
    );
  }
}
