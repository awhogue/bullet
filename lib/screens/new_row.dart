import 'package:flutter/material.dart';
import '../model/model.dart';
import '../datastore.dart';

class NewBulletRow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewBulletRowState();
}

class NewBulletRowState extends State<NewBulletRow> {
  BulletDatastore _datastore = new BulletDatastore();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // The following fields correspond to the BulletRow model fields.
  String _rowName;
  BulletRowDataType _rowDataType;
  BulletRowMultiEntryType _rowMultiEntryType;
  String _units;
  String _comment;

  NewBulletRowState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Journal Row'),
      ),
      body: Container(
        child: Form(
          key: this._formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Row Name',
                  helperText: 'E.g. "Coffee" or "Work out"',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    // TODO: validate against the expected type (int, string, enumeration) of the value.
                    return 'Please enter a row name.';
                  }
                },
                // keyboardType: TextInputType.number,  // TODO: switch this based on expected type of value.
                onSaved: (String value) {
                  setState(() { _rowName = value; });
                },
              ),
              Row(
                children: _makeDataTypeRadioButtons(),
              ),
              Row(
                children: _makeMultiEntryRadioButtons(),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Units',
                  helperText: 'E.g. "mg" or "hours"',
                ),
                validator: (value) { },
                onSaved: (String value) {
                  setState(() { _units = value; });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Comment',
                ),
                onSaved: (String value) {
                  setState(() { _comment = value; });
                },
              ),
              RaisedButton(
                onPressed: _submitForm,
                child: Text('Create Row'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<RadioListTile> _makeDataTypeRadioButtons() {
    List<RadioListTile> radios = new List();
    for (BulletRowDataType dataType in BulletRowDataType.values) {
      radios.add(
        RadioListTile<BulletRowDataType>(
          value: dataType,
          groupValue: _rowDataType,
          title: Text(BulletRow.dataTypeString(dataType)),
          onChanged: (value) {
            setState(() {
              _rowDataType = value;
            });
          },
        )
      );
    }
    return radios;
  }

  List<RadioListTile> _makeMultiEntryRadioButtons() {
    List<RadioListTile> radios = new List();
    for (BulletRowMultiEntryType dataType in BulletRowMultiEntryType.values) {
      // Skip entry types that are incompatible with each other.
      // Can't "accumulate" entries that are boolean checkmarks or ranged numbers.
      if ((_rowDataType == BulletRowDataType.Checkmark || 
           _rowDataType == BulletRowDataType.NumberRange) &&
          dataType == BulletRowMultiEntryType.Accumulate) {
        continue;
      }

      radios.add(
        RadioListTile<BulletRowMultiEntryType>(
          value: dataType,
          groupValue: _rowMultiEntryType,
          title: Text(BulletRow.multiEntryTypeString(dataType)),
          onChanged: (value) {
            setState(() {
              _rowMultiEntryType = value;
            });
          },
        )
      );
    }
    return radios;
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      _showMessage('Invalid Row, please review and correct.');
    } else {
      form.save();

      BulletRow row = new BulletRow(
        _rowName,
        _rowDataType,
        _rowMultiEntryType,
        _units,
        _comment,
      );

      _showMessage('Saving Row...'); 
      _datastore.addRow(row);

      Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}