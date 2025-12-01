import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StripeServices {
  /// Make payment using the client secret from backend
  Future<String?> makePaymentWithClientSecret({required String clientSecret}) async {
    try {
      print('🔵 Using Client Secret from backend: $clientSecret');

      // Extract Payment Intent ID from client secret
      // Client secret format: pi_xxxxx_secret_yyyyy
      final paymentIntentId = clientSecret.split('_secret_')[0];
      print('🔑 Extracted Payment Intent ID: $paymentIntentId');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Lakshman Merchant',
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      
      // After successful payment, retrieve the payment intent details
      try {
        final paymentIntent = await Stripe.instance.retrievePaymentIntent(clientSecret);
        print('💰 Payment Intent Details from Stripe:');
        print('   - Payment Intent ID: ${paymentIntent.id}');
        print('   - Status: ${paymentIntent.status}');
        print('   - Amount: ${paymentIntent.amount}');
        print('   - Currency: ${paymentIntent.currency}');
        print('   - Created: ${paymentIntent.created}');
        
        Fluttertoast.showToast(msg: 'Payment successfully completed');
        
        // Return the payment intent ID
        return paymentIntent.id;
      } catch (retrieveError) {
        print('⚠️ Could not retrieve payment intent details: $retrieveError');
        print('✅ Payment completed successfully with Payment Intent ID: $paymentIntentId');
        
        Fluttertoast.showToast(msg: 'Payment successfully completed');
        
        // Return the extracted payment intent ID even if retrieval fails
        return paymentIntentId;
      }
    } on StripeException catch (e) {
      Fluttertoast.showToast(msg: 'Stripe error: ${e.error.localizedMessage}');
      rethrow;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }
}
