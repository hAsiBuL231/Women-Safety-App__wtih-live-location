import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../repository/sos_history_repo/SOSHistoryRepo.dart';

class IndividualSOSHistoryPage extends StatefulWidget {
  final String securityCode;
  const IndividualSOSHistoryPage({super.key, required this.securityCode});

  @override
  State<IndividualSOSHistoryPage> createState() => _IndividualSOSHistoryPageState();
}

class _IndividualSOSHistoryPageState extends State<IndividualSOSHistoryPage> {
  List<Map<String, dynamic>> responseData = [];
  List<Map<String, dynamic>> filteredData = [];

  DateTime? startDate;
  DateTime? endDate;

  SOSHistoryRepo sosRepo = SOSHistoryRepo();

  @override
  void initState() {
    super.initState();
    fetchUsersData();
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  Future<void> fetchUsersData() async {
    var response = await sosRepo.getUserSOSHistoryApi(widget.securityCode, context);
    responseData = List<Map<String, dynamic>>.from(response["history"]);
    filteredData = List.from(responseData);
    setState(() {});
  }

  void filterUsers(String query) {
    List<Map<String, dynamic>> filtered = responseData.where((user) {
      final userNameMatches = user["name"].toLowerCase().contains(query.toLowerCase());
      final userEmailMatches = user["email"].toLowerCase().contains(query.toLowerCase());
      final userPhoneMatches = user["number"].toString().contains(query);

      bool dateMatches = true;
      if (startDate != null && endDate != null) {
        final updatedTime = DateTime.parse(user["updated"]);
        dateMatches = updatedTime.isAfter(startDate!) && updatedTime.isBefore(endDate!);
      }

      return (userNameMatches || userEmailMatches || userPhoneMatches) && dateMatches;
    }).toList();

    setState(() {
      filteredData = filtered;
    });
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2201));

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

      if (pickedTime != null) {
        final DateTime dateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);

        setState(() {
          if (isStart) {
            startDate = dateTime;
          } else {
            endDate = dateTime;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(6, 60, 6, 10),
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(children: [
                const Center(
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          'SOS History Details',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black),
                        ))),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Expanded(
                        child: TextFormField(
                            //controller: _model.textController,
                            //focusNode: _model.textFieldFocusNode,
                            onChanged: (_value) => filterUsers(_value),
                            onFieldSubmitted: (_value) async => filterUsers(_value),
                            //autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Search members...',
                              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(width: 2), borderRadius: BorderRadius.circular(12)),
                              errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(12)),
                              focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              //fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                            ))),
                    Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: FloatingActionButton(onPressed: () => filterUsers(""), child: const Icon(Icons.search_rounded))),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Start Date and Time',
                          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(width: 2), borderRadius: BorderRadius.circular(12)),
                          filled: true,
                        ),
                        onTap: () => _selectDateTime(context, true),
                        controller: TextEditingController(
                          text: startDate != null ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ").format(startDate!) : '',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'End Date and Time',
                          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(width: 2), borderRadius: BorderRadius.circular(12)),
                          filled: true,
                        ),
                        onTap: () => _selectDateTime(context, false),
                        controller: TextEditingController(
                          text: endDate != null ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ").format(endDate!) : '',
                        ),
                      ),
                    ),
                  ]),
                ),
                ListView.builder(
                    itemCount: filteredData.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var data = filteredData[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              RichText(
                                text: TextSpan(children: [
                                  const TextSpan(
                                    text: "Location: ",
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: "${data['location']}",
                                    style: const TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                ]),
                              ),
                              const SizedBox(height: 8.0),
                              RichText(
                                text: TextSpan(children: [
                                  const TextSpan(
                                    text: "Latitude: ",
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: "${data['latitude']}",
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ]),
                              ),
                              const SizedBox(height: 8.0),
                              RichText(
                                text: TextSpan(children: [
                                  const TextSpan(
                                    text: "Longitude: ",
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: "${data['longitude']}",
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ]),
                              ),
                              const SizedBox(height: 8.0),
                              RichText(
                                text: TextSpan(children: [
                                  const TextSpan(
                                    text: "Phone Numbers: ",
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: "${data['phone_numbers']}",
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ]),
                              ),
                              const SizedBox(height: 8.0),
                              RichText(
                                text: TextSpan(children: [
                                  const TextSpan(
                                    text: "Updated: ",
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                  ),
                                  TextSpan(
                                    text: "${data['updated']}",
                                    style: const TextStyle(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic),
                                  ),
                                ]),
                              ),
                            ]),
                          ),
                        ),
                      );
                    }),
              ]),
            ),
          ),
        ));
  }
}
