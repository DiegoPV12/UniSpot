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

  void _submitReservation(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Timestamp day = Timestamp.fromDate(selectedDate);

      if (widget.reservation == null) {
        // Crear nueva reserva
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al crear la reserva: ${error.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        });
      } else {
        // Actualizar reserva existente
        ReservationModel updatedReservation = widget.reservation!.copyWith(
          reason: _reasonController.text,
          additionalNotes: _additionalNotesController.text,
          timeSlot: selectedTimeSlot,
          useMaterial: useMaterial,
          day: day,
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
