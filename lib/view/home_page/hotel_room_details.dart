import 'package:flutter/material.dart';
import 'package:linkendin/models/hotel_model.dart';
import 'package:provider/provider.dart';

import '../../services/firebase_data_service.dart';

class HotelDetailsPage extends StatelessWidget {

  final HotelListData data;

   HotelDetailsPage({required this.data});

  @override
  Widget build(BuildContext context) {

    final firebaseDataService = Provider.of<FirebaseDataService>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              foregroundDecoration: const BoxDecoration(color: Colors.black26),
              height: 400.0,
              child: Image.network(data.image!, fit: BoxFit.cover)),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0,bottom: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 const SizedBox(height: 250),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 16.0),
                  child: Text(
                    data.name!,
                    style: const TextStyle(color: Colors.white, fontSize: 28.0, fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(32.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(18.0),topLeft: Radius.circular(18.0))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Column(
                            children: const <Widget>[
                              Text("\$ 200", style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                              ),),
                              Text("/per night",style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey
                              ),)
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      Text("Description".toUpperCase(), style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0
                      ),),
                      const SizedBox(height: 10.0),
                       Text(
                       data.description!, textAlign: TextAlign.justify, style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 15.0,
                          letterSpacing: 0.1,
                          height: 1.5
                      ),),
                      const SizedBox(height: 10.0),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                        child: AspectRatio(
                          aspectRatio: 2.0,
                          child: Image.network(
                            data.popularImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                       data.popularDescription!, textAlign: TextAlign.justify, style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14.0,
                          letterSpacing: 0.1,
                          height: 1.5
                      ),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<List<HotelListData>>(
            stream: firebaseDataService.getHotelRoomBookAsStream(),
            builder: (context,stmSnap){
              if(stmSnap.hasData){
                return FutureBuilder<HotelListData>(
                  future: firebaseDataService.isHotelRoomBooked(hotelRoomId: data.id!,data: stmSnap.data!),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      bool isBooked = snapshot.data!.docId != null;
                      return Positioned(
                        bottom: 8.0,
                        left: 30.0,
                        right: 30.0,
                        child: SizedBox(
                          width: double.infinity,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                            color: isBooked ? Colors.red : Colors.blue,
                            textColor: Colors.white,
                            child: Text(isBooked ? 'cancel': "Book Now", style: const TextStyle(
                                fontWeight: FontWeight.normal
                            ),),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 32.0,
                            ),
                            onPressed: () async {
                              if(isBooked) {
                                await firebaseDataService.cancelHotelRoomBooked(docId: snapshot.data!.docId!);
                              } else {
                                firebaseDataService.bookHotelRoom(data: data);
                              }
                            },
                          ),
                        ),
                      );
                    }
                    return Positioned(
                      bottom: 8.0,
                      left: 30.0,
                      right: 30.0,
                      child: SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: const Text("Book Now", style: TextStyle(
                              fontWeight: FontWeight.normal
                          ),),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          onPressed: () async {
                            firebaseDataService.bookHotelRoom(data: data);
                          },
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Positioned(
            top: 32.0,
            left:  8.0,
            child: IconButton(onPressed: ()=> Navigator.pop(context), icon: const Icon(Icons.arrow_back,color: Colors.white,size: 30.0,)),
          ),
        ],
      ),
    );
  }
}