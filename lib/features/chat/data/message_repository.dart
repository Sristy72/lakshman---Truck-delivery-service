import 'package:dartz/dartz.dart';
import 'package:flutter_lakshman1020/core/network/models/network_failure.dart';
import 'message_api.dart';
import 'models/message_model.dart';

class MessageRepository {
  final MessageApi _api = MessageApi();

  Future<Either<NetworkFailure, List<MessageModel>>> sendMessage({
    required String chatId,
    required String message,
  }) async {
    final response = await _api.sendMessage(chatId: chatId, message: message);
    return response.fold(
          (failure) => Left(failure),
          (success) => Right(success.data),
    );
  }

  Future<Either<NetworkFailure, List<MessageModel>>> fetchMessages(
      String chatId) async {
    final response = await _api.getMessages(chatId);
    return response.fold(
          (failure) => Left(failure),
          (success) => Right(success.data),
    );
  }
}
