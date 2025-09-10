import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_first_app/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/model/request/response/trip_get_res.dart';
import 'package:my_first_app/pages/profile.dart';
import 'package:my_first_app/pages/trip.dart';

class ShowtripPage extends StatefulWidget {
  int cid = 0;
  ShowtripPage({super.key, required this.cid});

  @override
  State<ShowtripPage> createState() => _ShowtripPageState();
}

class _ShowtripPageState extends State<ShowtripPage> {
  String url = "";
  // เก็บทั้งหมด
  List<TripGetRespones> _allTrips = [];
  // เก็บรายการที่จะแสดง (หลังกรอง)
  List<TripGetRespones> tripGetResponse = [];

  late Future<void> loadData;

  // โซนที่มีให้เลือก (แก้สะกดเป็น "แอฟริกา")
  final List<String> zones = const [
    'ทั้งหมด',
    'ยุโรป',
    'เอเชีย',
    'อาเซียน',
    'แอฟริกา',
    'ประเทศไทย',
  ];
  String selectedZone = 'ทั้งหมด';

  @override
  void initState() {
    super.initState();
    loadData = getTrips();
  }

  void filterTrips(String zone) {
    if (zone == 'ทั้งหมด') {
      setState(() {
        tripGetResponse = List<TripGetRespones>.from(_allTrips);
      });
      return;
    }
    setState(() {
      tripGetResponse = _allTrips
          .where((e) => (e.destinationZone ?? '').trim() == zone)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายการทวีป"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.cid),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              PopupMenuItem<String>(value: 'logout', child: Text('ออกจากระบบ')),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 8, 0, 4),
                    child: Text('ปลายทาง', style: TextStyle(fontSize: 15)),
                  ),
                  // แถวปุ่มกรองโซน
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: zones.map((zone) {
                        final bool isSelected = selectedZone == zone;
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                          child: FilledButton(
                            style: ButtonStyle(
                              elevation: WidgetStatePropertyAll(
                                isSelected ? 2 : 0,
                              ),
                            ),
                            onPressed: () {
                              selectedZone = zone;
                              filterTrips(zone);
                            },
                            child: Text(zone),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // รายการการ์ด
                  Column(
                    children: [
                      ...tripGetResponse.map(
                        (e) => Center(
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                debugPrint('Card tapped.');
                              },
                              child: SizedBox(
                                width: 400,
                                height: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        12,
                                        5,
                                        0,
                                        0,
                                      ),
                                      child: Text(
                                        e.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Image.network(
                                            e.coverimage,
                                            width: 180,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const SizedBox(
                                                    width: 180,
                                                    height: 100,
                                                    child: Icon(
                                                      Icons.broken_image,
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            8,
                                            12,
                                            0,
                                            0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e.name,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                'ระยะเวลา ${e.duration} วัน',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                'ราคา ${e.price} บาท',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              FilledButton(
                                                onPressed: () =>
                                                    gototrip(e.idx),
                                                child: const Text(
                                                  'รายละเอียดเพิ่มเติม',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (tripGetResponse.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('ไม่พบรายการในทวีปที่เลือก'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void gototrip(int idx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(idx: idx)),
    );
  }

  Future<void> getTrips() async {
    final config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    final res = await http.get(Uri.parse('$url/trips'));
    log(res.body);

    final data = tripGetResponesFromJson(res.body);

    setState(() {
      _allTrips = data;
      // ครั้งแรกให้แสดงทั้งหมด
      selectedZone = 'ทั้งหมด';
      tripGetResponse = List<TripGetRespones>.from(_allTrips);
    });
  }
}
