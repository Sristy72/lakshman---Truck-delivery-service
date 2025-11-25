import 'package:dartz/dartz.dart';
import 'package:flutter_lakshman1020/core/network/api_client.dart';
import 'package:flutter_lakshman1020/core/network/models/network_failure.dart';
import 'package:flutter_lakshman1020/core/network/models/network_success.dart';
import 'package:flutter_lakshman1020/core/network/constants/api_constants.dart';
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

  /// Corrected getMessages() implementation
  Future<Either<NetworkFailure, NetworkSuccess<List<MessageModel>>>> getMessages(
      String chatId,
      ) async {
    final result = await _apiClient.get<List<MessageModel>>(
      ApiConstants.chat.getAllChats, // no "/$chatId"
      fromJsonT: (json) {
        if (json is Map && json['data'] is List) {
          final chats = json['data'] as List;

          // Find the chat that matches the ID
          final chat = chats.firstWhere(
                (e) => e['_id'] == chatId,
            orElse: () => null,
          );

          if (chat != null && chat['messages'] is List) {
            return (chat['messages'] as List)
                .map((e) => MessageModel.fromJson(e))
                .toList();
          }
        }
        return <MessageModel>[];
      },
    );

    return result;
  }

}
