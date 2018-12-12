import 'package:flutter/material.dart';
import 'package:bullet/model/bullet_entry.dart';
import 'package:bullet/model/bullet_row.dart';
import 'package:bullet/datastore.dart';

class NewBulletEntry extends StatefulWidget {
  final BulletRow row;
  NewBulletEntry(this.row);

  @override
  State<StatefulWidget> createState() => NewBulletEntryState();
}

class NewBulletEntryState extends State<NewBulletEntry> {
  BulletDatastore _datastore = new BulletDatastore();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // The text entered in the "Value" field.
  String _enteredValue;
  // The text entered in the "Comment" field.
  String _enteredComment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New ${widget.row.name} Entry'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Form(
          key: this._formKey,
          child: Column(
            children: [
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
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Comment',
                  ),
                  onSaved: (String value) {
                    setState(() { _enteredComment = value; });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 16.0),
                child: RaisedButton(
                  onPressed: _submitForm,
                  child: Text('Create Entry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Consider using TextInputController? 
  // https://flutterbyexample.com/forms-1-user-input
  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      _showMessage('Invalid entry, please review and correct.');
    } else {
      form.save();

      BulletEntry entry = BulletRow.newEntryForType(
        widget.row.type, 
        _enteredValue,
        DateTime.now(),
        _enteredComment
      );

      _showMessage('Saving entry...'); 
      _datastore.addEntryToRow(widget.row, entry);

      Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}