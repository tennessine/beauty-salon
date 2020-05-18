import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutterapp/models/customer.dart';
import 'package:flutterapp/utils/database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Entry extends StatefulWidget {
  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _markController = TextEditingController();

  final db = DatabaseHelper();

  String _gender = '女';

  String get gender => _gender;

  DateTime _birthday = DateTime.now();

  String get birthday {
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(_birthday);
  }

  String _errorTextName;
  String _errorTextAge;
  String _errorTextPhone;
  String _errorTextOccupation;
  String _errorTextAddress;
  String _errorTextMark;

  _showGenderPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('选择性别'),
          content: Container(
            width: 200.0,
            height: 100.0,
            child: ListView(
              children: <Widget>[
                ListTile(title: Text('男'), onTap: () {
                  setState(() {
                    _gender = '男';
                  });
                  Navigator.pop(context);
                },),
                ListTile(title: Text('女'), onTap: () {
                  setState(() {
                    _gender = '女';
                  });
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        );
      }
    );
  }

  _showDatePicker() async {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1920, 1, 1),
      maxTime: DateTime(2030, 1, 1),
      onChanged: (date) {
        print('change $date');
      },
      onConfirm: (date) {
        setState(() {
          _birthday = date;
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.zh,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('添加档案'),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                if (_nameController.text.length == 0) {
                  Fluttertoast.showToast(
                      msg: '姓名不能为空',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  return;
                }

                int age = int.tryParse(_ageController.text);
                if (age == null || age < 0 || age > 120) {
                  Fluttertoast.showToast(
                      msg: '年龄不正确',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  return;
                }

                if (_phoneController.text.length != 11) {
                  Fluttertoast.showToast(
                      msg: '电话不正确',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  return;
                }

                if (_occupationController.text.length == 0) {
                  Fluttertoast.showToast(
                      msg: '职业不能为空',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  return;
                }

                if (_addressController.text.length == 0) {
                  Fluttertoast.showToast(
                      msg: '地址不能为空',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  return;
                }

                if (_markController.text.length == 0) {
                  Fluttertoast.showToast(
                      msg: '备注不能为空',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  return;
                }

                _addCustomer(
                  _nameController.text,
                  _ageController.text,
                  _gender,
                  birthday,
                  _phoneController.text,
                  _occupationController.text,
                  _addressController.text,
                  _markController.text,
                );
                Navigator.pop(context);
              })
        ],
      ),
      body: Form(
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              onChanged: (String value) {
                if (value.length > 0) {
                  setState(() {
                    _errorTextName = null;
                  });
                } else {
                  setState(() {
                    _errorTextName = '姓名必须填写';
                  });
                }
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: '姓名',
                  errorText: _errorTextName,
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black38,
                    width: 1.0,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('性别 ($_gender)',
                      style: TextStyle(fontSize: 16.0, color: Colors.black54)),
                  IconButton(
                      icon: Icon(Icons.supervised_user_circle), onPressed: _showGenderPicker),
                ],
              ),
            ),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                int age = int.tryParse(value);
                if (age == null || age < 0 || age > 120) {
                  setState(() {
                    _errorTextAge = '年龄填写有误';
                  });
                } else {
                  setState(() {
                    _errorTextAge = null;
                  });
                }
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: '年龄',
                  errorText: _errorTextAge,
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black38,
                    width: 1.0,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('生日 ($birthday)',
                      style: TextStyle(fontSize: 16.0, color: Colors.black54)),
                  IconButton(
                      icon: Icon(Icons.date_range), onPressed: _showDatePicker),
                ],
              ),
            ),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onChanged: (String value) {
                if (value.length == 11) {
                  setState(() {
                    _errorTextPhone = null;
                  });
                } else {
                  setState(() {
                    _errorTextPhone = '电话格式有误';
                  });
                }
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: '电话',
                  errorText: _errorTextPhone,
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            TextFormField(
              controller: _occupationController,
              keyboardType: TextInputType.text,
              onChanged: (String value) {
                if (value.length > 0) {
                  setState(() {
                    _errorTextOccupation = null;
                  });
                } else {
                  setState(() {
                    _errorTextOccupation = '职业必须填写';
                  });
                }
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: '职业',
                  errorText: _errorTextOccupation,
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            TextFormField(
              controller: _addressController,
              keyboardType: TextInputType.multiline,
              onChanged: (String value) {
                if (value.length > 0) {
                  setState(() {
                    _errorTextAddress = null;
                  });
                } else {
                  setState(() {
                    _errorTextAddress = '职业必须填写';
                  });
                }
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: '地址',
                  errorText: _errorTextAddress,
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            TextFormField(
              controller: _markController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (String value) {
                if (value.length > 0) {
                  setState(() {
                    _errorTextMark = null;
                  });
                } else {
                  setState(() {
                    _errorTextMark = '备注必须填写';
                  });
                }
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: '备注',
                  errorText: _errorTextMark,
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
          ],
        ),
      ),
    );
  }

  void _addCustomer(String name, String age, gender, birthday, String phone,
      occupation, address, mark) async {
    Customer customer = Customer(
      name: name,
      age: int.parse(age),
      gender: gender,
      birthday: birthday,
      phone: phone,
      occupation: occupation,
      address: address,
      mark: mark,
    );
    await db.saveCustomer(customer);
  }
}
