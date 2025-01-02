import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'data.dart';

class Onborading extends StatefulWidget {
  const Onborading({super.key});

  @override
  State<Onborading> createState() => _OnboradingState();
}

class _OnboradingState extends State<Onborading> {
  final list = [
    Data(
        image: 'assets/Frame.png',
        text: 'Browse the menu and order directly from the applciation'),
    Data(
        image: 'assets/Frame-1.png',
        text:
            'Your order will be immediately collected an sent by our couriern'),
    Data(
        image: 'assets/Group10.png',
        text: 'Pick up delivery at your door and enjoy your food')
  ];
  final pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF8E4D2),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            SvgPicture.asset(
              'assets/Group7.svg',
              fit: BoxFit.cover,
            ),
            PageView.builder(
              controller: pageController,
              itemCount: list.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        pageController.animateToPage(list.length - 1,
                            duration: const Duration(milliseconds: 5000),
                            curve: Curves.ease);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('S K I P'),
                          Icon(Icons.arrow_right_rounded),
                        ],
                      ),
                    ),
                    Image.asset(list[index].image),
                    Text(
                      list[index].text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    InkWell(
                      onTap: () {
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.ease);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset('assets/Polygon1.svg'),
                          const Icon(
                            Icons.arrow_right_alt_sharp,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
