import 'package:flutter/material.dart';
import 'package:bullet/model/bullet_row.dart';
import 'package:bullet/datastore.dart';

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
  MultiEntryHandling _multiEntryHandling;
  RowType _type;
  String _defaultValue;
  String _minValue;
  String _maxValue;
  String _units;
  String _comment;

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
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Row Type', 
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Flexible(
                      child: RadioListTile<RowType>(
                        title: const Text('Text'),
                        value: RowType.Text,
                        groupValue: _type,
                        onChanged: (RowType value) { setState(() { _type = value; }); },
                      ),
                    ),
                    Flexible(
                      child: RadioListTile<RowType>(
                        title: const Text('Number'),
                        value: RowType.Number,
                        groupValue: _type,
                        onChanged: (RowType value) { setState(() { _type = value; }); },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Handling multiple values:', 
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: RadioListTile<MultiEntryHandling>(
                        title: const Text('Keep them separate'),
                        value: MultiEntryHandling.Separate,
                        groupValue: _multiEntryHandling,
                        onChanged: (MultiEntryHandling value) { setState(() { _multiEntryHandling = value; }); },
                      ),
                    ),
                    Flexible(
                      child: RadioListTile<MultiEntryHandling>(
                        title: const Text('Add them up'),
                        value: MultiEntryHandling.Sum,
                        groupValue: _multiEntryHandling,
                        onChanged: (MultiEntryHandling value) { setState(() { _multiEntryHandling = value; }); },
                      ),
                    ),
                    Flexible(
                      child: RadioListTile<MultiEntryHandling>(
                        title: const Text('Average them'),
                        value: MultiEntryHandling.Average,
                        groupValue: _multiEntryHandling,
                        onChanged: (MultiEntryHandling value) { setState(() { _multiEntryHandling = value; }); },
                      ),
                    ),
                    Flexible(
                      child: RadioListTile<MultiEntryHandling>(
                        title: const Text('Keep the most recent entry'),
                        value: MultiEntryHandling.KeepLast,
                        groupValue: _multiEntryHandling,
                        onChanged: (MultiEntryHandling value) { setState(() { _multiEntryHandling = value; }); },
                      ),
                    ),
                  ],
                ),
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
                  labelText: 'Default value',
                  helperText: 'The default value for new entries',
                ),
                validator: (value) { },
                onSaved: (String value) {
                  setState(() { _defaultValue = value; });
                },
              ),
              // TODO: Show these in a row, and hide them when _rowType is not Number.
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Min value',
                  helperText: 'The minimum value allowed for an entry',
                ),
                validator: (value) { },
                onSaved: (String value) {
                  setState(() { _minValue = value; });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Max value',
                  helperText: 'The maximum value allowed for an entry',
                ),
                validator: (value) { },
                onSaved: (String value) {
                  setState(() { _maxValue = value; });
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

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      _showMessage('Invalid Row, please review and correct.');
    } else {
      form.save();

      // TODO: make defaultValue required for int fields
      BulletRow row = BulletRow.rowFromStrings(
        _rowName,
        _multiEntryHandling,
        _type,
        _defaultValue,
        _minValue,
        _maxValue,
        _units,
        _comment
      );

      _showMessage('Saving Row...');
      _datastore.addRow(row);

      Navigator.of(context).pop(_rowName);
    }
  }

  void _showMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}

