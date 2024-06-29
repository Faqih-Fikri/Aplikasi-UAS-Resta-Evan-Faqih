import 'package:flutter/material.dart';

class AddAlarm extends StatefulWidget {
  final Map<String, dynamic>? alarmData;

  AddAlarm({this.alarmData});

  @override
  _AddAlarmState createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  final _formKey = GlobalKey<FormState>();
  late TimeOfDay _selectedTime;
  late String _title;
  late String _description;
  late bool _enabled;
  late List<bool> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.alarmData?['time'] ?? TimeOfDay.now();
    _title = widget.alarmData?['title'] ?? '';
    _description = widget.alarmData?['description'] ?? '';
    _enabled = widget.alarmData?['enabled'] ?? true;
    _selectedDays = widget.alarmData?['days'] ?? List<bool>.filled(7, false);
  }

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1B2C57),
      appBar: AppBar(
        backgroundColor: Color(0xff1B2C57),
        title: Text('Add Alarm', style: TextStyle(color: Color(0xff65D1BA))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ListTile(
                  title:
                      Text('Time', style: TextStyle(color: Color(0xff65D1BA))),
                  subtitle: Text(
                    _selectedTime.format(context),
                    style: TextStyle(color: Color(0xff65D1BA)),
                  ),
                  trailing: Icon(Icons.access_time, color: Color(0xff65D1BA)),
                  onTap: _pickTime,
                ),
                TextFormField(
                  initialValue: _title,
                  style: TextStyle(color: Color(0xff65D1BA)),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Color(0xff65D1BA)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff65D1BA)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff65D1BA)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                TextFormField(
                  initialValue: _description,
                  style: TextStyle(color: Color(0xff65D1BA)),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Color(0xff65D1BA)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff65D1BA)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff65D1BA)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Repeat',
                    style: TextStyle(color: Color(0xff65D1BA), fontSize: 18),
                  ),
                ),
                Wrap(
                  spacing: 10.0,
                  children: List.generate(7, (index) {
                    return FilterChip(
                      label: Text(
                        [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun'
                        ][index],
                        style: TextStyle(color: Color(0xff1B2C57)),
                      ),
                      selected: _selectedDays[index],
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedDays[index] = selected;
                        });
                      },
                      backgroundColor: Color(0xff65D1BA),
                      selectedColor: Colors.white,
                    );
                  }),
                ),
                SwitchListTile(
                  title: Text(
                    'Enable Alarm',
                    style: TextStyle(color: Color(0xff65D1BA)),
                  ),
                  value: _enabled,
                  onChanged: (bool value) {
                    setState(() {
                      _enabled = value;
                    });
                  },
                  activeColor: Color(0xff65D1BA),
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xff65D1BA)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.of(context).pop({
                        'time': _selectedTime,
                        'title': _title,
                        'description': _description,
                        'enabled': _enabled,
                        'days': _selectedDays,
                      });
                    }
                  },
                  child: Text('Save',
                      style: TextStyle(color: Color(0xff1B2C57), fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
