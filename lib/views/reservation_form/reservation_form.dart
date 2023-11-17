import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/reservation_service.dart';
import '../../models/space_model.dart';
import '../../widgets/shared/reservation_input_widget.dart';
import 'notification.dart';

class ReservationDetailsForm extends StatefulWidget {
  final SpaceModel space;

  const ReservationDetailsForm({super.key, required this.space});

  @override
  State<ReservationDetailsForm> createState() => _ReservationDetailsFormState();
}

class _ReservationDetailsFormState extends State<ReservationDetailsForm> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _additionalNotesController =
      TextEditingController();
  String? selectedTimeSlot;
  bool useMaterial = false;
  final inputDecoration = ReservationInputDecoration();

  DateTime selectedDate = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Reservación',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.space.name,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                  elevation: 10,
                  surfaceTintColor: Colors.white60,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color.fromARGB(255, 129, 40, 75),
                      ),
                      dialogBackgroundColor: Colors.white,
                    ),
                    child: CalendarDatePicker(
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 7)),
                      onDateChanged: (newDate) {
                        setState(() {
                          selectedDate = newDate;
                        });
                      },
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: DropdownButtonFormField<String>(
                  value: selectedTimeSlot,
                  decoration:
                      inputDecoration.getDecoration(hintText: 'Horario'),
                  items: widget.space.availableTimeSlots
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTimeSlot = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Seleccione un horario' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _reasonController,
                  decoration: inputDecoration.getDecoration(
                      hintText: 'Razón de la Reserva'),
                  validator: (value) =>
                      value!.isEmpty ? 'Ingrese la razón de la reserva' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _additionalNotesController,
                  decoration: inputDecoration.getDecoration(
                      hintText: 'Detalles Adicionales'),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: useMaterial,
                    onChanged: (bool? value) {
                      setState(() {
                        useMaterial = value ?? false;
                      });
                    },
                  ),
                  const Text('Utilizar material de la sala'),
                ],
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () => _submitReservation(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 129, 40, 75),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('RESERVAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitReservation(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Timestamp day = Timestamp.fromDate(selectedDate);
      ReservationService.instance
          .createReservation(
        spaceId: widget.space.uid,
        reason: _reasonController.text,
        additionalNotes: _additionalNotesController.text,
        timeSlot: selectedTimeSlot,
        useMaterial: useMaterial,
        day: day,
      )
          .then((_) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const NotificationPage()),
        );
      }).catchError((error) {
        // Mostrar snackbar con el mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }
}
