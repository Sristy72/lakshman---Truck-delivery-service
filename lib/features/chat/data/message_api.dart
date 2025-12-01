import 'package:dartz/dartz.dart';
import 'package:flutter_lakshman1020/core/network/api_client.dart';
import 'package:flutter_lakshman1020/core/network/constants/api_constants.dart';
import 'package:flutter_lakshman1020/core/network/models/network_failure.dart';
import 'package:flutter_lakshman1020/core/network/models/network_success.dart';

import 'models/message_model.dart';

class MessageApi {
  final ApiClient _apiClient = ApiClient();

  /// 🔹 Send Message
  Future<Either<NetworkFailure, NetworkSuccess<List<MessageModel>>>> sendMessage({
    required String chatId,
    required String message,
  }) async {
    final data = {"chatId": chatId, "message": message};

    final result = await _apiClient.post<List<MessageModel>>(
      ApiConstants.chat.sendMessage,
      data: data,
      fromJsonT: (json) {
        if (json is Map && json['messages'] is List) {
          return (json['messages'] as List)
              .map((e) => MessageModel.fromJson(e))
              .toList();
        }
        return <MessageModel>[];
      },
    );
    return result;
  }

  /// Get messages for a specific chat ID
  Future<Either<NetworkFailure, NetworkSuccess<List<MessageModel>>>> getMessages(
      String chatId,
      ) async {
    print('📡 Fetching messages for chatId: $chatId');
    final result = await _apiClient.get<List<MessageModel>>(
      ApiConstants.chat.getAllChats,
      fromJsonT: (json) {
        print('📦 Received API response: ${json.toString().substring(0, json.toString().length > 200 ? 200 : json.toString().length)}...');
        
        // The API returns an array of chat objects directly
        if (json is List) {
          print('✅ Response is a List with ${json.length} chats');
          
          // Find the chat that matches the ID
          final chat = json.firstWhere(
                (e) => e['_id'] == chatId,
            orElse: () => null,
          );

          if (chat != null) {
            print('✅ Found chat with ${chat['messages']?.length ?? 0} messages');
            
            if (chat['messages'] is List) {
              final messages = (chat['messages'] as List)
                  .map((e) => MessageModel.fromJson(e))
                  .toList();
              print('✅ Parsed ${messages.length} messages successfully');
              return messages;
            }
          } else {
            print('⚠️ Chat with ID $chatId not found in response');
          }
        } else {
          print('❌ Response is not a List: ${json.runtimeType}');
        }
        return <MessageModel>[];
      },
    );

    return result;
  }

}
