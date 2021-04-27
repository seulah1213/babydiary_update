import 'package:babydiary_seulahpark/helpers/db_helper.dart';
import 'package:babydiary_seulahpark/models/cube_model.dart';
import 'package:babydiary_seulahpark/screens/add_cube_screen.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _updateCubeList();
  }

  _updateCubeList() {
    setState(() {
      _cubeList = DBhelper.instance.getCubeList();
    });
  }

  Widget _buildCube(Cube cube) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ListTile(
            leading: Text(
              cube.title,
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
            title: Text(
              '수량: ${cube.cubecount.toString()}',
              style: TextStyle(fontSize: 15.0, color: Colors.grey.shade600),
            ),
            subtitle: Text(
              '사용기한: ${_dateFormatter.format(cube.date)}',
              style: TextStyle(fontSize: 15.0, color: Colors.grey.shade600),
            ),
            trailing: Text(
              DateTime.now().difference(cube.date).inDays < 0
                  ? 'D${DateTime.now().difference(cube.date).inDays.toString()}'
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
      body: FutureBuilder(
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
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 0.0),
                    ],
                  ),
                );
              }
              return _buildCube(snapshot.data[index - 1]);
            },
          );
        },
      ),
    );
  }
}
