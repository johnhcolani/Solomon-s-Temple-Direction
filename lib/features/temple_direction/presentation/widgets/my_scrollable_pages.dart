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
                      fontSize: 18,
                      color: const Color(0xffe6e3e0),
                    ),
                    children: [
                      const TextSpan(
                          text:
                          'May your eyes be open toward this temple night and day, this place of which you said:\n'),
                      TextSpan(
                        text: 'My Name shall be there\n',
                        style: GoogleFonts.merriweather(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(
                          text:
                          'so that you will hear the prayer your servant prays toward this place.'),
                    ],
                  ),
                ),
              ),
              // Second Page
              Center(
                child: Text(
                  'Second Page',
                  style: GoogleFonts.merriweather(
                    fontSize: 18,
                    color: const Color(0xffe6e3e0),
                  ),
                ),
              ),
              // Third Page
              Center(
                child: Text(
                  'Third Page',
                  style: GoogleFonts.merriweather(
                    fontSize: 18,
                    color: const Color(0xffe6e3e0),
                  ),
                ),
              ),
              // Fourth Page
              Center(
                child: Text(
                  'Fourth Page',
                  style: GoogleFonts.merriweather(
                    fontSize: 18,
                    color: const Color(0xffe6e3e0),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Page Indicator
        SmoothPageIndicator(
          controller: _pageController,
          count: 4,
          effect: ExpandingDotsEffect(
            activeDotColor: Colors.blue,
            dotColor: Colors.grey,
            dotHeight: 8,
            dotWidth: 8,
            spacing: 5.0,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '1 Kings 8:29',
          textAlign: TextAlign.center,
          style: GoogleFonts.merriweather(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: const Color(0xffe6e3e0),
          ),
        ),
      ],
    );
  }
}