import 'package:flutter/material.dart';
import '../model/model.dart';
import '../datastore.dart';

class NewBulletEntry extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewBulletEntryState();
}

class NewBulletEntryState extends State<NewBulletEntry> {
  BulletDatastore _datastore;
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // The selected Row name in the dropdown.
  String _dropdownSelectedRow;
  // Are we showing the "New Row" field?
  bool _newRowVisible = false;
  // The text entered in the "New Row" field, if visible.
  String _enteredNewRow;
  // The text entered in the "Value" field.
  String _enteredValue;
  // The text entered in the "Comment" field.
  String _enteredComment;

  // The text for the drop down for "New Row"
  final String _newRowNameText = 'Add a new row';

  NewBulletEntryState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Journal Entry'),
      ),
      body: FutureBuilder<BulletDatastore>(
        future: BulletDatastore.init(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            _datastore = snapshot.data;
            return Container(
              child: Form(
                key: this._formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  children: <Widget>[
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Entry Type',
                        helperText: 'Choose an entry type',
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _dropdownSelectedRow,
                          // value: // TOOD: set the default to the most recently created entry?
                          onChanged: (String newValue) {
                            setState(() { 
                              _dropdownSelectedRow = newValue;
                              _toggleNewRowField(newValue);
                            });
                          },
                          items: _getRowNamesForDropdown().map((String rowName) => 
                            DropdownMenuItem<String>(
                              value: rowName,
                              child: Text(rowName),
                            ),
                          ).toList(),
                        ),
                      ),
                    ),
                    _newRowVisible ? TextFormField(
                      decoration: InputDecoration(
                        labelText: 'New Entry Type',
                      ),
                      validator: (value) {}, // TODO: validate that this isn't a duplicate row name?
                      onSaved: (String value) {
                        setState(() { 
                          _enteredNewRow = value;
                        });
                      },
                    ) : new Container(),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Value',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          // TODO: validate against the expected type (int, string, enumeration) of the value.
                          return 'Please enter a value.';
                        }
                      },
                      // keyboardType: TextInputType.number,  // TODO: switch this based on expected type of value.
                      onSaved: (String value) {
                        setState(() { _enteredValue = value; });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Comment',
                      ),
                      onSaved: (String value) {
                        setState(() { _enteredComment = value; });
                      },
                    ),
                    RaisedButton(
                      onPressed: _submitForm,
                      child: Text('Create Entry'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Toggle the field to enter a new Row based on the dropdown selection.
  void _toggleNewRowField(String dropdownValue) {
    _newRowVisible = (dropdownValue == _newRowNameText);
  }

  List<String> _getRowNamesForDropdown() {
    List<String> rowNames = _datastore.rowNames();
    rowNames.add(_newRowNameText);
    return rowNames;
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      _showMessage('Invalid entry, please review and correct.');
    } else {
      form.save();

      String rowName = _newRowVisible ? _enteredNewRow : _dropdownSelectedRow;

      BulletEntry entry = new BulletEntry(
        _enteredValue,
        DateTime.now(),
        rowName,
        _enteredComment
      );

      _showMessage('Saving entry...'); 
      _datastore.addEntry(entry);

      Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}