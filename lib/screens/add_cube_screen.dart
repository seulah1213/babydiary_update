import 'package:babydiary_seulahpark/helpers/db_helper.dart';
import 'package:babydiary_seulahpark/models/cube_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddCubeScreen extends StatefulWidget {
  final Cube cube;
  final Function updateCubeList;

  AddCubeScreen({this.cube, this.updateCubeList});
  @override
  _AddCubeScreenState createState() => _AddCubeScreenState();
}

class _AddCubeScreenState extends State<AddCubeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  int _number = 0;

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();

    if (widget.cube != null) {
      _title = widget.cube.title;
      _startDate = widget.cube.startDate;
      _endDate = widget.cube.endDate;
      _number = widget.cube.cubecount;
    }

    _startDateController.text = _dateFormatter.format(_startDate);
    _endDateController.text = _dateFormatter.format(_endDate);
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  _handleStartDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _startDate) {
      setState(() {
        _startDate = date;
      });
      _startDateController.text = _dateFormatter.format(date);
    }
  }

  _handleEndDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _endDate) {
      setState(() {
        _endDate = date;
      });
      _endDateController.text = _dateFormatter.format(date);
    }
  }

  _delete() {
    DBhelper.instance.deleteCube(widget.cube.id);
    widget.updateCubeList();
    Navigator.pop(context);
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_title, $_number, $_startDate, $_endDate');

      Cube cube = Cube(
          title: _title,
          cubecount: _number,
          startDate: _startDate,
          endDate: _endDate);
      if (widget.cube == null) {
        DBhelper.instance.insertCube(cube);
      } else {
        cube.id = widget.cube.id;
        DBhelper.instance.updateCube(cube);
      }
      widget.updateCubeList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.cube == null ? '큐브추가' : '큐브편집'),
      ),
      body: Theme(
        data: new ThemeData(
          primaryColor: Colors.red,
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              labelText: '큐브이름',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (input) =>
                                input.trim().isEmpty ? '큐브 이름을 입력해주세요' : null,
                            onSaved: (input) => _title = input,
                            initialValue: _title,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18.0),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'))
                            ],
                            decoration: InputDecoration(
                              labelText: '큐브수량',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (input) =>
                                input.trim().isEmpty ? '큐브 수량을 입력해주세요' : null,
                            onSaved: (input) => _number = int.tryParse(input),
                            initialValue: _number.toString(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: _startDateController,
                            style: TextStyle(fontSize: 18.0),
                            onTap: _handleStartDatePicker,
                            decoration: InputDecoration(
                              labelText: '만든날짜',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: _endDateController,
                            style: TextStyle(fontSize: 18.0),
                            onTap: _handleEndDatePicker,
                            decoration: InputDecoration(
                              labelText: '사용기한',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          height: 60.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextButton(
                            child: Text(
                              widget.cube == null ? 'Add' : 'Update',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            onPressed: _submit,
                          ),
                        ),
                        widget.cube != null
                            ? Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                height: 60.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: TextButton(
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  onPressed: _delete,
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
