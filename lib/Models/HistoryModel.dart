// import 'package:cloud_firestore/cloud_firestore.dart';

// class HistoryModel {
//   String
//     number,
//     qrID,
//     queuerID,
//     scannerId,
//     status,
//     storeId,
//     id;

//   int position;
//   DateTime date;

//   HistoryModel( String id, Map<dynamic, dynamic> data ) {
//     this.id = id ?? "";
//     this.position = data["position"] ?? 0;
//     this.number = data["number"] ?? "";
//     this.qrID = data["qrID"] ?? "";
//     this.queuerID = data["queuerID"] ?? "";
//     this.scannerId = data["scannerId"] ?? "";
//     this.status = data["status"] ?? "";
//     this.storeId = data["storeId"] ?? "";
//     if(data['date'] is DateTime){
//       this.date = data['date'];
//     } else if((data['date'] as Timestamp) != null){
//       this.date = (data['date'] as Timestamp).toDate();
//     }
//   }

//   setHistory() {
//     return {
//       "position" : this.position,
//       "number" : this.number,
//       "qrID" : this.qrID,
//       "queuerID" : this.queuerID,
//       "scannerId" : this.scannerId,
//       "status" : this.status,
//       "storeId" : this.storeId,
//       "date" : this.date,
//     };
//   }
// }