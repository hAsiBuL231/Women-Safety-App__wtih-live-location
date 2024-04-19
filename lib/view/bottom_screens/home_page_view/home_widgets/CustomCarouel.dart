import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../components/safewebview.dart';

class CustomCarousel extends StatelessWidget {
  CustomCarousel({super.key});

  void navigateToRoute(BuildContext context, Widget route) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
  }

  final List<String> imageSliders = [
    "https://media.istockphoto.com/photos/silhouette-of-super-strong-successful-businesswoman-picture-id1249879109?k=20&m=1249879109&s=612x612&w=0&h=I-joEMjqkq1wCJZJeLWUCd1d2HcB5WxBShdkA9YM0cg=",
    "https://media.istockphoto.com/vectors/young-woman-looks-at-the-mirror-and-sees-her-happy-reflection-vector-id1278815846?k=20&m=1278815846&s=612x612&w=0&h=JUTmV9Of-_ILOfXBfV9Cmp_41yuTliSdFIcZy5LKuss=",
    "https://media.istockphoto.com/vectors/mental-health-or-psychology-concept-with-flowering-human-head-vector-id1268669581?k=20&m=1268669581&s=612x612&w=0&h=YVLTKCZXKugEn40aqOkir4vcoFeTUAQToa1i3AFYRNU=",
    "https://media.istockphoto.com/photos/confidence-and-strength-concept-picture-id1086700012?k=20&m=1086700012&s=612x612&w=0&h=1wWVN3AB7BH7o3y2A2b-NG3HB9H6Dwkc9OLz2lxgwAY=",
  ];

  final List<String> articleTitle = ["Bangladeshi women are inspiring", "We have to end Violence", "Be a change", "You are strong"];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        options: CarouselOptions(aspectRatio: 2.0, autoPlay: true, enlargeCenterPage: true),
        items: List.generate(
          imageSliders.length,
          (index) => Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                onTap: () {
                  if (index == 0) {
                    navigateToRoute(
                        context, const SafeWebView(url: "https://www.tbsnews.net/women-empowerment/inspiring-bangladeshi-women-recent-times-whom-you-need-know-254668"));
                  } else if (index == 1) {
                    navigateToRoute(context, const SafeWebView(url: "https://plan-international.org/ending-violence/16-ways-end-violence-girls"));
                  } else if (index == 2) {
                    navigateToRoute(context, const SafeWebView(url: "https://dwa.gov.bd/"));
                  } else {
                    navigateToRoute(context, const SafeWebView(url: "https://www.healthline.com/health/womens-health/self-defense-tips-escape"));
                  }
                },
                child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20), image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(imageSliders[index]))),
                    child: Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: LinearGradient(colors: [Colors.black.withOpacity(0.5), Colors.transparent])),
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 8, left: 8),
                              child: Text(articleTitle[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                  )))),
                    )),
              )),
        ));
  }
}
