import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_health/app/modules/calories_screen/views/calories_screen_view.dart';
import 'package:smart_health/app/modules/profile_screen/views/profile_screen_view.dart';
import 'package:smart_health/app/routes/app_pages.dart';

import '../../../data/service/common_function.dart';
import '../../sleep/model/sleep_record_model.dart';
import '../../waking_activity/views/waking_activity_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(
            () => controller.currentTabIndex.value == 0
                ? HomePageActivity(context)
                : (controller.currentTabIndex.value == 1
                    ? WalkingActivityView()
                    : (controller.currentTabIndex.value == 2
                        ? CaloriesScreen()
                        : (controller.currentTabIndex.value == 3 ? ProfileScreenView() : SizedBox()))),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage("assets/images/user.jpg"), // Replace with your image
        ),
        SizedBox(
          width: 10,
        ),
        Text("Raj Javiya", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      margin: EdgeInsets.symmetric(
        horizontal: 15,
      ).copyWith(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: controller.currentTabIndex.value == 0 ? Colors.black : Colors.white, borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () {
                      controller.onTabChange(0);
                    },
                    color: controller.currentTabIndex.value == 0 ? Colors.white : Colors.grey)),
            Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: controller.currentTabIndex.value == 1 ? Colors.black : Colors.white, borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                    icon: const Icon(Icons.directions_walk_rounded),
                    onPressed: () {
                      controller.onTabChange(1);
                    },
                    color: controller.currentTabIndex.value == 1 ? Colors.white : Colors.grey)),
            Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: controller.currentTabIndex.value == 2 ? Colors.black : Colors.white, borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                    icon: const Icon(Icons.local_fire_department),
                    onPressed: () {
                      controller.onTabChange(2);
                    },
                    color: controller.currentTabIndex.value == 2 ? Colors.white : Colors.grey)),
            Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: controller.currentTabIndex.value == 3 ? Colors.black : Colors.white, borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      controller.onTabChange(3);
                    },
                    color: controller.currentTabIndex.value == 3 ? Colors.white : Colors.grey)),
          ],
        ),
      ),
    );
  }

  String getPageTitle(int index) {
    String title = "";
    if (index == 0) {
      title = "Your Activity";
    } else if (index == 1) {
      title = "Walking Activity";
    } else if (index == 2) {
      title = "Calories Activity";
    } else {
      title = "Your Profile";
    }
    return title;
  }
}

class BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final barHeights = [15.0, 20.0, 10.0, 25.0, 18.0];
    final spacing = size.width / (barHeights.length * 2);

    for (int i = 0; i < barHeights.length; i++) {
      double x = spacing * (2 * i + 1);
      double y = size.height;
      canvas.drawLine(Offset(x, y), Offset(x, y - barHeights[i]), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomePageActivity extends GetView<HomeController> {
  final BuildContext context;

  const HomePageActivity(this.context, {super.key});

  @override
  Widget build(BuildContext _) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        Text("Your Activity", style: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildActivitySection(context),
        const SizedBox(height: 16),
        Obx(() => AlertsCarousel(
              alerts: controller.alerts.value,
            )),
        const SizedBox(height: 16),
        Obx(() => _buildTotalSleepCard(controller.sleepMinutes)),
      ],
    );
  }

  Widget _buildActivitySection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main card
        Expanded(
          flex: 2,
          child: _buildMainActivityCard(context),
        ),
        const SizedBox(width: 16),
        // Stacked cards
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Obx(() => _buildMiniCard("${controller.burnedCalories.value} kcal", "Calories", Icons.local_fire_department, const Color(0xFFD0ECE7))),
              const SizedBox(height: 16),
              Obx(() => _buildMiniCard("${controller.waterIntakeGoal.value} L", "Water Intake", Icons.water_drop, const Color(0xFFE8DAEF))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainActivityCard(BuildContext context) {
    return Container(
      height: 240 + 16,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(right: 10, top: 10, child: _buildActivityIcon(Icons.directions_walk)),
          Positioned(
            left: 10,
            top: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text("${controller.walkingKm.value} km", style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold))),
                Text("Walking", style: GoogleFonts.roboto(color: Colors.grey, fontSize: 16)),
              ],
            ),
          ),
          // Minimal chart
          Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: SizedBox(child: Obx(() => _buildSleepGraph(context, 100, 10, Colors.black, controller.walkingKms)))),
          // Positioned(
          //   left: 10, right: 10, bottom: 10,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: ["M", "T", "W", "T", "F", "S", "S"]
          //         .map(
          //           (e) => SizedBox(
          //             width: 10,
          //             child: Text(e),
          //           ),
          //         )
          //         .toList(),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildActivityIcon(IconData data) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
      child: Icon(data, color: Colors.black),
    );
  }

  Widget _buildMiniCard(String value, String label, IconData icon, Color bgColor) {
    return Container(
      height: 120,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(top: 10, right: 10, child: _buildActivityIcon(icon)),
          Positioned(
            bottom: 10,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(label, style: GoogleFonts.roboto(color: Colors.grey, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepGraph(BuildContext context, double height, double width, Color color, List<double> data) {
    double maxVal = data.reduce((a, b) => a > b ? a : b);
    List<String> days = ["M", "T", "W", "T", "F", "S", "S"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.asMap().entries.map((entry) {
        int index = entry.key;
        double val = entry.value;

        double barHeight = maxVal == 0 ? 0 : (val / maxVal) * height;
        bool isHighlighted = val >= 5;

        return Expanded(
          child: Column(
            children: [
              AnimatedContainer(
                key: ValueKey(index),
                // optional but useful
                duration: const Duration(milliseconds: 300),
                width: width,
                height: barHeight,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                days[index],
                style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w800),
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWowCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD0ECE7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events, color: Colors.black, size: 25),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Wow! You made it!",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Congratulations! You walked 5% more than the previous month. Keep it up 👏",
                  style: GoogleFonts.roboto(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSleepCard(List<double> sleepData) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total sleep", style: GoogleFonts.roboto(color: Colors.black, fontSize: 16)),
              const SizedBox(height: 4),
              Obx(() => Text(formatDuration(controller.sleepMinutes[DateTime.now().weekday - 1]),
                  style: GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.bold))),
              const SizedBox(height: 12),
              _buildSleepGraph(Get.context!, 150, 50, Colors.orange, sleepData),
            ],
          ),
        ),
        Positioned(
            right: 20,
            top: 20,
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.grey)),
              child: IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.SLEEP);
                  },
                  icon: Transform.rotate(angle: 1, child: Icon(Icons.arrow_upward))),
            ))
      ],
    );
  }
}

class AlertsCarousel extends StatelessWidget {
  final List<AlertModel> alerts;

  const AlertsCarousel({super.key, required this.alerts});

  Color _getBackgroundColor(String type) {
    switch (type) {
      case 'walking':
        return const Color(0xFFD0ECE7); // light green
      case 'calories':
        return const Color(0xFFFFE0B2); // light orange
      case 'sleep':
        return const Color(0xFFD6EAF8); // light blue
      case 'water':
        return const Color(0xFFEBDEF0); // light purple
      default:
        return Colors.grey.shade200;
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'walking':
        return Icons.directions_walk;
      case 'calories':
        return Icons.local_fire_department;
      case 'sleep':
        return Icons.bedtime;
      case 'water':
        return Icons.local_drink;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 110,
        viewportFraction: 1.0, // 👈 full width
        enlargeCenterPage: false,
        enableInfiniteScroll: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
      ),
      items: alerts.map((alert) {
        final type = alert.type ?? 'info';
        final message = alert.message ?? '';
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getBackgroundColor(type),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIcon(type),
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
