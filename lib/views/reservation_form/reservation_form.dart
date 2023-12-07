// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unispot/models/reservation_model.dart';
import '../../services/reservation_service.dart';
import '../../models/space_model.dart';
import '../../widgets/shared/reservation_input_widget.dart';
import 'notification.dart';

class ReservationDetailsForm extends StatefulWidget {
  final SpaceModel space;
  final ReservationModel? reservation;

  const ReservationDetailsForm({
    super.key,
    required this.space,
    this.reservation,
  });

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
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    if (widget.reservation != null) {
      DateTime reservationDate = widget.reservation!.day.toDate();
      if (reservationDate.isBefore(now)) {
        selectedDate = now;
      } else {
        selectedDate = reservationDate;
      }
      _reasonController.text = widget.reservation!.reason;
      _additionalNotesController.text = widget.reservation!.additionalNotes;
      selectedTimeSlot = widget.reservation!.timeSlot;
      useMaterial = widget.reservation!.useMaterial;
    } else {
      selectedDate = now;
    }
  }

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
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: GestureDetector(
                        onTap: () => _selectStartTime(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: inputDecoration.getDecoration(
                                hintText: 'Inicio'),
                            controller: TextEditingController(
                              text: _selectedStartTime != null
                                  ? _selectedStartTime!.format(context)
                                  : '',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: GestureDetector(
                        onTap: () => _selectEndTime(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: inputDecoration.getDecoration(
                                hintText: 'Finalizacion'),
                            controller: TextEditingController(
                              text: _selectedEndTime != null
                                  ? _selectedEndTime!.format(context)
                                  : '',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _reasonController,
                  maxLength: 250,
                  cursorColor: const Color.fromARGB(255, 129, 40, 75),
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
                  maxLength: 250,
                  cursorColor: const Color.fromARGB(255, 129, 40, 75),
                  decoration: inputDecoration.getDecoration(
                      hintText: 'Detalles Adicionales'),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Checkbox(
                      activeColor: const Color.fromARGB(255, 129, 40, 75),
                      value: useMaterial,
                      onChanged: (bool? value) {
                        setState(() {
                          useMaterial = value ?? false;
                        });
                      },
                    ),
                  ),
                  const Text('DESEA UTILIZAR MATERIAL DE LA SALA'),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: SizedBox(
                    height: 45,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () => _submitReservation(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 129, 40, 75),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('RESERVAR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: ThemeData(
              colorScheme: ColorScheme.light(
                primary: const Color.fromARGB(255, 129, 40, 75),
                onPrimary: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 129, 40, 75),
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null && picked != _selectedStartTime) {
      setState(() {
        _selectedStartTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime ?? (_selectedStartTime ?? TimeOfDay.now()),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: ThemeData(
              colorScheme: ColorScheme.light(
                primary: const Color.fromARGB(255, 129, 40, 75),
                onPrimary: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 129, 40, 75),
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      if (_selectedStartTime != null &&
          (picked.hour < _selectedStartTime!.hour ||
              (picked.hour == _selectedStartTime!.hour &&
                  picked.minute < _selectedStartTime!.minute))) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'La hora de finalización no puede ser anterior a la hora de inicio.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        setState(() {
          _selectedEndTime = picked;
        });
      }
    }
  }

  void _submitReservation(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      DateTime startDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        _selectedStartTime?.hour ?? 0,
        _selectedStartTime?.minute ?? 0,
      );
      DateTime endDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        _selectedEndTime?.hour ?? 0,
        _selectedEndTime?.minute ?? 0,
      );

      if (widget.reservation == null) {
        ReservationService.instance
            .createReservation(
          spaceId: widget.space.uid,
          reason: _reasonController.text,
          additionalNotes: _additionalNotesController.text,
          useMaterial: useMaterial,
          day: selectedDate,
          startTime: TimeOfDay.fromDateTime(startDateTime),
          endTime: TimeOfDay.fromDateTime(endDateTime),
        )
            .then((_) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NotificationPage()),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al crear la reserva: ${error.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        });
      } else {
        ReservationModel updatedReservation = widget.reservation!.copyWith(
          reason: _reasonController.text,
          additionalNotes: _additionalNotesController.text,
          useMaterial: useMaterial,
          day: Timestamp.fromDate(selectedDate),
          startTime: Timestamp.fromDate(startDateTime),
          endTime: Timestamp.fromDate(endDateTime),
        );

        ReservationService.instance
            .updateReservation(updatedReservation)
            .then((_) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NotificationPage()),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Error al actualizar la reserva: ${error.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    }
  }
}
