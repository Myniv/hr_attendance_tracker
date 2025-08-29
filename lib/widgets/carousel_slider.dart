import 'package:animated_item/animated_item.dart';
import 'package:flutter/material.dart';
import 'package:hr_attendance_tracker/custom_theme.dart';

class CarouselSlider extends StatefulWidget {
  const CarouselSlider({Key? key}) : super(key: key);

  @override
  State<CarouselSlider> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Request Time-Off',
      'subtitle': 'Now you can request time-off directly from the app!',
      'description':
          'Quick and easy time-off requests with instant notifications',
      'gradient': [Colors.blue.shade400, Colors.purple.shade600],
      'icon': Icons.calendar_today,
    },
    {
      'title': 'Performance Review',
      'subtitle': 'New: Performance review available on mobile!',
      'description': 'Access your performance metrics and feedback anywhere',
      'gradient': [Colors.green.shade400, Colors.teal.shade600],
      'icon': Icons.star,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return AnimatedPage(
                controller: _pageController,
                effect: FadeEffect(),
                index: index,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: banner['gradient'],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: banner['gradient'][0].withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                banner['icon'],
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Text(
                                banner['title'],
                                style: CustomTheme().smallFont(
                                  Colors.white,
                                  null,
                                  context,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Text(
                          banner['subtitle'],
                          style: CustomTheme().superSmallFont(
                            Colors.white,
                            null,
                            context,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          banner['description'],
                          style: CustomTheme().superSmallFont2(
                            Colors.white,
                            FontWeight.normal,
                            context,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const Spacer(),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Learn More',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? _banners[_currentPage]['gradient'][0]
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
