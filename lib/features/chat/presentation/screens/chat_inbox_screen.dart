import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
import 'package:get/get.dart';

import '../../controllers/chat_controller.dart';
import 'chat_detail_screen.dart';

class ChatInboxScreen extends StatelessWidget {
  ChatInboxScreen({super.key});
  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Message",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      body: Obx(() {
        final chatList = controller.filteredChatList;

        if (controller.isLoading.value) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            itemCount: 8,
            itemBuilder: (context, index) => const SkeletonListItem(
              hasLeading: true,
              lines: 2,
            ),
          );
        }

        // When inbox and search are both empty
        if (controller.chatList.isEmpty && chatList.isEmpty) {
          return _buildEmptyInbox();
        }

        // When search returns no matches
        if (chatList.isEmpty && controller.chatList.isNotEmpty) {
          return _buildNoResults();
        }

        // Normal Chat List UI
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Inbox title + action icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                children: [
                  const Text(
                    "Inbox",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  const Spacer(),
                  Image.asset('assets/icons/edit.png', width: 20),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert, size: 20),
                  ),
                ],
              ),
            ),

            // 🔍 Search Bar (functional)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: const Color(0xFFE5E9F2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        onChanged: (value) => controller.filterChats(value),
                        decoration: const InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Chat List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                itemCount: chatList.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  indent: 72,
                  color: Color(0xFFF2F2F2),
                ),
                itemBuilder: (_, index) {
                  final chat = chatList[index];
                  return ListTile(
                    onTap: () => Get.to(
                      () => ChatDetailScreen(name: chat.name, chatId: chat.id),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(chat.avatar),
                      radius: 22,
                    ),
                    title: Text(
                      chat.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    trailing: Text(
                      chat.time,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Empty Inbox UI
  Widget _buildEmptyInbox() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/notification1.png', width: 160),
            const SizedBox(height: 16),
            const Text(
              "Your inbox is empty",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              "Start conversation to make it full",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// No search match UI
  Widget _buildNoResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/notification1.png', width: 200),
            const SizedBox(height: 14),
            const Text(
              "No results found",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              "start conversation to make it full",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
