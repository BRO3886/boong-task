import 'package:boong_task/src/helpers/add_data.dart';
import 'package:flutter/material.dart';

class AddDataScreen extends StatefulWidget {
  static const routename = "/add";

  @override
  _AddDataScreenState createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _aadhar = TextEditingController();
  TextEditingController _father = TextEditingController();
  TextEditingController _familyCount = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _origin = TextEditingController();
  TextEditingController _destination = TextEditingController();
  TextEditingController _route = TextEditingController();

  double livestockCount = 10;
  String incomeValue = "Not provided";

  int currentStep = 0;
  bool complete = false;

  next() {
    currentStep + 1 != 3 ? goTo(currentStep + 1) : setState(() => complete = true);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
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
            }
            final csvString =
                "${_name.text},${_aadhar.text},$incomeValue,${_father.text},${_familyCount.text},${_address.text},${_origin.text},${_destination.text},${_route.text},${livestockCount.floor()}";
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
                          SizedBox(
                            height: 16,
                          ),
                          DropdownButtonFormField<String>(
                            hint: Text('Monthly Income'),
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
                      title: const Text('Other Details'),
                      content: Column(
                        children: <Widget>[
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
                            controller: _familyCount,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Number of Family Members',
                            ),
                          ),
                          SizedBox(
                            height: 16,
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
                        ],
                      ),
                    ),
                    Step(
                      isActive: currentStep == 2 ?? false,
                      state: StepState.indexed,
                      title: const Text('Route Details'),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _origin,
                            decoration: InputDecoration(
                              labelText: 'Origin',
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
                            controller: _destination,
                            decoration: InputDecoration(
                              labelText: 'Destination',
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Livestock count under'),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Slider(
                            value: livestockCount,
                            min: 10,
                            max: 10000,
                            divisions: 5,
                            label: "${livestockCount.floor()}",
                            onChanged: (value) {
                              setState(() {
                                livestockCount = value;
                              });
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
                          onPressed: currentStep <= 2 ? onStepContinue : null,
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
