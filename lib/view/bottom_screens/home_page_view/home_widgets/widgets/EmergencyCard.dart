import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class EmergencyCard extends StatelessWidget {
  final String number;
  final String imagePath;
  final String title;
  final String subTitle;

  EmergencyCard({required this.number, required this.imagePath, required this.title, required this.subTitle});

  _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 5),
      child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            onTap: () => _callNumber("$number"),
            child: Container(
                height: 180,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                      Color(0xFFFD8080),
                      Color(0xFFFB8580),
                      Color(0xFFFBD079),
                    ])),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: Image.asset("$imagePath", fit: BoxFit.fill).image,
                      backgroundColor: Colors.white.withOpacity(0.5),
                      //child: Image.asset("$imagePath", fit: BoxFit.fill),
                    ),
                    Expanded(
                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('$title',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width * 0.06,
                            )),
                        Text('$subTitle',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width * 0.035,
                            )),
                        Container(
                            height: 28,
                            width: 80,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text('$number',
                                  style: TextStyle(
                                    color: Colors.red[300],
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width * 0.055,
                                  )),
                            )),
                      ]),
                    )
                  ]),
                )),
          )),
    );
  }
}
