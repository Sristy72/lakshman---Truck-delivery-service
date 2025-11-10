import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignDriverScreen extends StatelessWidget {
  const AssignDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RxList<Map<String, String>> drivers = <Map<String, String>>[
      {
        "name": "Jakob Bator",
        "image": "https://randomuser.me/api/portraits/men/1.jpg"
      },
      {
        "name": "Leo Passaquindici Arcand",
        "image": "https://randomuser.me/api/portraits/men/2.jpg"
      },
      {
        "name": "Charlie Lubin",
        "image": "https://randomuser.me/api/portraits/men/3.jpg"
      },
      {
        "name": "Gustavo Botosh",
        "image": "https://randomuser.me/api/portraits/men/4.jpg"
      },
      {
        "name": "Jakob Botosh",
        "image": "https://randomuser.me/api/portraits/men/5.jpg"
      },
      {
        "name": "Leo Calzoni",
        "image": "https://randomuser.me/api/portraits/men/6.jpg"
      },
      {
        "name": "Alfredo Culhane",
        "image": "https://randomuser.me/api/portraits/men/7.jpg"
      },
      {
        "name": "Justin Passaquindici Arcand",
        "image": "https://randomuser.me/api/portraits/men/8.jpg"
      },
    ].obs;

    RxString searchQuery = ''.obs;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Assign driver",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // 🔍 Search bar
            TextField(
              onChanged: (val) => searchQuery.value = val.toLowerCase(),
              decoration: InputDecoration(
                hintText: "Search",
                filled: true,
                fillColor: Colors.grey.shade100,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Available driver",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Driver list
            Expanded(
              child: Obx(() {
                final filtered = drivers
                    .where((d) =>
                    d["name"]!.toLowerCase().contains(searchQuery.value))
                    .toList();

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                  const Divider(height: 10, color: Colors.transparent),
                  itemBuilder: (context, index) {
                    final driver = filtered[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(driver["image"]!),
                          radius: 22,
                        ),
                        title: Text(
                          driver["name"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            Get.snackbar(
                              "Driver Assigned",
                              "${driver["name"]} assigned successfully!",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.blue.shade50,
                              colorText: Colors.blue.shade900,
                              margin: const EdgeInsets.all(12),
                              duration: const Duration(seconds: 2),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                          ),
                          child: const Text(
                            "Assign",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
