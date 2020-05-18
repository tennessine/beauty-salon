import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/customer.dart';
import 'package:flutterapp/ui/edit.dart';
import 'package:flutterapp/ui/entry.dart';
import 'package:flutterapp/utils/database_helper.dart';

class Customers extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  var db = DatabaseHelper();

  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();

    _readDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('健康档案'),
        centerTitle: false,
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.backup), onPressed: () {
            _backupData();
          }),
          IconButton(icon: Icon(Icons.refresh), onPressed: () {
            _readDatabase();
          }),
          IconButton(icon: Icon(Icons.search), onPressed: () {
            showSearch(context: context, delegate: new DataSearch(context));
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: ListTile(
          title: Icon(Icons.add, color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Entry())).then((value) {
            _readDatabase();
          });
        },
      ),
      body: Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: _customers.length,
                    itemBuilder: (_, int index) {
                      return InkWell(
                        onTap: () {
                          _editCustomer(_customers[index]);
                        },
                        child: Card(
                          shadowColor: Colors.purple,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('姓名', style: TextStyle(color: Colors.grey)),
                                    Container(
                                      margin: EdgeInsets.only(left: 20.0),
                                      child: Text(_customers[index].name),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20.0),
                                      child: Image.asset(_customers[index].gender == '男' ? 'images/male.png' : 'images/female.png', width: 15, height: 15),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20.0),
                                      child: Text('${_customers[index].age}岁'),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('电话', style: TextStyle(color: Colors.grey)),
                                      Container(
                                        margin: EdgeInsets.only(left: 20.0),
                                        child: Text(_customers[index].phone),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('生日', style: TextStyle(color: Colors.grey)),
                                      Container(
                                        margin: EdgeInsets.only(left: 20.0),
                                        child: Text(_customers[index].birthday),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('职业', style: TextStyle(color: Colors.grey)),
                                      Container(
                                        margin: EdgeInsets.only(left: 20.0),
                                        child: Text(_customers[index].occupation),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('地址', style: TextStyle(color: Colors.grey)),
                                      Expanded(child: Container(
                                        margin: EdgeInsets.only(left: 20.0),
                                        child: Text(_customers[index].address),
                                      ))
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('备注', style: TextStyle(color: Colors.grey)),
                                      Expanded(child: Container(
                                        margin: EdgeInsets.only(left: 20.0),
                                        child: Text(_customers[index].mark),
                                      ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _readDatabase() async {
    var customers = await db.getCustomerRecords();
    setState(() {
      _customers = customers;
    });
  }

  void _editCustomer(Customer customer) {
    var route = MaterialPageRoute(
      builder: (BuildContext context) => Edit(customer: customer),
    );
    Navigator.of(context).push(route).then((value) {
      _readDatabase();
    });
  }

  void _backupData() async {
    var path = await db.dbPath();
    var dio = new Dio();
    FormData formData = FormData.fromMap({
      'beauty_salon': await MultipartFile.fromFile(path, filename: 'beauty_salon.db')
    });
    var response = await dio.post("https://liulangmao.org", data: formData);
    print(response.data);
  }
}

class DataSearch extends SearchDelegate {

  var db = DatabaseHelper();

  BuildContext context;

  DataSearch(this.context);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(icon: Icon(Icons.clear), onPressed: () {
        query = '';
      })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: db.getCustomerRecord(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('姓名', style: TextStyle(color: Colors.grey)),
                      Container(
                        margin: EdgeInsets.only(left: 20.0),
                        child: Text(snapshot.data.name),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20.0),
                        child: Image.asset(snapshot.data.gender == '男' ? 'images/male.png' : 'images/female.png', width: 15, height: 15),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20.0),
                        child: Text('${snapshot.data.age}岁'),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Text('电话', style: TextStyle(color: Colors.grey)),
                        Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: Text(snapshot.data.phone),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Text('生日', style: TextStyle(color: Colors.grey)),
                        Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: Text(snapshot.data.birthday),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Text('职业', style: TextStyle(color: Colors.grey)),
                        Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: Text(snapshot.data.occupation),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Text('地址', style: TextStyle(color: Colors.grey)),
                        Expanded(child: Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: Text(snapshot.data.address),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Text('备注', style: TextStyle(color: Colors.grey)),
                        Expanded(child: Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: Text(snapshot.data.mark),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: RaisedButton(onPressed: () {
                      var route = MaterialPageRoute(
                        builder: (BuildContext context) => Edit(customer: snapshot.data),
                      );
                      Navigator.of(context).push(route);
                    }, child: Text('编辑')),
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length > 0) {
      return FutureBuilder(
        future: db.findCustomers(query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    query = snapshot.data[index].phone;
                    showResults(context);
                  },
                  title: Text(snapshot.data[index].name),
                  subtitle: RichText(
                    text: TextSpan(
                        text: snapshot.data[index].phone.substring(0, query.length),
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text: snapshot.data[index].phone.substring(query.length),
                              style: TextStyle(color: Colors.grey)
                          ),
                        ]
                    ),
                  ),
                  trailing: Text(snapshot.data[index].gender),
                );
              },
            );
          }
          return SizedBox();
        },
      );
    }
    return SizedBox();
  }
}