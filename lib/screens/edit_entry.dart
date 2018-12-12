import 'package:flutter/material.dart';
import 'package:bullet/model/bullet_entry.dart';
import 'package:bullet/model/bullet_row.dart';
import 'package:bullet/datastore.dart';

// Edit (or create) a journal entry.
class EditBulletEntry extends StatefulWidget {
  final BulletRow row;
  final BulletEntry entry;
  EditBulletEntry(this.row, this.entry);

  @override
  State<StatefulWidget> createState() => EditBulletEntryState();
}

class EditBulletEntryState extends State<EditBulletEntry> {
  BulletDatastore _datastore = new BulletDatastore();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // The text entered in the "Value" field.
  String _enteredValue;
  // The text entered in the "Comment" field.
  String _enteredComment;

  @override
  Widget build(BuildContext context) {
    if (null != widget.entry) {
      _enteredValue = widget.entry.value.toString();
      _enteredComment = widget.entry.comment;
      print('EditBulletEntryState.build() with entry ${widget.entry.toString()}');
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${widget.row.name} Entry'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Form(
          key: this._formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _enteredValue,
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
                  initialValue: _enteredComment,
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
                  child: Text('Save Entry'),
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

      _showMessage('Saving entry...'); 

      if (null != widget.entry) {
        BulletEntry entry = BulletRow.newEntryForType(
          widget.row.type, 
          _enteredValue,
          widget.entry.time,
          _enteredComment
        );
        _datastore.updateEntry(widget.row, widget.entry, entry);
      } else {
        BulletEntry entry = BulletRow.newEntryForType(
          widget.row.type, 
          _enteredValue,
          DateTime.now(),
          _enteredComment
        );
        _datastore.addEntryToRow(widget.row, entry);
      }

      Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}