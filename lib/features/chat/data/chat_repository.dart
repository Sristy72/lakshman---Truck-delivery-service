import 'package:dartz/dartz.dart';
import 'package:flutter_lakshman1020/core/network/models/network_failure.dart';
import 'package:flutter_lakshman1020/core/network/models/network_success.dart';

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
}
