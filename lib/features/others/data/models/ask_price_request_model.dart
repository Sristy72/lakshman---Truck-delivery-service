class AskPriceRequestModel {
  final double askPrice;

  AskPriceRequestModel({
    required this.askPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'askPrice': askPrice,
    };
  }
}
