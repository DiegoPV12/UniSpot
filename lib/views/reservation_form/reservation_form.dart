import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/reservation_service.dart';
import '../../models/space_model.dart';
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
              // Selector de fecha
              Card(
                elevation: 5,
                color: const Color(0xFFECDFE4),
                surfaceTintColor: const Color(0xFFECDFE4),
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
              ),
              // Dropdown para seleccionar horario
              DropdownButtonFormField<String>(
                value: selectedTimeSlot,
                decoration:
                    const InputDecoration(labelText: 'Horario de Reserva'),
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
              // Campo de texto para la razón de la reserva
              TextFormField(
                controller: _reasonController,
                decoration:
                    const InputDecoration(labelText: 'Razón de la Reserva'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese la razón de la reserva' : null,
              ),
              // Campo de texto para detalles adicionales
              TextFormField(
                controller: _additionalNotesController,
                decoration:
                    const InputDecoration(labelText: 'Detalles Adicionales'),
              ),
              // Checkbox para el uso de material
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
                  const Text('Utilizar Material de la Sala'),
                ],
              ),
              // Botón para confirmar la reserva
              ElevatedButton(
                onPressed: () => _submitReservation(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 129, 40, 75),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirmar Reserva'),
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
