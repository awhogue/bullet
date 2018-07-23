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
              _makeRadioButtons<BulletRowDataType>(
                label: 'Data type:',
                values: BulletRowDataType.values,
                selectedValue: _rowDataType,
                onTap: (dataType) {
                  setState(() {
                    _rowDataType = dataType;
                  });
                },
                dataTypeToString: (dataType) { return BulletRow.dataTypeToUserString(dataType); },
              ),
              _makeRadioButtons<BulletRowMultiEntryType>(
                label: 'Handle multiple entries by:',
                values: BulletRowMultiEntryType.values,
                selectedValue: _rowMultiEntryType,
                onTap: (dataType) {
                  setState(() {
                    _rowMultiEntryType = dataType;
                  });
                },
                shouldShowButton: (dataType) {
                  // Skip entry types that are incompatible with each other.
                  // Can't "accumulate" entries that are boolean checkmarks or ranged numbers.
                  if ((_rowDataType == BulletRowDataType.Checkmark || 
                       _rowDataType == BulletRowDataType.NumberRange) &&
                      dataType == BulletRowMultiEntryType.Accumulate) {
                    // Clear the existing type so we don't accidentally save it.
                    _rowMultiEntryType = null;
                    return false;
                  }
                  return true;
                },
                dataTypeToString: (dataType) { return BulletRow.multiEntryTypeToUserString(dataType); },
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

  // Make one radio button for users to select an attribute of the row 
  // (e.g. Data Type or Multi Entry Type).
  Widget _makeRadioButton(String title, bool isSelected, Function onTap) {
    return Container(
      //margin: EdgeInsets.all(5.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(5.0),
          decoration: new BoxDecoration(
            border: new Border.all(color: Theme.of(context).dividerColor)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? Theme.of(context).accentColor : Theme.of(context).buttonColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],  
          ),
        ),
      ),
    );
  }

  // Make a set of radio buttons. 
  // 'shouldShowButton' is a function to validate whether the given button should be visible or not given the current state.
  Widget _makeRadioButtons<T>({
    @required String label,
    @required Function(T) onTap,
    @required List<T> values,  // Have to do this because dart doesn't seem to handle T.values for an enum.
    @required T selectedValue,
    Function(T) shouldShowButton,
    Function(T) dataTypeToString
    }) {

    List<Widget> radios = new List();
    for (T dataType in values) {
      if (shouldShowButton != null && !shouldShowButton(dataType)) continue;
      radios.add(_makeRadioButton(
        (dataTypeToString != null ? dataTypeToString(dataType) : dataType.toString()),
        (dataType == selectedValue),
        () => onTap(dataType)
      ));
    }

    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.headline,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: radios,
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
        _rowDataType,
        _rowMultiEntryType,
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

