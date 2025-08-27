import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smart_health/app/data/service/common_function.dart';

import '../controllers/waking_activity_controller.dart';

class WalkingActivityView extends GetView<WakingActivityController> {
  const WalkingActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ListView(
          children: [
            const SizedBox(height: 8),
            Text(
              "Walking Activity",
              style: GoogleFonts.roboto(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 28),
            _filterCard(context),
            SizedBox(
              height: 20,
            ),

            /// 🔹 Stats Grid
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => _statCard(
                      title: "Distance",
                      value: "${controller.records.value?.distanceKm ?? "0"} km",
                      icon: Icons.map_outlined,
                      gradient: [Colors.blue.shade300, Colors.blue.shade100],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => _statCard(
                      title: "Calories",
                      value: "${controller.records.value?.caloriesKcal ?? "0"} kcal",
                      icon: Icons.local_fire_department_outlined,
                      gradient: [Colors.orange.shade300, Colors.orange.shade100],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => _statCard(
                      title: "Active Time",
                      value: formatDuration(controller.records.value?.activeMinutes ?? 0),
                      icon: Icons.timer_outlined,
                      gradient: [Colors.purple.shade300, Colors.purple.shade100],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => _statCard(
                      title: "Pace",
                      value: "${controller.records.value?.paceMinPerKm ?? "0"} min/km",
                      icon: Icons.speed_outlined,
                      gradient: [Colors.green.shade300, Colors.green.shade100],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            /// 🔹 Tips Section
            Obx(() => tipsSection(controller.tips))
          ],
        ),
        Obx(
          () => controller.isLoading.value
              ? LoadingAnimationWidget.threeArchedCircle(
                  color: Colors.teal,
                  size: 60,
                )
              : const SizedBox.shrink(),
        )
      ],
    );
  }

  Widget tipsSection(List<Map<String, dynamic>> tips) {
    if (tips.isEmpty) {
      return const SizedBox.shrink(); // No tips if no records
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade50, Colors.teal.shade100.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 5,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Personalized Tips",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.teal.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Dynamic Tips List
          ...tips.map((tip) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      tip["icon"] as IconData,
                      size: 20,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip["text"] as String,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 🔹 Stat Card with Gradient
  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.black87),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterCard(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => _openFilterSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [
                Colors.teal.withOpacity(0.12),
                Colors.teal.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.teal.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.filter_list, color: Colors.teal, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    controller.selectedDateFilter.value,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.teal.shade900,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.teal)
            ],
          ),
        ),
      ),
    );
  }

  /// Open bottom sheet filter picker with better UI and date picker
  void _openFilterSheet(BuildContext context) {
    final filters = [
      "Today",
      "Yesterday",
    ];

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              "Select Date",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            ...filters.map((filter) {
              return Obx(() {
                final isSelected = controller.selectedDateFilter.value == filter;
                return GestureDetector(
                  onTap: () {
                    controller.changeFilter(filter);
                    Get.back();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal.withOpacity(0.12) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.teal : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          color: isSelected ? Colors.teal : Colors.grey,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          filter,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.teal : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            }),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Colors.teal,
                          onPrimary: Colors.white,
                          onSurface: Colors.black87,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (picked != null) {
                  String formatDate(DateTime date) {
                    int day = date.day;
                    String suffix = "th";
                    if (!(day >= 11 && day <= 13)) {
                      switch (day % 10) {
                        case 1:
                          suffix = "st";
                          break;
                        case 2:
                          suffix = "nd";
                          break;
                        case 3:
                          suffix = "rd";
                          break;
                      }
                    }
                    String month = [
                      "January",
                      "February",
                      "March",
                      "April",
                      "May",
                      "June",
                      "July",
                      "August",
                      "September",
                      "October",
                      "November",
                      "December"
                    ][date.month - 1];
                    return "$day$suffix $month";
                  }

                  controller.changeFilter(formatDate(picked), date: picked);
                  Get.back();
                }
              },
              icon: const Icon(Icons.date_range, color: Colors.white),
              label: Text(
                "Custom Date",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
