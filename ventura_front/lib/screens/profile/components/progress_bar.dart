import 'package:flutter/material.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

class ProgressBarY extends StatefulWidget {
  final double valor;
  const ProgressBarY({super.key, required this.valor});

  @override
  State<ProgressBarY> createState() => ProgressBarYState();
}

class ProgressBarYState extends State<ProgressBarY> {
  @override
  Widget build(BuildContext context) {
    return AnimatedProgressBar(
      value: widget.valor,
      width: 400,
      height: 30,
      duration: const Duration(seconds: 3),
      gradient: const LinearGradient(
        colors: [
          Colors.amber,
          Color.fromARGB(255, 244, 124, 54),
        ],
      ),
      backgroundColor: Color(0xFF262E32),
    );
  }
}
