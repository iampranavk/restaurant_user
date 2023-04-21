import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  final Function(int) onChange;
  final double size;
  const Counter({
    super.key,
    required this.onChange,
    this.size = 30,
  });

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            if (count > 1) {
              count--;
            }
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              Icons.remove_circle_outline_outlined,
              color: Colors.green[800],
              size: widget.size,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            count.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
        ),
        InkWell(
          onTap: () {
            count++;
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              Icons.add_circle_outline_outlined,
              color: Colors.green[800],
              size: widget.size,
            ),
          ),
        )
      ],
    );
  }
}
