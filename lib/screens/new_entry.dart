import 'package:flutter/material.dart';
import '../model/model.dart';
import '../datastore.dart';
  import 'new_row.dart';

class NewBulletEntry extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewBulletEntryState();
}

class NewBulletEntryState extends State<NewBulletEntry> {
  BulletDatastore _datastore = new BulletDatastore();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // The selected Row name in the dropdown.
  String _dropdownSelectedRow;
  // The text entered in the "Value" field.
  String _enteredValue;
  // The text entered in the "Comment" field.
  String _enteredComment;

  List<String> _rowNames;

  NewBulletEntryState() {
    _rowNames = _datastore.rowNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Journal Entry'),
      ),
      body: Container(
        child: Form(
          key: this._formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            children: <Widget>[
              // Hide drop down if we have zero rows.
              (_datastore.numRows() == 0) ?
                Container() :
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
                        setState(() { _dropdownSelectedRow = newValue; });
                      },
                      items: _rowNames.map((String rowName) => 
                        DropdownMenuItem<String>(
                          value: rowName,
                          child: Text(rowName),
                        ),
                      ).toList(),
                    ),
                  ),
                ),
              RaisedButton(
                onPressed: _pushNewRowScreen,
                child: Text('Add a New Row Type'),
              ),
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
      ),
    );
  }

  void _pushNewRowScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewBulletRow()))
      .then((newRowName) {
        setState(() {
          _dropdownSelectedRow = newRowName;
          _rowNames = _datastore.rowNames();
        });
      });
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      _showMessage('Invalid entry, please review and correct.');
    } else {
      form.save();

      BulletEntry entry = new BulletEntry(
        _enteredValue,
        DateTime.now(),
        _dropdownSelectedRow,
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