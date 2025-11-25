import 'package:dartz/dartz.dart';
import 'package:flutter_lakshman1020/core/network/api_client.dart';
import 'package:flutter_lakshman1020/core/network/models/network_failure.dart';
import 'package:flutter_lakshman1020/core/network/models/network_success.dart';
import 'package:flutter_lakshman1020/core/network/constants/api_constants.dart';
import 'models/chat_model.dart';

class ChatApi {
  final ApiClient _apiClient = ApiClient();

  /// 🔹 Fetch All Chats for Logged-In User
  Future<Either<NetworkFailure, NetworkSuccess<List<ChatModel>>>> getAllChats() async {
    final result = await _apiClient.get<List<ChatModel>>(
      ApiConstants.chat.getAllChats,
      fromJsonT: (json) {
        if (json is List) {
          return json.map((e) => ChatModel.fromJson(e)).toList();
        }
        return <ChatModel>[];
      },
    );
    return result;
  }
}
