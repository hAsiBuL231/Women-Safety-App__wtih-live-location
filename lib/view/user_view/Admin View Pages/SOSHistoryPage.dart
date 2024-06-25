import 'package:flutter/material.dart';

import '../../../.utils/Functions.dart';
import '../../../components/list_tile.dart';
import '../../../repository/sos_history_repo/SOSHistoryRepo.dart';
import 'IndividualSOSHistoryPage.dart';

class SOSHistoryPage extends StatefulWidget {
  const SOSHistoryPage({super.key});

  @override
  State<SOSHistoryPage> createState() => _SOSHistoryPageState();
}

class _SOSHistoryPageState extends State<SOSHistoryPage> {
  List<Map<String, dynamic>> responseUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];

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
    var response = await sosRepo.getAllUserSOSHistoryApi(context);
    responseUsers = List<Map<String, dynamic>>.from(response["results"]);
    filteredUsers = List.from(responseUsers);
    setState(() {});
  }

  void filterUsers(String query) {
    // List<Map<String, dynamic>> filtered = responseUsers.where((user) {
    //   return user["name"].toLowerCase().contains(query.toLowerCase()) ||
    //       user["email"].toLowerCase().contains(query.toLowerCase()) ||
    //       user["phone"].toString().contains(query);
    // }).toList();

    List<Map<String, dynamic>> filtered = responseUsers.where((user) {
      final userNameMatches = user["name"].toLowerCase().contains(query.toLowerCase());
      final userEmailMatches = user["email"].toLowerCase().contains(query.toLowerCase());
      final userPhoneMatches = user["phone"].toString().contains(query);

      bool dateMatches = true;
      if (startDate != null && endDate != null) {
        final updatedTime = DateTime.parse(user["updated"]);
        dateMatches = updatedTime.isAfter(startDate!) && updatedTime.isBefore(endDate!);
      }

      return (userNameMatches || userEmailMatches || userPhoneMatches) && dateMatches;
    }).toList();

    setState(() {
      filteredUsers = List.from(filtered);
    });
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
                          'SOS History',
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
                        child: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.search_rounded))),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Expanded(
                        child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Start Date (YYYY-MM-DD)',
                              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(width: 2), borderRadius: BorderRadius.circular(12)),
                              filled: true,
                            ),
                            onChanged: (value) {
                              setState(() {
                                startDate = DateTime.tryParse(value);
                              });
                            })),
                    const SizedBox(width: 12),
                    Expanded(
                        child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'End Date (YYYY-MM-DD)',
                              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(width: 2), borderRadius: BorderRadius.circular(12)),
                              filled: true,
                            ),
                            onChanged: (value) {
                              setState(() {
                                endDate = DateTime.tryParse(value);
                              });
                            })),
                  ]),
                ),
                ListView.builder(
                    itemCount: filteredUsers.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var data = filteredUsers[index];
                      return customListTile(
                          title: data['name'],
                          imageUrl: data['imageUrl'],
                          subTitle: 'See live location..',
                          onPress: () => nextPage(IndividualSOSHistoryPage(securityCode: data['securityCode']), context));
                    }),
              ]),
            ),
          ),
        ));
  }
}
