import 'package:flutter/material.dart';
import '../model/bullet_row.dart';
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
  bool _accumulate;
  String _units;
  String _comment;

  // Shorthand to map user-visible types to String and int.
  RowType _type;

  NewBulletRowState() {
    _accumulate = true;
  }

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
                padding: const EdgeInsets.only(top: 10.0),
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
                padding: const EdgeInsets.only(right: 150.0),
                child: CheckboxListTile(
                  title: const Text('Accumulate?'),
                  value: _accumulate,
                  onChanged: (bool value) { setState(() { _accumulate = value; }); },
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

      BulletRow row = new BulletRow(
        _rowName,
        [],
        _accumulate,
        _type,
        _units,
        _comment,
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

