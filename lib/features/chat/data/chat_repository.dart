import 'package:dartz/dartz.dart';
import 'package:flutter_lakshman1020/core/network/models/network_failure.dart';

import 'chat_api.dart';
import 'models/chat_model.dart';

class ChatRepository {
  final ChatApi _chatApi = ChatApi();

  Future<Either<NetworkFailure, List<ChatModel>>> fetchChats() async {
    final response = await _chatApi.getAllChats();

    return response.fold(
          (failure) => Left(failure),
          (success) => Right(success.data),
    );
  }

  Future<Either<NetworkFailure, ChatModel>> fetchSingleChat(String chatId) async {
    final response = await _chatApi.getSingleChat(chatId);

    return response.fold(
          (failure) => Left(failure),
          (success) => Right(success.data),
    );
  }

  Future<Either<NetworkFailure, ChatMessageModel>> sendMessage({
    required String chatId,
    required String message,
  }) async {
    final response = await _chatApi.sendMessage(chatId: chatId, message: message);

    return response.fold(
          (failure) => Left(failure),
          (success) => Right(success.data),
    );
  }

  Future<Either<NetworkFailure, ChatModel>> createChat({
    required String sellerId,
  }) async {
    final response = await _chatApi.createChat(sellerId: sellerId);

    return response.fold(
          (failure) => Left(failure),
          (success) => Right(success.data),
    );
  }
}
