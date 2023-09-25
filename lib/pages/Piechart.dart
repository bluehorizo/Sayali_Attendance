//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:pie_chart/pie_chart.dart';
// import 'package:provider/provider.dart';
//
// import '../operations/pacientFormOpeation.dart';
//
// class activeInavtivePieChart extends StatefulWidget {
//   const activeInavtivePieChart({Key? key}) : super(key: key);
//
//   @override
//   activeInavtivePieChartState createState() => activeInavtivePieChartState();
// }
//
// class activeInavtivePieChartState extends State<activeInavtivePieChart> {
//   late int activeAssetLength = 0, inactiveAssetLength = 0;
//   @override
//   void initState() {
//     activeAssetLength =
//         Provider.of<PacientForamOperation>(context, listen: false)
//             .WholeSheetDataList
//             .length;
//     inactiveAssetLength =
//     (Provider.of<PacientForamOperation>(context, listen: false)
//         .AssetMasterData
//         .length -
//         Provider.of<PacientForamOperation>(context, listen: false)
//             .WholeSheetDataList
//             .length);
//
//     super.initState();
//   }
//
//   final dataMap = <String, double>{"Active": 0, "Disposed": 0};
//
//
//
//
//
//   final gradientList = <List<Color>>[
//     [
//       Colors.green.shade900,
//       Colors.green.shade300,
//       Colors.green.shade900,
//
//     ],
//     [
//       Colors.red.shade900,
//       Colors.red.shade300,
//       Colors.red.shade900,
//     ],
//     [
//       const Color.fromRGBO(129, 182, 205, 1),
//       const Color.fromRGBO(91, 253, 199, 1),
//     ],
//     [
//       const Color.fromRGBO(175, 63, 62, 1.0),
//       const Color.fromRGBO(254, 154, 92, 1),
//     ]
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     dataMap['Active'] = double.parse(activeAssetLength.toString());
//     dataMap['Disposed'] = double.parse(inactiveAssetLength.toString());
//     print(Provider.of<PacientForamOperation>(context, listen: false)
//         .WholeSheetDataList
//         .length);
//
//     print(inactiveAssetLength);
//     print(activeAssetLength.toString());
//     return FutureBuilder(
//         future:
//         Provider.of<PacientForamOperation>(context, listen: false)
//             .getAssetFromSheet().then((value) {
//           // Provider.of<AssetMasterOperations>(context, listen: false).getVerifiedAssetLength();
//         }),
//         builder: (context, dataSnapshot) {
//           if (dataSnapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             if (dataSnapshot.error != null) {
//               return Center(
//                 child: Text('An error occured'),
//               );
//             } else {
//               return  Container(
//
//
//                 padding: const EdgeInsets.all(10.0),
//
//                 child: Column(
//                   children: [
//                     PieChart(
//                       dataMap: dataMap,
//                       animationDuration: Duration(milliseconds: 800),
//                       chartLegendSpacing: 50,
//                       chartRadius: 100,
//                       initialAngleInDegree: 0,
//                       chartType: ChartType.ring,
//                       centerText: "Asset",
//                       legendOptions: LegendOptions(
//                         showLegendsInRow: false,
//                         legendPosition: LegendPosition.right,
//                         showLegends: true,
//                         legendShape:  BoxShape.circle,
//
//                         legendTextStyle: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black
//
//                         ),
//                       ),
//                       chartValuesOptions: ChartValuesOptions(
//                         showChartValueBackground: true,
//                         showChartValues: true,
//                         showChartValuesInPercentage: true,
//                         showChartValuesOutside: true,
//                       ),
//                       ringStrokeWidth: 50,
//                       emptyColor: Colors.grey,
//                       gradientList:  gradientList,
//
//                       baseChartColor: Colors.transparent,
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Text("Active :${activeAssetLength}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
//                         SizedBox(width: 20,),
//
//                         Text("Disposed :${inactiveAssetLength}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//
//                   ],
//                 ),
//               );
//             }
//           }
//         });
//
//   }
// }