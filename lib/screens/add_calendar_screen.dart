import 'package:babydiary_seulahpark/helpers/food_db_helper.dart';
import 'package:babydiary_seulahpark/models/color_picker.dart';
import 'package:babydiary_seulahpark/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddCalendarScreen extends StatefulWidget {
  final Food food;

  AddCalendarScreen({this.food});

  @override
  _AddCalendarScreenState createState() => _AddCalendarScreenState();
}

class _AddCalendarScreenState extends State<AddCalendarScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _background;
  int _eventCount = 0;
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  String _step;

  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  final List<String> _steps = ['초기', '중기', '후기', '미설정'];

  @override
  void initState() {
    super.initState();

    if (widget.food != null) {
      _name = widget.food.name;
      _background = widget.food.background;
      _eventCount = widget.food.eventCount;
      _fromDate = widget.food.fromDate;
      _toDate = widget.food.toDate;
      _step = widget.food.step;
    }

    _fromDateController.text = _dateFormatter.format(_fromDate);
    _toDateController.text = _dateFormatter.format(_toDate);
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  _handleFromDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _fromDate) {
      setState(() {
        _fromDate = date;
      });
      _fromDateController.text = _dateFormatter.format(date);
    }
  }

  _handleToDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _toDate) {
      setState(() {
        _toDate = date;
      });
      _toDateController.text = _dateFormatter.format(date);
    }
  }

  _addFood() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_name, $_fromDate, $_toDate, $_step, $_eventCount, $_background');

      Food food = Food(
          name: _name,
          fromDate: _fromDate,
          toDate: _toDate,
          step: _step,
          eventCount: _eventCount,
          background: _background);

      if (widget.food == null) {
        FoodDBhelper.instance.insertFood(food);
      } else {
        food.id = widget.food.id;
        FoodDBhelper.instance.updateFood(food);
      }
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/calendar', (Route<dynamic> route) => false);
    }
  }

  _deleteFood() {
    FoodDBhelper.instance.deleteFood(widget.food.id);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/calendar', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '식단추가',
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ColorPicker(
                      selectedIndex: _background,
                      onTap: (index) {
                        setState(() {
                          _background = index;
                        });
                        _background = index;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: DropdownButtonFormField(
                      icon: Icon(Icons.arrow_drop_down_circle),
                      iconSize: 20.0,
                      iconEnabledColor: Theme.of(context).primaryColor,
                      items: _steps.map((String step) {
                        return DropdownMenuItem(
                          value: step,
                          child: Text(
                            step,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                        );
                      }).toList(),
                      style: TextStyle(fontSize: 15.0),
                      decoration: InputDecoration(
                        labelText: '이유식 단계',
                        labelStyle: TextStyle(fontSize: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (input) =>
                          _step == null ? 'Please select a level' : null,
                      onChanged: (value) {
                        setState(() {
                          _step = value;
                        });
                      },
                      value: _step,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      style: TextStyle(fontSize: 15.0),
                      decoration: InputDecoration(
                        labelText: '이유식 이름',
                        labelStyle: TextStyle(fontSize: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (input) => input.trim().isEmpty
                          ? 'Please enter a cube title'
                          : null,
                      onSaved: (input) => _name = input,
                      initialValue: _name,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      style: TextStyle(fontSize: 15.0),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      decoration: InputDecoration(
                        labelText: '이유식 양',
                        labelStyle: TextStyle(fontSize: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (input) => input.trim().isEmpty
                          ? 'Please enter a cube title'
                          : null,
                      onSaved: (input) => _eventCount = int.tryParse(input),
                      initialValue: _eventCount.toString(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      readOnly: true,
                      controller: _fromDateController,
                      style: TextStyle(fontSize: 15.0),
                      onTap: _handleFromDatePicker,
                      decoration: InputDecoration(
                        labelText: '시작날짜',
                        labelStyle: TextStyle(fontSize: 15.0),
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
                      controller: _toDateController,
                      style: TextStyle(fontSize: 15.0),
                      onTap: _handleToDatePicker,
                      decoration: InputDecoration(
                        labelText: '종료날짜',
                        labelStyle: TextStyle(fontSize: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextButton(
                      child: Text(
                        widget.food == null ? 'Add' : 'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: _addFood,
                    ),
                  ),
                  widget.food != null
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 20.0),
                          height: 60.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
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
                            onPressed: _deleteFood,
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
