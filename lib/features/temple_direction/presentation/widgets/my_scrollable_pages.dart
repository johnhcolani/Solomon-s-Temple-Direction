import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyScrollablePages extends StatefulWidget {
  @override
  _MyScrollablePagesState createState() => _MyScrollablePagesState();
}

class _MyScrollablePagesState extends State<MyScrollablePages> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            children: [
              // First Page with the Scrollable Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.merriweather(
                      fontSize: Platform.isIOS ? 18 : 14,
                      color: const Color(0xffffffff),
                    ),
                    children: [
                      const TextSpan(
                        text: '\nAnd now, God of Israel, let your word that you promised your servant David my father come true.\n\n',
                      ),
                      TextSpan(
                        text: '1 Kings 8:26',
                        style: GoogleFonts.merriweather(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffb1afad),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Second Page
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.merriweather(
                      fontSize: Platform.isIOS ? 18 : 14,
                      color: const Color(0xffe6e3e0),
                    ),
                    children: [
                      const TextSpan(
                        text: 'But will God really dwell on earth? The heavens, even the highest heaven, cannot contain you. How much less this temple I have built!\n\n',
                      ),
                      TextSpan(
                        text: '1 Kings 8:27',
                        style: GoogleFonts.merriweather(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xffb1afad),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Third Page
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.merriweather(
                      fontSize: Platform.isIOS ? 18 : 14,
                      color: const Color(0xffe6e3e0),
                    ),
                    children: [
                      const TextSpan(
                        text: 'Yet give attention to your servant’s prayer and his plea for mercy, LORD my God. Hear the cry and the prayer that your servant is praying in your presence this day.\n\n',
                      ),
                      TextSpan(
                        text: '1 Kings 8:28',
                        style: GoogleFonts.merriweather(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xffb1afad),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Fourth Page
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.merriweather(
                      fontSize: Platform.isIOS ? 18 : 14,
                      color: const Color(0xffe6e3e0),
                    ),
                    children: [
                      const TextSpan(
                          text:
                          'May your eyes be open toward this temple night and day, this place of which you said:\n'),
                      TextSpan(
                        text: 'My Name shall be there\n',
                        style: GoogleFonts.merriweather(
                          fontSize: Platform.isIOS ? 18 : 14,
                          color: Colors.amber,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                          text:
                          'so that you will hear the prayer your servant prays toward this place.\n\n',
                          style: TextStyle(
                            fontSize: Platform.isIOS ? 18 : 14,
                          )),

                      // Page Indicator

                      TextSpan(
                        text: '1 Kings 8:29',
                        style: GoogleFonts.merriweather(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xffe6e3e0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),


        SmoothPageIndicator(
          controller: _pageController,
          count: 4,
          effect: ExpandingDotsEffect(
            activeDotColor: Color(0xff85b0c5),
            dotColor: Colors.grey,
            dotHeight: 8,
            dotWidth: 8,
            spacing: 5.0,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}