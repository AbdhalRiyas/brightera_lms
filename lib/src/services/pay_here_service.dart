import 'package:flutter/material.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

class PayHereService {
  PayHereService._privateConstructor();

  static final PayHereService _instance = PayHereService._privateConstructor();

  factory PayHereService() {
    return _instance;
  }

  void processPayment(VoidCallback toggleOverlay) async {
    Map paymentObject = {
      "sandbox": true, // true if using Sandbox Merchant ID
      "merchant_id": "1228362", // Replace your Merchant ID
      "merchant_secret":
          "MzcwMDgyMzkwMTM3NDIzNjY2MDQyMjI3NTQzODMzODU1NTMyMzc=", // See step 4e
      "notify_url": "http://sample.com/notify",
      "order_id": "ItemNo12345",
      "items": "Hello from Flutter!",
      "amount": "50.00",
      "currency": "LKR",
      "first_name": "Saman",
      "last_name": "Perera",
      "email": "samanp@gmail.com",
      "phone": "0771234567",
      "address": "No.1, Galle Road",
      "city": "Colombo",
      "country": "Sri Lanka",
      "delivery_address": "No. 46, Galle road, Kalutara South",
      "delivery_city": "Kalutara",
      "delivery_country": "Sri Lanka",
      "custom_1": "",
      "custom_2": ""
    };

    toggleOverlay();

    PayHere.startPayment(paymentObject, (paymentId) {
      print("One Time Payment Success. Payment Id: $paymentId");
    }, (error) {
      print("One Time Payment Failed. Error: $error");
    }, () {
      toggleOverlay();
      print("One Time Payment Dismissed");
    });
  }
}
