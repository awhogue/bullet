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

  // State entered by the user to create the new entry.
  String _enteredRow;
  String _enteredValue;
  String _enteredComment;

  NewBulletEntryState() {
    _datastore = BulletDatastore.init();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: _enteredRow,
                // value: // TOOD: set the default to the most recently created entry?
                onChanged: (String newValue) {
                  setState(() { _enteredRow = newValue; });
                },
                items: _datastore.rowNames().map((String rowName) => 
                  DropdownMenuItem<String>(
                    value: rowName,
                    child: Text(rowName),
                  ),
                ).toList(),
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Value:',
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
                  labelText: 'Comment:',
                ),
                maxLines: 3,
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

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      _showMessage('Invalid entry, please review and correct.');
    } else {
      form.save();

      BulletEntry entry = new BulletEntry(
        _enteredValue,
        DateTime.now(),
        new BulletRow(_enteredRow),
        _enteredComment
      );

      _showMessage('Saving entry...'); 
      _datastore.saveEntry(entry);

      Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}