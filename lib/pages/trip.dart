import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_first_app/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/model/request/response/trip_get_res.dart';
import 'package:my_first_app/model/request/response/trip_idx_get_res.dart';

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = '';
  late Future<void> loadData;
  late TripIdxGetResponse tripIdxGetResponse;
  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: loadData,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(tripIdxGetResponse.name, style: TextStyle(fontSize: 30)),
                  Text(
                    tripIdxGetResponse.country,
                    style: TextStyle(fontSize: 15),
                  ),
                  Image.network(
                    tripIdxGetResponse.coverimage,
                    width: 400,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        width: 180,
                        height: 100,
                      ); // หรือใช้ Container() ก็ได้
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ราคา ${tripIdxGetResponse.price.toString()} บาท",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "โซน ${tripIdxGetResponse.destinationZone}",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Text(
                    tripIdxGetResponse.detail,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(res.body);
    tripIdxGetResponse = tripIdxGetResponseFromJson(res.body);
  }
}
