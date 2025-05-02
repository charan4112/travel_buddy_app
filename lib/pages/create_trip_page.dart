import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tripName       = TextEditingController();
  final TextEditingController _startLocation  = TextEditingController();
  final TextEditingController _endLocation    = TextEditingController();
  final TextEditingController _cost           = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;
  String? _message;

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _saveTrip() async {
    if (!_formKey.currentState!.validate() || _startDate == null || _endDate == null) {
      setState(() => _message = "Please complete all fields including dates.");
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _message = "Not logged in.");
        return;
      }

      await FirebaseFirestore.instance.collection('trips').add({
        'name'         : _tripName.text.trim(),
        'startLocation': _startLocation.text.trim(),
        'endLocation'  : _endLocation.text.trim(),
        'startDate'    : _startDate,
        'endDate'      : _endDate,
        'cost'         : double.tryParse(_cost.text.trim()) ?? 0,
        'userId'       : user.uid,
        'createdAt'    : Timestamp.now(),
      });

      setState(() {
        _message = "Trip created successfully!";
      });
      _formKey.currentState?.reset();
      _startDate = null;
      _endDate = null;
    } catch (e) {
      setState(() => _message = "Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tripName.dispose();
    _startLocation.dispose();
    _endLocation.dispose();
    _cost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _tripName,
              decoration: const InputDecoration(labelText: "Trip Name"),
              validator: (val) => val == null || val.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _startLocation,
              decoration: const InputDecoration(labelText: "Start Location"),
              validator: (val) => val == null || val.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _endLocation,
              decoration: const InputDecoration(labelText: "End Location"),
              validator: (val) => val == null || val.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(_startDate == null
                      ? "Start Date: Not selected"
                      : "Start: ${_startDate!.toLocal()}".split(' ')[0]),
                ),
                TextButton(
                  onPressed: () => _pickDate(isStart: true),
                  child: const Text("Pick Start Date"),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(_endDate == null
                      ? "End Date: Not selected"
                      : "End: ${_endDate!.toLocal()}".split(' ')[0]),
                ),
                TextButton(
                  onPressed: () => _pickDate(isStart: false),
                  child: const Text("Pick End Date"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cost,
              decoration: const InputDecoration(labelText: "Cost (USD)"),
              keyboardType: TextInputType.number,
              validator: (val) => val == null || val.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 20),
            if (_message != null)
              Text(
                _message!,
                style: TextStyle(
                  color: _message!.contains("success") ? Colors.green : Colors.red,
                ),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveTrip,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text("Create Trip"),
            ),
          ],
        ),
      ),
    );
  }
}
