import 'dart:async';

import 'package:flutter/material.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({super.key});

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  Timer? _timer;
  int _time = 0;
  bool _isRunning = false;
  List<String> _lapTimes = [];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _clickButton() {
    _isRunning = !_isRunning;
    if (_isRunning) {
      _start();
    } else {
      _pause();
    }
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
      });
    });
  }

  void _pause() {
    _timer?.cancel();
  }

  void _reset() {
    _isRunning = false;
    _timer?.cancel();
    _lapTimes.clear();
    _time = 0;
  }

  void _recordLapTime(String time) {
    _lapTimes.insert(0, '${_lapTimes.length + 1}등 $time');
  }

  @override
  Widget build(BuildContext context) {
    int second = _time ~/ 100;
    String milliSecond = (_time % 100).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stop Watch',
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                second.toString(),
                style: const TextStyle(
                  fontSize: 50,
                ),
              ),
              Text(
                milliSecond,
              ),
            ],
          ),
          SizedBox(
            width: 100,
            height: 200,
            child: ListView(
              children: _lapTimes
                  .map(
                    (e) => Center(
                      child: Text(e),
                    ),
                  )
                  .toList(),
            ),
          ),
          const Spacer(), //빈공간을 꽉 채워줌
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.lightGreen,
                onPressed: () {
                  setState(() {
                    _reset();
                  });
                },
                child: const Icon(
                  Icons.refresh,
                ),
              ),
              FloatingActionButton(
                backgroundColor: Colors.lightBlueAccent,
                onPressed: () {
                  setState(() {
                    _clickButton();
                  });
                },
                child: _isRunning
                    ? const Icon(
                        Icons.pause,
                      )
                    : const Icon(
                        Icons.play_arrow,
                      ),
              ),
              FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () {
                  setState(() {
                    _recordLapTime('$second.$milliSecond');
                  });
                },
                child: const Icon(
                  Icons.add,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
