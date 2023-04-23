import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/table/table_bloc.dart';
import 'custom_alert_dialog.dart';
import 'custom_card.dart';
import 'custom_select_box.dart';

class TableSelector extends StatefulWidget {
  final Function(int) onSelect;
  final String label;
  const TableSelector({
    super.key,
    required this.onSelect,
    required this.label,
  });

  @override
  State<TableSelector> createState() => _TableSelectorState();
}

class _TableSelectorState extends State<TableSelector> {
  final TableBloc departmentBloc = TableBloc();

  @override
  void initState() {
    departmentBloc.add(GetAllTableEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: BlocProvider<TableBloc>.value(
        value: departmentBloc,
        child: BlocConsumer<TableBloc, TableState>(
          listener: (context, state) {
            if (state is TableFailureState) {
              showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                  title: 'Failed!',
                  message: state.message,
                  primaryButtonLabel: 'Retry',
                  primaryOnPressed: () {
                    departmentBloc.add(GetAllTableEvent());
                    Navigator.pop(context);
                  },
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is TableSuccessState) {
              return CustomSelectBox(
                iconData: Icons.table_bar,
                items: List<CustomSelectBoxItem>.generate(
                  state.tables.length,
                  (index) => CustomSelectBoxItem(
                    value: state.tables[index]['id'],
                    label: state.tables[index]['name'],
                  ),
                ),
                label: widget.label,
                onChange: (selected) {
                  widget.onSelect(selected != null ? selected.value : 0);
                },
              );
            } else if (state is TableFailureState) {
              return const SizedBox();
            } else {
              return const SizedBox(
                width: 100,
                child: SizedBox(
                  height: 2,
                  child: LinearProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
