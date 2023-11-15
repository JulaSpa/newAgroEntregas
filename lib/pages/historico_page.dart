import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchArguments {
  final DateTime? fromDate;
  final DateTime? toDate;

  SearchArguments({this.fromDate, this.toDate});
}

class Historic extends StatefulWidget {
  const Historic({super.key});

  @override
  State<Historic> createState() => _HistoricState();
}

class _HistoricState extends State<Historic> {
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  /* Future<void> _saveSelectedDates() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedFromDate != null && _selectedToDate != null) {
      await prefs.setString('fromDate', _selectedFromDate!.toIso8601String());
      await prefs.setString('toDate', _selectedToDate!.toIso8601String());
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/images/camiones.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Image.asset("lib/images/logoAgroEntregas.png"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            toolbarHeight: 60,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  // Campo "desde"
                  Container(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(80, 100, 80, 50),
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _selectFromDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Text(
                                      _selectedFromDate != null
                                          ? 'Desde: ${DateFormat('dd/MM/y').format(_selectedFromDate!)}'
                                          : 'Desde: dd/mm/a',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.calendar_month,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Campo "hasta"
                  Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(80, 0, 80, 0),
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _selectToDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Text(
                                      _selectedToDate != null
                                          ? 'Hasta: ${DateFormat('dd/MM/y').format(_selectedToDate!)}'
                                          : 'Hasta: dd/mm/a',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.calendar_month,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //BUSCAR

                  FractionallySizedBox(
                    widthFactor: 0.4,
                    child: Container(
                      margin:
                          const EdgeInsetsDirectional.fromSTEB(170, 50, 170, 0),
                      decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        title: const Icon(Icons.search),
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          if (_selectedFromDate != null &&
                              _selectedToDate != null) {
                            await prefs.setString('fromDate',
                                _selectedFromDate!.toIso8601String());
                            await prefs.setString(
                                'toDate', _selectedToDate!.toIso8601String());
                          }

                          // Usa el contexto almacenado dentro del contexto asíncrono
                          Future.microtask(() {
                            Navigator.pushNamed(context, "/buscar");
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Funciones para mostrar los calendarios para seleccionar las fechas
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFromDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedFromDate) {
      setState(() {
        _selectedFromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedToDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedToDate) {
      setState(() {
        _selectedToDate = picked;
      });
    }
  }
}
