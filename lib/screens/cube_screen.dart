import 'dart:io';

import 'package:babydiary_seulahpark/helpers/db_helper.dart';
import 'package:babydiary_seulahpark/models/cube_model.dart';
import 'package:babydiary_seulahpark/screens/add_cube_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

class CubeScreen extends StatefulWidget {
  @override
  _CubeScreenState createState() => _CubeScreenState();
}

class _CubeScreenState extends State<CubeScreen> {
  Future<List<Cube>> _cubeList;
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');
  String searchString = "";
  TextEditingController searchController = TextEditingController();

  final String iOSTestId = 'ca-app-pub-3940256099942544/2934735716';
  final String androidTestId = 'ca-app-pub-3940256099942544/6300978111';

  BannerAd banner;

  @override
  void initState() {
    super.initState();
    _updateCubeList();
    print(_cubeList);

    banner = BannerAd(
      size: AdSize.banner,
      adUnitId: Platform.isIOS ? iOSTestId : androidTestId,
      listener: AdListener(),
      request: AdRequest(),
    )..load();
  }

  _updateCubeList() {
    setState(() {
      _cubeList = DBhelper.instance.getCubeList();
    });
  }

  Widget _buildCube(Cube cube) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: MediaQuery.of(context).size.width * 0.20,
              child: Text(
                cube.title,
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
            ),
            title: Text(
              '수량: ${cube.cubecount.toString()}개',
              style: TextStyle(fontSize: 15.0, color: Colors.grey.shade800),
            ),
            subtitle: Text(
              '사용기한: ${_dateFormatter.format(cube.endDate)}',
              style: TextStyle(fontSize: 15.0, color: Colors.grey.shade800),
            ),
            trailing: Text(
              DateTime.now().difference(cube.endDate).inDays - 1 < 0
                  ? 'D${DateTime.now().difference(cube.endDate).inDays - 1}'
                  : '기한지남',
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.red),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddCubeScreen(
                  cube: cube,
                  updateCubeList: _updateCubeList,
                ),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('큐브관리'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddCubeScreen(
                        updateCubeList: _updateCubeList,
                      ),
                    ));
              })
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchString = value;
                });
              },
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFFFE8189),
                ),
                hintText: '큐브 이름 검색',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(width: 1.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(width: 1.0)),
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Expanded(
            child: FutureBuilder(
              future: _cubeList,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  itemCount: 1 + snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return SizedBox(height: 0.0);
                    }
                    return snapshot.data[index - 1].title.contains(searchString)
                        ? _buildCube(snapshot.data[index - 1])
                        : Container();
                  },
                );
              },
            ),
          ),
          Container(
            height: 50.0,
            child: this.banner == null
                ? Container()
                : AdWidget(
                    ad: banner,
                  ),
          ),
        ],
      ),
    );
  }
}
