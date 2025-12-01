import '../payment_repo.dart';

class CreatePaymentIntent {
  final PaymentRepository repository;

  CreatePaymentIntent(this.repository);

  Future<Map<String, dynamic>> call(String amount, String currency) async {
    return repository.createPaymentIntent(amount, currency);
  }
}
