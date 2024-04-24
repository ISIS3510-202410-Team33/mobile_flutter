import 'package:flutter/material.dart';

class RateIcon extends StatefulWidget {
  const RateIcon({Key? key}) : super(key: key);

  @override
  State<RateIcon> createState() => _RateIconState();
}

class _RateIconState extends State<RateIcon> {
  int _selectedStars = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child:Text('Building Raiting')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 1; i <= 5; i++)
                IconButton(
                  icon: Icon(
                    i <= _selectedStars ? Icons.star : Icons.star_border,
                    color: Color.fromARGB(255, 28, 150, 206),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedStars = i;
                    });
                  },
                ),
            ],
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Enter your comment'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showThankYouDialog(context);
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thank You!'),
          content: Text('Thanks for sharing your opinion with us.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}