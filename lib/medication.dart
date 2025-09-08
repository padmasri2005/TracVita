import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class MedicationAlarmScreen extends StatefulWidget {
  const MedicationAlarmScreen({Key? key}) : super(key: key);

  @override
  _MedicationAlarmScreenState createState() => _MedicationAlarmScreenState();
}

class _MedicationAlarmScreenState extends State<MedicationAlarmScreen> {
  final _formKey = GlobalKey<FormState>();
  String _medicationName = '';
  String _frequency = 'Once a day';
  int _numberOfDays = 1;
  List<dynamic> medicationAlarms = [];
  late List<TimeOfDay> _medicationTimes = [TimeOfDay.now()];

  @override
  void initState() {
    super.initState();
    _retrieveMedicationAlarms();
  }

  Future<void> _retrieveMedicationAlarms() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('medicationAlarms')) {
        var medicationAlarmsData = userData['medicationAlarms'];
        if (medicationAlarmsData != null) {
          setState(() {
            medicationAlarms = List.from(medicationAlarmsData);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.jpg',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'TracVita',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(76, 15, 119, 1),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 6, 6, 6)),
      ),
      backgroundColor: Color.fromARGB(255, 95, 202, 177),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/meds.jpg',
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: ElevatedButton(
                onPressed: () {
                  _showAddMedicationModal(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('Add Medication'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  textStyle: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: medicationAlarms.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> medicationAlarm = medicationAlarms[index];
                var medicationTimes = medicationAlarm['medicationTimes'];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border.all(
                        color: const Color.fromARGB(255, 13, 14, 15)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.medication),
                              SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text(
                                  medicationAlarm['medicationName'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteMedication(index);
                            },
                          ),
                        ],
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Times',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 8,
                        children: medicationTimes != null
                            ? (medicationTimes as List)
                                .map<Widget>((time) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            Color.fromARGB(255, 95, 103, 110),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        time,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: const Color.fromARGB(
                                                255, 13, 12, 12)),
                                      ),
                                    ))
                                .toList()
                            : [],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMedicationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Medication Name', style: TextStyle(fontSize: 18)),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a medication name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _medicationName = value!;
                        });
                      },
                      decoration:
                          InputDecoration(hintText: 'Enter medication name'),
                    ),
                    SizedBox(height: 16),
                    Text('Frequency', style: TextStyle(fontSize: 18)),
                    DropdownButton<String>(
                      value: _frequency,
                      onChanged: (value) {
                        setState(() {
                          _frequency = value!;
                          _medicationTimes = _frequency == 'Twice a day'
                              ? [
                                  TimeOfDay(hour: 8, minute: 0),
                                  TimeOfDay(hour: 20, minute: 0)
                                ]
                              : [TimeOfDay.now()];
                        });
                      },
                      items: <String>['Once a day', 'Twice a day']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    Text('Medication Times', style: TextStyle(fontSize: 18)),
                    Column(
                      children: _medicationTimes.map((time) {
                        return Row(
                          children: <Widget>[
                            Expanded(
                              child: TextButton(
                                child: Text(
                                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                onPressed: () async {
                                  final TimeOfDay? picked =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: time,
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _medicationTimes[_medicationTimes
                                          .indexOf(time)] = picked;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    Text('Number of Days', style: TextStyle(fontSize: 18)),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (_numberOfDays > 1) _numberOfDays--;
                            });
                          },
                        ),
                        Text('$_numberOfDays days',
                            style: TextStyle(fontSize: 16)),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _numberOfDays++;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            String userId =
                                FirebaseAuth.instance.currentUser!.uid;
                            List<String> medicationTimes = _medicationTimes
                                .map((time) =>
                                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}')
                                .toList();

                            Map<String, dynamic> medicationAlarmData = {
                              'medicationName': _medicationName,
                              'medicationTimes': medicationTimes,
                              'frequency': _frequency,
                              'numberOfDays': _numberOfDays,
                            };

                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .set({
                                'medicationAlarms': FieldValue.arrayUnion(
                                    [medicationAlarmData]),
                              }, SetOptions(merge: true));

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Medication alarm set successfully!')),
                              );
                              Navigator.pop(context);
                              _retrieveMedicationAlarms();
                            } catch (e) {
                              print('Error setting medication alarm: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Failed to set medication alarm. Please try again later.'),
                                ),
                              );
                            }
                          }
                        },
                        child: Text('Add Medication'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _deleteMedication(int index) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'medicationAlarms': FieldValue.arrayRemove([medicationAlarms[index]]),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Medication deleted successfully!')),
      );
      setState(() {
        medicationAlarms.removeAt(index);
      });
    } catch (e) {
      print('Error deleting medication: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to delete medication. Please try again later.')),
      );
    }
  }
}
