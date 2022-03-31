import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:linkendin/models/book_room.dart';
import 'package:linkendin/services/firebase_data_service.dart';
import 'package:linkendin/view/home_page/bookedhotelListView.dart';
import 'package:provider/provider.dart';
import '../../models/hotel_model.dart';
import '../../services/auth.dart';
import '../../theme/theme.dart';
import 'hotelListView.dart';
import 'hotel_room_details.dart';

class BookedHotelHomeScreen extends StatefulWidget {
  const BookedHotelHomeScreen({Key? key}) : super(key: key);

  @override
  _BookedHotelHomeScreenState createState() => _BookedHotelHomeScreenState();
}

class _BookedHotelHomeScreenState extends State<BookedHotelHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  final ScrollController _scrollController = ScrollController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseDataService = Provider.of<FirebaseDataService>(context);

    return  Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<HotelListData>>(
          stream: firebaseDataService.getHotelRoomBookAsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              final list = snapshot.data;

              if (list != null && list.isEmpty) {
                return const Center(
                  child: Text(
                    'No Room booked yet',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                );
              }

              return ListView(
                children: <Widget>[
                  getSearchBarUI(),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Column(
                      children: <Widget>[
                        getFilterBarUI(title: 'Uteniandsturer'),
                        ListView.builder(
                          itemCount: list!.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 4.0),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            var count = list.length > 10 ? 10 : list.length;
                            var animation = Tween(begin: 0.0, end: 1.0)
                                .animate(CurvedAnimation(
                                parent: animationController,
                                curve: Interval(
                                    (1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                            animationController.forward();
                            return BookedHotelListView(
                              callback: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HotelDetailsPage(
                                              data: list.elementAt(index),
                                            )));
                              },
                              hotelData: list.elementAt(index),
                              animation: animation,
                              animationController: animationController,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }


  Widget getSearchBarUI() {

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          IconButton(onPressed: ()=> Navigator.pop(context), icon: const Icon(Icons.arrow_back,color: Colors.black,size: 30.0,)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {},
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: buildLightTheme().primaryColor,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search...",
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.search,
                      size: 20, color: buildLightTheme().backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI({required String title}) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: buildLightTheme().backgroundColor,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

}

