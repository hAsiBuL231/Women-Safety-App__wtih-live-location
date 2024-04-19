import 'package:flutter/material.dart';

Widget searchButton() {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
    child: Row(mainAxisSize: MainAxisSize.max, children: [
      Expanded(
          child: TextFormField(
              //controller: _model.textController,
              //focusNode: _model.textFieldFocusNode,
              onChanged: (_) {},
              onFieldSubmitted: (_) async {},
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
      Padding(padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0), child: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.search_rounded))),
    ]),
  );
}
