import 'package:flutter/material.dart';

import 'widgets/EmergencyCard.dart';

class EmergencyWidget extends StatelessWidget {
  const EmergencyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          EmergencyCard(
            number: "999",
            imagePath: "Assets/images/icons/alert.png",
            title: 'Active Emergency',
            subTitle: 'In case of Police, fire service and ambulance services',
          ),
          EmergencyCard(
            number: "109",
            imagePath: "Assets/images/icons/ambulance.png",
            title: 'Domestic Violence',
            subTitle: 'In case of women and children are abused',
          ),
          EmergencyCard(
            number: "102",
            imagePath: "Assets/images/icons/flame.png",
            title: 'Fire brigade',
            subTitle: 'In case of fire emergency',
          ),
          EmergencyCard(
            number: "101",
            imagePath: "Assets/images/icons/army.png",
            title: 'RAB',
            subTitle: 'National counter Terrorism Authority',
          ),
        ],
      ),
    );
  }
}
