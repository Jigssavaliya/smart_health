import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../data/service/common_function.dart';
import '../controllers/calories_screen_controller.dart';

class CaloriesScreen extends GetView<CaloriesScreenController> {
  const CaloriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ListView(
          children: [
            const SizedBox(height: 16),
            Text("Calories Activity", style: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            /// Top summary
            _filterCard(context),
            const SizedBox(height: 16),
            Obx(
              () => controller.records.value != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Obx(() => _summaryCard(
                                      "Intake",
                                      (controller.records.value?.caloriesIntake ?? 0).toString(),
                                      "kcal",
                                      [Colors.blue.shade300, Colors.blue.shade100],
                                      Icons.fastfood_outlined,
                                    )),
                                Obx(() => _summaryCard(
                                      "Burned",
                                      (controller.records.value?.caloriesBurned ?? 0).toString(),
                                      "kcal",
                                      [Colors.orange.shade300, Colors.orange.shade100],
                                      Icons.local_fire_department_outlined,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Obx(() => _summaryCard(
                                      "Remaining",
                                      ((controller.records.value?.goalCalories ?? 0) - (controller.records.value?.caloriesBurned ?? 0)).toString(),
                                      "kcal",
                                      [Colors.purple.shade300, Colors.purple.shade100],
                                      Icons.access_time,
                                    )),
                                Obx(() => _summaryCard(
                                      "Goal",
                                      (controller.records.value?.goalCalories ?? 0).toString(),
                                      "kcal",
                                      [Colors.green.shade300, Colors.green.shade100],
                                      Icons.flag_outlined,
                                    )),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        /// Top Calorie Sources
                        Text(
                          "Top Sources",
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Obx(
                          () => Column(
                            children: List.generate(
                              (controller.records.value?.sources ?? []).length,
                              (index) {
                                return _foodTile(
                                    "${(controller.records.value?.sources ?? [])[index].mealType} - ${(controller.records.value?.sources ?? [])[index].mealName}",
                                    "${(controller.records.value?.sources ?? [])[index].calories ?? ""} kcal",
                                    formatUtcToLocalTime((controller.records.value?.sources ?? [])[index].time ?? ""),
                                    controller.getSourceIcon((controller.records.value?.sources ?? [])[index]),
                                    controller.getSourceColor((controller.records.value?.sources ?? [])[index]));
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        /// Graph (Placeholder)
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(child: Text("Graph coming soon...")),
                        ),
                        const SizedBox(height: 24),
                      ],
                    )
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
            )
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

  Widget _summaryCard(
    String title,
    String value,
    String unit,
    List<Color> gradient,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 🔹 Title + Icon Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: Colors.black87),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// 🔹 Value
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            /// 🔹 Unit
            Text(
              unit,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _foodTile(String title, String calories, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            calories,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
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
