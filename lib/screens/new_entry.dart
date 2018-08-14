import 'package:flutter/material.dart';
import 'package:bullet/model/bullet_entry.dart';
import 'package:bullet/model/bullet_row.dart';
import 'package:bullet/datastore.dart';
import 'new_row.dart';

class NewBulletEntry extends StatefulWidget {
  final BulletRow row;
  NewBulletEntry([this.row]);

  @override
  State<StatefulWidget> createState() => NewBulletEntryState();
}

class NewBulletEntryState extends State<NewBulletEntry> {
  BulletDatastore _datastore = new BulletDatastore();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // The selected Row name in the dropdown.
  String _selectedRow;
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
    if (null != widget.row) { 
      _selectedRow = widget.row.name; 
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          (null == _selectedRow) ? 'New Entry' : 'New $_selectedRow Entry',
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Form(
          key: this._formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                     // Hide drop down if we have zero rows.
                    child: (_datastore.numRows() == 0) ?
                      Expanded(child: Text('')) :
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Row',
                          helperText: 'Choose the row',
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedRow,
                            // value: // TOOD: set the default to the most recently created entry?
                            onChanged: (String newValue) {
                              setState(() { _selectedRow = newValue; });
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
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      onPressed: _pushNewRowScreen,
                      child: Text('New Row'),
                    ),
                  ),
                ],
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
          _selectedRow = newRowName;
          _rowNames = _datastore.rowNames();
        });
      });
  }

  // TODO: Consider using TextInputController? 
  // https://flutterbyexample.com/forms-1-user-input
  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      _showMessage('Invalid entry, please review and correct.');
    } else {
      form.save();

      BulletRow row = _datastore.rowForRowName(_selectedRow);
      BulletEntry entry = BulletRow.newEntryForType(
        row.type, 
        _enteredValue,
        DateTime.now(),
        _enteredComment
      );

      _showMessage('Saving entry...'); 
      _datastore.addEntry(_selectedRow, entry);

      Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}