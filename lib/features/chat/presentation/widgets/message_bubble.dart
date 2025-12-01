import 'package:flutter/material.dart';
import '../../data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: isMe ? 80 : 8,  // Sent messages align to the right side, more padding on left
        right: isMe ? 8 : 80,  // Received messages align to the left side, more padding on right
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end  // Sent messages go to the right
            : MainAxisAlignment.start,  // Received messages go to the left
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 16,
              backgroundImage: message.user.avatar.url.isNotEmpty
                  ? NetworkImage(message.user.avatar.url)
                  : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
            ),
          if (!isMe) const SizedBox(width: 8),  // Space between avatar and message bubble

          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end  // Sent message text aligns to the right
                  : CrossAxisAlignment.start,  // Received message text aligns to the left
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isMe
                        ? const Color(0xFFDCF8C6)  // Greenish color for sent messages
                        : const Color(0xFFF1F2F4),  // Light gray color for received messages
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(0),
                      bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(18),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Text(
                    message.text,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.date),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),

          if (isMe) const SizedBox(width: 8),  // Space between avatar and message bubble for sent messages
          if (isMe)
            CircleAvatar(
              radius: 16,
              backgroundImage: message.user.avatar.url.isNotEmpty
                  ? NetworkImage(message.user.avatar.url)
                  : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
            ),
        ],
      ),
    );
  }

  String _formatTime(String date) {
    try {
      final d = DateTime.parse(date).toLocal();
      final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
      final minute = d.minute.toString().padLeft(2, '0');
      final ampm = d.hour >= 12 ? 'pm' : 'am';
      return "$hour:$minute$ampm";
    } catch (_) {
      return '';
    }
  }
}
