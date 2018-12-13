import 'package:flutter/material.dart';
import 'package:bullet/model/bullet_row.dart';
import 'package:bullet/datastore.dart';

class EditBulletRow extends StatefulWidget {
  final BulletRow row;
  EditBulletRow([this.row]);
  @override
  State<StatefulWidget> createState() => EditBulletRowState();
}

class EditBulletRowState extends State<EditBulletRow> {
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
    if (null == this._type) {
      if (null != widget.row) {
        this._rowName = widget.row.name;
        this._multiEntryHandling = widget.row.multiEntryHandling;
        this._type = widget.row.type;
        this._defaultValue = widget.row.defaultValue;
        this._minValue = widget.row.minValue;
        this._maxValue = widget.row.maxValue;
        this._units = widget.row.units;
        this._comment = widget.row.comment;
      } else {
        this._type = RowType.Number;
        this._multiEntryHandling = MultiEntryHandling.Sum;
      }
    }

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
                initialValue: _rowName,
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
                padding: const EdgeInsets.only(top: 12.0),
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
                        title: const Text('Number'),
                        value: RowType.Number,
                        groupValue: _type,
                        onChanged: (RowType value) { setState(() { _type = value; }); },
                      ),
                    ),
                    Flexible(
                      child: RadioListTile<RowType>(
                        title: const Text('Text'),
                        value: RowType.Text,
                        groupValue: _type,
                        onChanged: (RowType value) {
                          setState(() { 
                            _type = value; 
                            // Reset multi-entry handling radio for non-numeric values.
                            if (_multiEntryHandling == MultiEntryHandling.Average || 
                                _multiEntryHandling == MultiEntryHandling.Sum) {
                              _multiEntryHandling = MultiEntryHandling.Separate;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Handling multiple values:', 
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Visibility(
                      visible: (_type == RowType.Number),
                      child: Container(
                        child: RadioListTile<MultiEntryHandling>(
                          dense: true,
                          title: Text('Add them up', style: Theme.of(context).textTheme.subhead),
                          value: MultiEntryHandling.Sum,
                          groupValue: _multiEntryHandling,
                          onChanged: (MultiEntryHandling value) { setState(() { _multiEntryHandling = value; }); },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (_type == RowType.Number),
                      child: Container(
                        child: RadioListTile<MultiEntryHandling>(
                          dense: true,
                          title: Text('Average them', style: Theme.of(context).textTheme.subhead),
                          value: MultiEntryHandling.Average,
                          groupValue: _multiEntryHandling,
                          onChanged: (MultiEntryHandling value) { setState(() { _multiEntryHandling = value; }); },
                        ),
                      ),
                    ),
                    Container(
                      child: RadioListTile<MultiEntryHandling>(
                        dense: true,
                        title: Text('Keep them separate', style: Theme.of(context).textTheme.subhead),
                        value: MultiEntryHandling.Separate,
                        groupValue: _multiEntryHandling,
                        onChanged: (MultiEntryHandling value) { setState(() { _multiEntryHandling = value; }); },
                      ),
                    ),
                    Container(
                      child: RadioListTile<MultiEntryHandling>(
                        dense: true,
                        title: Text('Keep the most recent entry', style: Theme.of(context).textTheme.subhead),
                        value: MultiEntryHandling.KeepLast,
                        groupValue: _multiEntryHandling,
                        onChanged: (MultiEntryHandling value) { setState(() { _multiEntryHandling = value; }); },
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                initialValue: _units,
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
                initialValue: _defaultValue,
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
              Visibility(
                visible: (_type == RowType.Number),
                child: TextFormField(
                  initialValue: _minValue,
                  decoration: InputDecoration(
                    labelText: 'Min value',
                    helperText: 'The minimum value allowed for an entry',
                  ),
                  validator: (value) { },
                  onSaved: (String value) {
                    setState(() { _minValue = value; });
                  },
                ),
              ),
              Visibility(
                visible: (_type == RowType.Number),
                child: TextFormField(
                  initialValue: _maxValue,
                  decoration: InputDecoration(
                    labelText: 'Max value',
                    helperText: 'The maximum value allowed for an entry',
                  ),
                  validator: (value) { },
                  onSaved: (String value) {
                    setState(() { _maxValue = value; });
                  },
                ),
              ),
              TextFormField(
                initialValue: _comment,
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

