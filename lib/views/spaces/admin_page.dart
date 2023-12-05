// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/reservation_model.dart';
import '../../services/reservation_service.dart';
import '/widgets/profile/admin_reservation_card.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final ReservationService reservationService = ReservationService.instance;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String selectedFilter = 'Todas';
  Set<DateTime> daysWithApprovedReservations = {};

  @override
  void initState() {
    super.initState();
    _loadApprovedReservations();
  }

  void _loadApprovedReservations() async {
    var approvedReservations = await reservationService.getApprovedReservations();
    setState(() {
      daysWithApprovedReservations.clear();
      for (var reservation in approvedReservations) {
        DateTime date = reservation.day.toDate();
        daysWithApprovedReservations.add(DateTime(date.year, date.month, date.day));
      }
    });
  }

  void refreshReservations() {
    setState(() {});
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: SpinKitFadingCircle(
        color: Colors.deepPurple,
        size: 50.0,
      ),
    );
  }

  Widget _buildReservationsSection(String title, List<ReservationModel> reservations) {
    if (reservations.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...reservations.map((reservation) => AdminReservationCardWidget(
          reservation: reservation,
          onReservationChanged: refreshReservations,
        )).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 201, 213),
        title: const Text('Panel de Administración'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (daysWithApprovedReservations.contains(DateTime(date.year, date.month, date.day))) {
                    return Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        width: 7.0,
                        height: 7.0,
                      ),
                    );
                  }
                  return null;
                },
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 233, 201, 213),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
                // Otros estilos del calendario...
              ),
              // Resto de las propiedades del TableCalendar...
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedFilter,
              items: <String>['Todas', 'Pendientes', 'Aprobadas', 'Rechazadas', 'Canceladas']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedFilter = newValue!;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ReservationModel>>(
              future: reservationService.getAllReservations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No hay reservas.');
                }

                List<ReservationModel> reservations = snapshot.data!;
                reservations.sort((a, b) => b.day.compareTo(a.day));

                reservations = reservations.where((reservation) {
                  switch (selectedFilter) {
                    case 'Pendientes':
                      return reservation.status == 'pending';
                    case 'Aprobadas':
                      return reservation.status == 'approved';
                    case 'Rechazadas':
                      return reservation.status == 'rejected';
                    case 'Canceladas':
                      return reservation.status == 'cancelled';
                    case 'Todas':
                    default:
                      return true;
                  }
                }).toList();

                return ListView(
                  children: [
                    _buildReservationsSection('Pendientes', reservations.where((r) => r.status == 'pending').toList()),
                    _buildReservationsSection('Aprobadas', reservations.where((r) => r.status == 'approved').toList()),
                    _buildReservationsSection('Rechazadas', reservations.where((r) => r.status == 'rejected').toList()),
                    _buildReservationsSection('Canceladas', reservations.where((r) => r.status == 'cancelled').toList()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
