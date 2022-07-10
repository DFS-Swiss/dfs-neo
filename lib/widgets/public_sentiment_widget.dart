import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PublicSentiment extends HookWidget {
  final int percentage;
  const PublicSentiment({required this.percentage, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(25, 53, 174, 1),
                        Color.fromRGBO(49, 89, 173, 1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(47, 85, 167, 1),
                        Color.fromRGBO(69, 138, 195, 1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(68, 136, 184, 1),
                        Color.fromRGBO(82, 165, 180, 1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(82, 157, 171, 1),
                        Color.fromRGBO(123, 200, 184, 1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(130, 209, 194, 1),
                        Color.fromRGBO(112, 193, 139, 1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width:
                    (MediaQuery.of(context).size.width - 48) * percentage / 100,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(28, 155, 194, 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(28, 154, 194, 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 6,
                    width: 6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
