// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// // import 'package:flutter_paypal/flutter_paypal.dart';


// class MakePaymentScreen extends StatefulWidget {
//   const MakePaymentScreen({super.key});

//   @override
//   State<MakePaymentScreen> createState() => _MakePaymentScreenState();
// }

// class _MakePaymentScreenState extends State<MakePaymentScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       key: _scaffoldKey,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(45.0),
//         child: new AppBar(
//           backgroundColor: Colors.white,
//           title: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Payment',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Open Sans',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: TextButton(
//              onPressed: () => {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => UsePaypal(
//                       sandboxMode: true,
//                       clientId:
//                           "AR4N5p341zIc7azXwBya52hBjv1vldaSnAyg5O8LKM1UrNpZB3uufIyyvv0qwu9ZvqEP7oZvPMaAY_ar",
//                       secretKey:
//                           "EFhY54PCoKjjPT9wrACIwxnlPhS3y0FVXDn3fIqDYfntr2ESeLQpJqBy4Au6V7Pj9dfPRdE2IHke5TIY",
//                       returnURL: "https://samplesite.com/return",
//                       cancelURL: "https://samplesite.com/cancel",
//                       transactions: const [
//                         {
//                           "amount": {
//                             "total": '10.12',
//                             "currency": "USD",
//                             "details": {
//                               "subtotal": '10.12',
//                               "shipping": '0',
//                               "shipping_discount": 0
//                             }
//                           },
//                           "description": "The payment transaction description.",
//                           // "payment_options": {
//                           //   "allowed_payment_method":
//                           //       "INSTANT_FUNDING_SOURCE"
//                           // },
//                           "item_list": {
//                             "items": [
//                               {
//                                 "name": "A demo product",
//                                 "quantity": 1,
//                                 "price": '10.12',
//                                 "currency": "USD"
//                               }
//                             ],
//                           }
//                         }
//                       ],
//                       note: "Contact us for any questions on your order.",
//                       onSuccess: (Map params) async {
//                         print("onSuccess: $params");
//                       },
//                       onError: (error) {
//                         print("onError: $error");
//                       },
//                       onCancel: (params) {
//                         print('cancelled: $params');
//                       }),
//                 ),
//               )
//             },
//             style: ButtonStyle(
//               backgroundColor:
//                   MaterialStateProperty.resolveWith((states) => Colors.blue),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image(
//                   image: AssetImage('assets/images/paypal.png'),
//                   height: 40,
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Text(
//                   'Pay with Paypal',
//                   style: TextStyle(
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }