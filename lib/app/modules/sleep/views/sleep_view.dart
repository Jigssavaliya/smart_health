import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smart_health/app/modules/sleep/controllers/sleep_controller.dart';

import '../../../data/service/common_function.dart';

class SleepView extends GetView<SleepController> {
  const SleepView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Sleep Health",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          RefreshIndicator(
            color: Colors.teal,
            onRefresh: () async {
              await controller.initData(isLoading: false);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Moved filter button here
                  _filterCard(context),
                  const SizedBox(height: 20),
                  _headerCard(),
                  const SizedBox(height: 8),
                  Obx(() {
                    return Visibility(
                      visible: controller.sleepSuggestion.isNotEmpty,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: Colors.teal.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title Row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.lightbulb_rounded, color: Colors.teal, size: 28),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Sleep Suggestions",
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.teal.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Suggestion List
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    controller.sleepSuggestion.length,
                                        (index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "• ",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.teal,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                controller.sleepSuggestion[index],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.teal.shade800,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  Obx(
                    () => controller.records.value != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _metricCard(
                                title: "Sleep Duration",
                                value: formatDuration(controller.records.value?.durationMinutes ?? 0),
                                icon: Icons.bedtime,
                                subtitle: "Last Night",
                                bgColor: const Color(0xFFE9F2FF),
                                iconColor: const Color(0xFF347AE2),
                                textColor: const Color(0xFF1B3C7F),
                              ),
                              const SizedBox(height: 14),
                              _metricCard(
                                title: "Sleep Quality",
                                value: controller.records.value?.quality ?? "",
                                icon: Icons.nightlight_round,
                                subtitle: "Based on movement",
                                bgColor: const Color(0xFFD9F4EC),
                                iconColor: const Color(0xFF2EAF7D),
                                textColor: const Color(0xFF0C6345),
                              ),
                              const SizedBox(height: 14),
                              _metricCard(
                                title: "Bedtime Consistency",
                                value: controller.records.value?.bedtimeConsistency ?? "",
                                icon: Icons.schedule,
                                subtitle: "Last 7 days",
                                bgColor: const Color(0xFFFFF1D8),
                                iconColor: const Color(0xFFF6A800),
                                textColor: const Color(0xFFB26900),
                              ),
                              const SizedBox(height: 26),
                              Text(
                                "Sleep Tips",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Column(
                                children: controller.tips.map((element) => _tipTile(element.tipText ?? "", element.icon ?? "")).toList(),
                              )
                            ],
                          )
                        : controller.isLoading.value
                            ? SizedBox.shrink()
                            : Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: Colors.grey[100],
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.data_object,
                                        size: 50,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "No Sleep Data",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "We couldn’t find any sleep records for the selected date.",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                  ),
                ],
              ),
            ),
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

  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Sleep Summary",
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Track and improve your sleep for better health.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required IconData icon,
    required String subtitle,
    required Color bgColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.15),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tipTile(String tip, String icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F2FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              shape: BoxShape.circle,
            ),
            child: Text(
              icon,
              style: GoogleFonts.openSans(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: const Color(0xFF3A3A3A),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: const Color(0xFF3A3A3A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
