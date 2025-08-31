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
        child: Obx(
          () => controller.currentTabIndex.value == 0
              ? HomePageActivity(context)
              : (controller.currentTabIndex.value == 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: WalkingActivityView(),
                    )
                  : (controller.currentTabIndex.value == 2
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CaloriesScreen(),
                        )
                      : (controller.currentTabIndex.value == 3
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: ProfileScreenView(),
                            )
                          : SizedBox()))),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Activity", style: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildActivitySection(context),
              const SizedBox(height: 16),

              // 👇 New Health Section
              _buildHealthSection(context),

              const SizedBox(height: 16),
            ],
          ),
        ),
        Obx(() => AlertsCarousel(
              controller: controller,
              list: controller.alerts.value,
            )),
        const SizedBox(height: 16),
        Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildTotalSleepCard(controller.sleepMinutes),
            )),
      ],
    );
  }

  // ------------------------
  // EXISTING ACTIVITY CARDS
  // ------------------------
  Widget _buildActivitySection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Walking card
        Expanded(
          flex: 2,
          child: _buildMainActivityCard(context),
        ),
        const SizedBox(width: 16),
        // Calories + Water
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Obx(() => _buildMiniCard(
                    "${controller.burnedCalories.value} kcal",
                    "Calories",
                    Icons.local_fire_department,
                    const Color(0xFFD0ECE7),
                    () {
                      controller.onTabChange(2);
                    },
                  )),
              const SizedBox(height: 16),
              Obx(() => _buildMiniCard(
                    "${controller.waterIntakeGoal.value} L",
                    "Water Intake",
                    Icons.water_drop,
                    const Color(0xFFE8DAEF),
                    () {
                      controller.onTabChange(3);
                    },
                  )),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------
  // NEW HEALTH CARDS SECTION
  // ------------------------
  Widget _buildHealthSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(() => _buildMiniCard(
                "${controller.oxygenLevel.value} %",
                "Oxygen",
                Icons.bloodtype,
                const Color(0xFFFFEBEE),
                () {}, // can navigate to oxygen details
              )),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(() => _buildMiniCard(
                "${controller.bodyTemperature.value} °C",
                "Temperature",
                Icons.device_thermostat,
                const Color(0xFFE3F2FD),
                () {},
              )),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(() => _buildMiniCard(
                "${controller.heartBeat.value} bpm",
                "Heart Beat",
                Icons.favorite,
                const Color(0xFFFCE4EC),
                () {},
              )),
        ),
      ],
    );
  }

  Widget _buildMainActivityCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.onTabChange(1);
      },
      child: Container(
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
          ],
        ),
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

  Widget _buildMiniCard(String value, String label, IconData icon, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildSleepGraph(
    BuildContext context,
    double height,
    double width,
    Color color,
    List<double> data,
  ) {
    double maxVal = data.reduce((a, b) => a > b ? a : b);
    List<String> days = ["M", "T", "W", "T", "F", "S", "S"];
    int today = DateTime.now().weekday - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.asMap().entries.map((entry) {
        int index = entry.key;
        double val = entry.value;

        double barHeight = maxVal == 0 ? 0 : (val / maxVal) * height;
        bool isToday = index == today;

        return Expanded(
          child: Column(
            children: [
              // Animated bar
              AnimatedContainer(
                key: ValueKey(index),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                width: width,
                height: barHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.6), color],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isToday
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.6),
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
              ),
              const SizedBox(height: 10),
              // Day label
              Text(
                days[index],
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              )
            ],
          ),
        );
      }).toList(),
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
  final HomeController controller;
  final List<AlertModel> list;

  const AlertsCarousel({super.key, required this.controller, required this.list});

  LinearGradient _getGradient(String type) {
    switch (type) {
      case 'walking':
        return const LinearGradient(colors: [Color(0xFF00C9A7), Color(0xFF92FE9D)], begin: Alignment.topLeft, end: Alignment.bottomRight);
      case 'calories':
        return const LinearGradient(colors: [Color(0xFFFF512F), Color(0xFFF09819)], begin: Alignment.topLeft, end: Alignment.bottomRight);
      case 'sleep':
        return const LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)], begin: Alignment.topLeft, end: Alignment.bottomRight);
      case 'water':
        return const LinearGradient(colors: [Color(0xFF00C6FF), Color(0xFF0072FF)], begin: Alignment.topLeft, end: Alignment.bottomRight);
      default:
        return LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade100], begin: Alignment.topLeft, end: Alignment.bottomRight);
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'walking':
        return Icons.directions_walk_rounded;
      case 'calories':
        return Icons.local_fire_department;
      case 'sleep':
        return Icons.bedtime_rounded;
      case 'water':
        return Icons.water_drop;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller.alerts.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: controller.alerts.length,
          itemBuilder: (context, index, realIndex) {
            final alert = controller.alerts[index];
            final type = alert.type ?? 'info';
            final message = alert.message ?? '';

            return Container(
              // margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: _getGradient(type),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 6))],
              ),
              child: Row(
                children: [
                  // Animated Icon Circle
                  AnimatedScale(
                    duration: const Duration(milliseconds: 500),
                    scale: 1,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: Icon(
                        _getIcon(type),
                        size: 32,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Text section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type.toUpperCase(),
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.3,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          message,
                          style: GoogleFonts.roboto(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 140,
            viewportFraction: 0.95,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              controller.alertCurrentIndex.value = index;
            },
            autoPlayInterval: const Duration(seconds: 5),
          ),
        ),
        const SizedBox(height: 8),
        // Smooth indicator
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.alerts.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.alertCurrentIndex.value == index ? Colors.blue : Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          );
        })
      ],
    );
  }
}
