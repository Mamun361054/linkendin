import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkendin/models/book_room.dart';
import 'package:linkendin/models/hotel_model.dart';

class FirebaseDataService {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('linkedin');

  void createAndUpdateUserInfo({map, uid}) {
    _collectionReference
        .doc('linkedin_users')
        .collection('users')
        .doc(uid)
        .set(map);
  }

  void updateUserField({map, uid}) {
    _collectionReference
        .doc('linkedin_users')
        .collection('users')
        .doc(uid.toString())
        .set(map);
  }

  ///return stream type
  Stream<List<HotelListData>> getHotelListAsStream() {
    return _collectionReference
        .doc('hotel_data')
        .collection('hotels')
        .snapshots()
        .map(getHotelListAsStreamFireStore);
  }

  ///return type from query
  List<HotelListData> getHotelListAsStreamFireStore(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return HotelListData(
          id: doc['id'] ?? '',
          name: doc['name'] ?? '',
          description: doc['description'] ?? '',
          popularImage: doc['popular_image'] ?? '',
          image: doc['image'] ?? '',
          docId: doc.id,
          date: doc['date'] ?? '',
          popularDescription: doc['popular_description'] ?? '');
    }).toList();
  }

  void bookHotelRoom({required HotelListData data}) {
    _collectionReference
        .doc('booked')
        .collection('booked_data')
        .add(data.toJson());
  }

  ///return stream type
  Stream<List<HotelListData>> getHotelRoomBookAsStream() {
    return _collectionReference
        .doc('booked')
        .collection('booked_data')
        .snapshots()
        .map(getHotelBookAsStreamFireStore);
  }

  ///return type from query
  List<HotelListData> getHotelBookAsStreamFireStore(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return HotelListData(
          id: doc['id'] ?? '',
          name: doc['name'] ?? '',
          description: doc['description'] ?? '',
          popularImage: doc['popular_image'] ?? '',
          image: doc['image'] ?? '',
          date: doc['date'] ?? '',
          docId: doc.id,
          popularDescription: doc['popular_description'] ?? '');
    }).toList();
  }

  Future<HotelListData> isHotelRoomBooked(
      {required int hotelRoomId, required List<HotelListData> data}) async {
    final listData = data.where((element) => element.id == hotelRoomId).toList();

    return listData.first;
  }

  Future<void> cancelHotelRoomBooked({required String docId}) async {
    print('docId $docId');
   return _collectionReference
        .doc('booked')
        .collection('booked_data')
        .doc(docId)
        .delete();
  }
}
