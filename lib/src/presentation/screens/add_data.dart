import 'package:boong_task/src/helpers/add_data.dart';
import 'package:boong_task/src/presentation/screens/add_kids.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddDataScreen extends StatefulWidget {
  static const routename = "/add";

  @override
  _AddDataScreenState createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  //--permission-details-----------------------------------------------
  TextEditingController _name = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _father = TextEditingController();
  TextEditingController _mob = TextEditingController();
  TextEditingController _aadhar = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _caste = TextEditingController();
  TextEditingController _subcaste = TextEditingController();
  //-------------------------------------------------------------------

  //--migration-details------------------------------------------------
  TextEditingController _originVillage = TextEditingController();
  TextEditingController _originDistrict = TextEditingController();
  TextEditingController _destinationVillage = TextEditingController();
  TextEditingController _destinationDistrict = TextEditingController();
  TextEditingController _route = TextEditingController();
  //--------------------------------------------------------------------

  //--family-details----------------------------------------------------
  TextEditingController _wifeName = TextEditingController(text: 'N/A');
  TextEditingController _wifeAge = TextEditingController(text: 'N/A');
  TextEditingController _numberOfSons = TextEditingController();
  TextEditingController _numberOfDaughters = TextEditingController();
  // TextEditingController _sonName = TextEditingController(text: 'N/A');
  // TextEditingController _sonAge = TextEditingController(text: 'N/A');
  // TextEditingController _daughterName = TextEditingController(text: 'N/A');
  // TextEditingController _daughterAge = TextEditingController(text: 'N/A');
  //--------------------------------------------------------------------

  //--livestock---------------------------------------------------------
  TextEditingController _goat = TextEditingController(text: 'N/A');
  TextEditingController _sheep = TextEditingController(text: 'N/A');
  TextEditingController _cow = TextEditingController(text: 'N/A');
  TextEditingController _bull = TextEditingController(text: 'N/A');
  TextEditingController _buffalo = TextEditingController(text: 'N/A');
  //--------------------------------------------------------------------

  double livestockCount = 10;
  String incomeValue = "Not provided";
  DateTime originDate;
  DateTime destDate;
  DateTime report;

  String sonData;
  String daughterData;

  var format = DateFormat.yMd();

  int currentStep = 0;
  bool complete = false;

  next() {
    FocusScope.of(context).unfocus();
    currentStep + 1 != 4 ? goTo(currentStep + 1) : setState(() => complete = true);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  addData() async {
    String csvString =
        "${_name.text},${_age.text},${_father.text},${_mob.text},${_aadhar.text},${_address.text},${_caste.text},${_subcaste.text},$incomeValue,${format.format(originDate)},${_originVillage.text},${_originDistrict.text},${format.format(destDate)},${_destinationVillage.text},${_destinationDistrict.text},${format.format(report)},${_wifeName.text},${_wifeAge.text},";
    if (int.parse(_numberOfSons.text) == 0) {
      csvString += "${_numberOfSons.text},N/A,N/A,";
    } else {
      csvString += "${_numberOfSons.text},$sonData,";
    }
    if (int.parse(_numberOfDaughters.text) == 0) {
      csvString += "${_numberOfDaughters.text},N/A,N/A,";
    } else {
      csvString += "${_numberOfDaughters.text},$daughterData,";
    }
    csvString += "${_goat.text},${_sheep.text},${_cow.text},${_bull.text},${_buffalo.text}";
    print(csvString);
    bool done = await addDataToCSV(csvString);
    SnackBar snackBar;
    if (!done) {
      snackBar = SnackBar(
        content: Text('Unable to write to file'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      );
    } else {
      snackBar = SnackBar(
        content: Text('Data written to file'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      );
    }
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      bottomNavigationBar: Container(
        height: 50,
        margin: EdgeInsets.all(16),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          onPressed: () async {
            if (!_formKey.currentState.validate()) {
              SnackBar snackBar = SnackBar(
                content: Text('Please correct the errors in the form'),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              );
              _scaffoldkey.currentState.showSnackBar(snackBar);
              return;
            } else if (int.parse(_numberOfSons.text) != 0 && sonData.isEmpty) {
              SnackBar snackBar = SnackBar(
                content: Text('Son(s) data not provided'),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              );
              _scaffoldkey.currentState.showSnackBar(snackBar);
            } else if (int.parse(_numberOfDaughters.text) != 0 && daughterData.isEmpty) {
              SnackBar snackBar = SnackBar(
                content: Text('Daughter(s) data not provided'),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              );
              _scaffoldkey.currentState.showSnackBar(snackBar);
            }
            addData();
          },
          child: Text('SUBMIT'),
        ),
      ),
      appBar: AppBar(
        title: Text('Add Data'),
      ),
      body: Container(
        // margin: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Stepper(
                  steps: [
                    Step(
                      title: Text('Personal Details'),
                      isActive: currentStep == 0 ?? false,
                      state: StepState.indexed,
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _name,
                            keyboardType: TextInputType.name,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            autofillHints: [AutofillHints.name],
                            decoration: InputDecoration(
                              labelText: 'Name',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _age,
                            keyboardType: TextInputType.number,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            decoration: InputDecoration(
                              labelText: 'Age',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                              if (int.parse(value) <= 0) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _father,
                            autofillHints: [AutofillHints.familyName],
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Father\'s Name',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _mob,
                            keyboardType: TextInputType.phone,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            maxLength: 12,
                            controller: _aadhar,
                            decoration: InputDecoration(
                              labelText: 'Aadhar Card Number',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (!value.contains(RegExp(r'^[2-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$'))) {
                                return "Improper Aadhar Card Number";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          TextFormField(
                            maxLines: 3,
                            controller: _address,
                            autofillHints: [AutofillHints.fullStreetAddress],
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                              labelText: 'Address',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input, commas not allowed";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _caste,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Caste',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _subcaste,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Subcaste',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          DropdownButtonFormField<String>(
                            hint: Text('Annual Income'),
                            onChanged: (value) {
                              setState(() {
                                incomeValue = value;
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                child: Text('Less than 10,000'),
                                value: 'Less than 10000',
                              ),
                              DropdownMenuItem(
                                child: Text('10,000 to 50,000'),
                                value: '10000 to 50000',
                              ),
                              DropdownMenuItem(
                                child: Text('Greater than 50,000'),
                                value: 'Greater than 50000',
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    Step(
                      state: StepState.indexed,
                      isActive: currentStep == 1 ?? false,
                      title: const Text('Migration Details'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'ORIGIN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text('Date'),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              RaisedButton(
                                onPressed: () async {
                                  final DateTime picked = await showDatePicker(
                                    context: context,
                                    initialDate: originDate ?? DateTime.now(), // Refer step 1
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2050),
                                  );
                                  if (picked != null && picked != originDate)
                                    setState(() {
                                      originDate = picked;
                                    });
                                },
                                textColor: Colors.white,
                                child: Text('SELECT DATE'),
                              ),
                              Spacer(),
                              Text(originDate != null ? format.format(originDate) : '')
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _originVillage,
                            decoration: InputDecoration(
                              labelText: 'Village',
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _originDistrict,
                            decoration: InputDecoration(
                              labelText: 'District',
                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Text(
                            'DESTINATION',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text('Date'),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              RaisedButton(
                                onPressed: () async {
                                  final DateTime picked = await showDatePicker(
                                    context: context,
                                    initialDate: destDate ?? DateTime.now(), // Refer step 1
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2050),
                                  );
                                  if (picked != null && picked != originDate)
                                    setState(() {
                                      destDate = picked;
                                    });
                                },
                                textColor: Colors.white,
                                child: Text('SELECT DATE'),
                              ),
                              Spacer(),
                              Text(destDate != null ? format.format(destDate) : '')
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _destinationVillage,
                            decoration: InputDecoration(
                              labelText: 'Village',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _destinationDistrict,
                            decoration: InputDecoration(
                              labelText: 'District',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Text(
                            'DATE OF REPORT',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              RaisedButton(
                                onPressed: () async {
                                  final DateTime picked = await showDatePicker(
                                    context: context,
                                    initialDate: report ?? DateTime.now(), // Refer step 1
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2050),
                                  );
                                  if (picked != null && picked != report)
                                    setState(() {
                                      report = picked;
                                    });
                                },
                                textColor: Colors.white,
                                child: Text('SELECT DATE'),
                              ),
                              Spacer(),
                              Text(report != null ? format.format(report) : '')
                            ],
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          TextFormField(
                            controller: _route,
                            decoration: InputDecoration(
                              labelText: 'Route',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    Step(
                      isActive: currentStep == 2 ?? false,
                      state: StepState.indexed,
                      title: const Text('Family Details'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'WIFE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _wifeName,
                            keyboardType: TextInputType.name,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            autofillHints: [AutofillHints.name],
                            decoration: InputDecoration(
                              labelText: 'Name',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _wifeAge,
                            keyboardType: TextInputType.number,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            decoration: InputDecoration(
                              labelText: 'Age',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Text(
                            'SONS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _numberOfSons,
                            keyboardType: TextInputType.number,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              labelText: 'Number of Sons',
                              contentPadding: EdgeInsets.all(8),
                              suffix: FlatButton(
                                visualDensity: VisualDensity.compact,
                                child: Text('NEXT'),
                                onPressed: () async {
                                  if (int.parse(_numberOfSons.text) < 0 ||
                                      int.parse(_numberOfSons.text) > 20) {
                                    _scaffoldkey.currentState.showSnackBar(SnackBar(
                                      content: Text('Please Enter Sensible Value'),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                    ));
                                  } else {
                                    sonData =
                                        await Navigator.of(context).push<String>(MaterialPageRoute(
                                      builder: (context) => AddChildren(
                                        number: int.parse(_numberOfSons.text),
                                      ),
                                    ));
                                    if (sonData == null) {
                                      _scaffoldkey.currentState.showSnackBar(SnackBar(
                                        content: Text('Please provide children data'),
                                        // backgroundColor: Colors.redAccent,
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                    } else {
                                      _scaffoldkey.currentState.showSnackBar(SnackBar(
                                        content: Text('Data saved temporarily'),
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                      print(sonData);
                                    }
                                  }
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'DAUGHTERS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _numberOfDaughters,
                            keyboardType: TextInputType.number,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              labelText: 'Number of Daughters',
                              contentPadding: EdgeInsets.all(8),
                              suffix: FlatButton(
                                visualDensity: VisualDensity.compact,
                                child: Text('NEXT'),
                                onPressed: () async {
                                  if (int.parse(_numberOfDaughters.text) < 0 ||
                                      int.parse(_numberOfDaughters.text) > 20) {
                                    _scaffoldkey.currentState.showSnackBar(SnackBar(
                                      content: Text('Please Enter Sensible Value'),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                    ));
                                  } else {
                                    daughterData =
                                        await Navigator.of(context).push<String>(MaterialPageRoute(
                                      builder: (context) => AddChildren(
                                        number: int.parse(_numberOfDaughters.text),
                                      ),
                                    ));
                                    if (daughterData == null) {
                                      _scaffoldkey.currentState.showSnackBar(SnackBar(
                                        content: Text('Please provide children data'),
                                        // backgroundColor: Colors.redAccent,
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                    } else {
                                      _scaffoldkey.currentState.showSnackBar(SnackBar(
                                        content: Text('Data saved temporarily'),
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                      print(daughterData);
                                    }
                                  }
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    Step(
                      isActive: currentStep == 3 ?? false,
                      state: StepState.indexed,
                      title: const Text('Livestock Details'),
                      content: Column(
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _goat,
                            keyboardType: TextInputType.number,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            decoration: InputDecoration(
                              labelText: 'Number of Goats',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _sheep,
                            keyboardType: TextInputType.number,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            decoration: InputDecoration(
                              labelText: 'Number of Sheep',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _cow,
                            keyboardType: TextInputType.number,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            decoration: InputDecoration(
                              labelText: 'Number of Cow',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _bull,
                            keyboardType: TextInputType.number,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            decoration: InputDecoration(
                              labelText: 'Number of Bull',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _buffalo,
                            keyboardType: TextInputType.number,
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            decoration: InputDecoration(
                              labelText: 'Number of Buffalo',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field is required";
                              }
                              if (value.contains(",")) {
                                return "invalid input";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                  controlsBuilder: (context, {onStepCancel, onStepContinue}) {
                    return Row(
                      children: <Widget>[
                        RaisedButton(
                          textColor: Colors.white,
                          elevation: 0,
                          onPressed: currentStep <= 3 ? onStepContinue : null,
                          child: const Text('NEXT'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        FlatButton(
                          onPressed: currentStep < 0 ? null : onStepCancel,
                          child: const Text('BACK'),
                        ),
                      ],
                    );
                  },
                  currentStep: currentStep,
                  onStepContinue: next,
                  onStepTapped: (step) => goTo(step),
                  onStepCancel: cancel,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
