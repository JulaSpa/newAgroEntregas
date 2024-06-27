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
  var nroCP = TextEditingController();
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
            automaticallyImplyLeading: true,
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
                    padding: const EdgeInsets.only(top: 80),
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
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
                    padding: const EdgeInsets.only(top: 80),
                    constraints: const BoxConstraints(
                      minWidth:
                          1000, // Ajusta la altura mínima según tus necesidades
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
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
                  Container(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      child: TextField(
                        style: const TextStyle(color: Colors.white),

                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255))),
                          labelText: "Número CP",
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 252, 250, 250),
                              fontSize: 15),
                          contentPadding: EdgeInsets.only(left: 20),
                        ),
                        //CONTROLADOR CP
                        controller: nroCP,
                      ),
                    ),
                  ),
                  //BUSCAR

                  Container(
                    constraints:
                        const BoxConstraints(maxWidth: 400, minWidth: 100),
                    child: FractionallySizedBox(
                      widthFactor: 0.2,
                      child: Container(
                        margin: const EdgeInsets.only(top: 170),
                        decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          title: const Icon(Icons.search),
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final String cpBuscarPage = nroCP.text;
                            await prefs.setString('cpBuscarPage', cpBuscarPage);

                            if (_selectedFromDate != null &&
                                _selectedToDate != null) {
                              await prefs.setString('fromDate',
                                  _selectedFromDate!.toIso8601String());
                              await prefs.setString(
                                  'toDate', _selectedToDate!.toIso8601String());
                            } else {
                              // Si las fechas no están seleccionadas, borra las entradas de SharedPreferences
                              await prefs.remove('fromDate');
                              await prefs.remove('toDate');
                            }

                            // Usa el contexto almacenado dentro del contexto asíncrono
                            Future.microtask(() {
                              Navigator.pushNamed(context, "/buscar");
                            });
                          },
                        ),
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
