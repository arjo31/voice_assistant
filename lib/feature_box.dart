import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  const FeatureBox(
      {super.key,
      required this.color,
      required this.headerText,
      required this.infoText});

  final Color color;
  final String headerText;
  final String infoText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 500,
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  headerText,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                    fontFamily: 'Cera Pro',
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                infoText,
                style: TextStyle(
                    fontFamily: 'Cera Pro',
                    fontSize: 17,
                    fontWeight: FontWeight.w300),
              ),
            ]),
      ),
    );
  }
}
