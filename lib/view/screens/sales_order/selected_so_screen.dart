import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/foreign_po/foreign_po_cubit.dart';
import 'package:slic/cubits/home/home_cubit.dart';
import 'package:slic/cubits/line_item/line_item_cubit.dart';
import 'package:slic/cubits/sales_order/sales_order_cubit.dart';
import 'package:slic/models/sales_order_model.dart';
import 'package:slic/models/so_line_item_model.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/loading/loading_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SelectedSoScreen extends StatefulWidget {
  const SelectedSoScreen({super.key});

  @override
  State<SelectedSoScreen> createState() => _SelectedSoScreenState();
}

class _SelectedSoScreenState extends State<SelectedSoScreen> {
  int? selectedRowIndex;

  @override
  void initState() {
    super.initState();
    LineItemCubit.get(context).soLineItems.clear();
    LineItemCubit.get(context).selectedSysId = null;
    LineItemCubit.get(context).counter.clear();
    LineItemCubit.get(context).lineItems.clear();
    LineItemCubit.get(context).soLineItemsMap.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: _buildPOListTable(
                  SalesOrderCubit.get(context).selectedSalesOrder,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                child: BlocConsumer<LineItemCubit, LineItemState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is LineItemGetBySysIdLoading) {
                      // return const LoadingWidget();
                      return _buildLineItemsTable([]);
                    }
                    return _buildLineItemsTable(
                      LineItemCubit.get(context).soLineItems,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<LineItemCubit, LineItemState>(
                  buildWhen: (previous, current) =>
                      current is LineItemGetBySysIdSuccess,
                  builder: (context, state) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: ColorPallete.primary,
                              )),
                              child: Text(
                                  "Total: ${ForeignPoCubit.get(context).selectedPOList.length}"),
                            ),
                            BlocConsumer<LineItemCubit, LineItemState>(
                              listener: (context, state) {
                                if (state is LineItemSOToGRNSuccess) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          state
                                              .message, // Display the message from the state
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(state
                                                .message), // Display the main message
                                            ...[
                                              const SizedBox(height: 16),
                                              if (state.grnSysId != null)
                                                Text(
                                                    "GRN System ID: ${state.grnSysId}"), // Display GRN System ID if not null
                                              if (state.grnDocNo != null)
                                                Text(
                                                    "GRN Document No: ${state.grnDocNo}"), // Display GRN Document No if not null
                                            ],
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigation.pop(context);
                                              Navigation.pop(context);
                                              Navigation.pop(context);
                                            },
                                            child: const Text("OK"),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  LineItemCubit.get(context).clearAll();
                                  SalesOrderCubit.get(context).clearAll();
                                } else if (state is LineItemSOToGRNError) {
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    CustomSnackBar.error(
                                      message: state.message,
                                    ),
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is LineItemSOToGRNLoading) {
                                  return const LoadingWidget();
                                }
                                return AppButton(
                                  text: "Submit GRN",
                                  onPressed: () {
                                    LineItemCubit.get(context).soToGRN(
                                      HomeCubit.get(context).locationCode,
                                      selectedSOs: SalesOrderCubit.get(context)
                                          .selectedSalesOrder,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: ColorPallete.primary,
                              )),
                              child: Text(
                                  "Total: ${LineItemCubit.get(context).poLineItems.length}"),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: ColorPallete.primary,
                              )),
                              child: Text(
                                "Picked Qty: ${LineItemCubit.get(context).counter.length}",
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPOListTable(List<SalesOrderModel> data) {
    _DataSource dataSource =
        _DataSource(data, selectedRowIndex, (index, selected) {
      setState(() {
        if (selected) {
          selectedRowIndex = index;
          LineItemCubit.get(context).selectedSysId =
              data[index].listOfSO!.hEADSYSID.toString();
          context.read<LineItemCubit>().slicSOLineItemsById(
              LineItemCubit.get(context).selectedSysId ?? '');
        } else {
          selectedRowIndex = null; // Deselect if needed
        }
      });
    });
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: PaginatedDataTable(
        columns: [
          DataColumn(label: Text('hEADSYSID'.toUpperCase())),
          DataColumn(label: Text('dELLOCN'.toUpperCase())),
          DataColumn(label: Text('sOCUSTNAME'.toUpperCase())),
          DataColumn(label: Text('sOLOCNCODE'.toUpperCase())),
          DataColumn(label: Text('sONUMBER'.toUpperCase())),
          DataColumn(label: Text('sTATUS'.toUpperCase())),
        ],
        source: dataSource,
        columnSpacing: 20,
        horizontalMargin: 10,
        rowsPerPage: 3,
        showCheckboxColumn: true,
      ),
    );
  }

  Widget _buildLineItemsTable(List<SoLineItemModel> data) {
    LineItemSource dataSource = LineItemSource(data, (SoLineItemModel item) {
      // Navigation.push(context, UpdateSoLineItemScreen(lineItem: item));
    });
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: PaginatedDataTable(
        columns: const [
          DataColumn(label: Text('gRADE')),
          DataColumn(label: Text('iTEMSYSID')),
          DataColumn(label: Text('iTEMNAME')),
          DataColumn(label: Text('iTEMCODE')),
          DataColumn(label: Text('iNVQTY')),
          // DataColumn(label: Text('rECEIVEDQTY')),
          DataColumn(label: Text('uOM')),
        ],
        source: dataSource,
        columnSpacing: 20,
        horizontalMargin: 10,
        rowsPerPage: 3,
        showCheckboxColumn: true,
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  final List<SalesOrderModel> _data;
  final int? _selectedRowIndex; // Single selected row index
  final Function(int index, bool selected) _onSelectRow;

  _DataSource(this._data, this._selectedRowIndex, this._onSelectRow);

  @override
  DataRow getRow(int index) {
    final SalesOrderModel data = _data[index];
    return DataRow.byIndex(
      index: index,
      selected: _selectedRowIndex == index,
      onSelectChanged: (selected) {
        if (selected != null) {
          _onSelectRow(index, selected);
        }
      },
      color: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return ColorPallete.primary.withOpacity(0.3);
          }
          if (index.isEven) {
            return ColorPallete.background;
          }
          return ColorPallete.background;
        },
      ),
      cells: <DataCell>[
        DataCell(Text(data.listOfSO?.hEADSYSID.toString() ?? '')),
        DataCell(Text(data.listOfSO?.dELLOCN ?? '')),
        DataCell(Text(data.listOfSO?.sOCUSTNAME ?? '')),
        DataCell(Text(data.listOfSO?.sOLOCNCODE ?? '')),
        DataCell(Text(data.listOfSO?.sONUMBER ?? '')),
        DataCell(Text(data.listOfSO?.sTATUS ?? '')),
      ],
    );
  }

  @override
  int get rowCount => _data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => _selectedRowIndex == null ? 0 : 1;
}

class LineItemSource extends DataTableSource {
  final List<SoLineItemModel> _data;
  final void Function(SoLineItemModel) onDoubleTap;

  LineItemSource(this._data, this.onDoubleTap);

  @override
  DataRow getRow(int index) {
    final SoLineItemModel data = _data[index];
    return DataRow.byIndex(
      index: index,
      color: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return ColorPallete.primary.withOpacity(0.3);
          }
          if (index.isEven) {
            return ColorPallete.background;
          }
          return ColorPallete.background;
        },
      ),
      cells: <DataCell>[
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfSOItem?.gRADE ?? ''),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfSOItem!.iTEMSYSID.toString()),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfSOItem!.iTEMNAME.toString()),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfSOItem!.iTEMCODE.toString()),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfSOItem!.iNVQTY.toString()),
          ),
        ),
        // DataCell(
        //   GestureDetector(
        //     onDoubleTap: () => onDoubleTap(data),
        //     child: Text(data.listOfSOItem!.rECEIVEDQTY.toString()),
        //   ),
        // ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfSOItem!.uOM.toString()),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => _data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
