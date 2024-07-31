import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/foreign_po/foreign_po_cubit.dart';
import 'package:slic/cubits/line_item/line_item_cubit.dart';
import 'package:slic/models/slic_line_item_model.dart';
import 'package:slic/models/slic_po_model.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/view/screens/foreign_po/update_line_item_screen.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/loading/loading_widget.dart';

class SelectedPoScreen extends StatefulWidget {
  const SelectedPoScreen({super.key});

  @override
  State<SelectedPoScreen> createState() => _SelectedPoScreenState();
}

class _SelectedPoScreenState extends State<SelectedPoScreen> {
  int? selectedRowIndex;

  @override
  void initState() {
    super.initState();
    LineItemCubit.get(context).slicLineItems = [];
    LineItemCubit.get(context).slicLineItemsMap = {};
    LineItemCubit.get(context).selectedSysId = null;
    LineItemCubit.get(context).counter.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foreign PO'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              SizedBox(
                child: _buildPOListTable(
                  ForeignPoCubit.get(context).selectedPOList,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                child: BlocConsumer<LineItemCubit, LineItemState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is LineItemGetBySysIdLoading) {
                      return const LoadingWidget();
                    }
                    return _buildLineItemsTable(
                      LineItemCubit.get(context).slicLineItems,
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
                              child: Text("Total"),
                            ),
                            AppButton(text: "Submit GRN"),
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
                              child: Text("Total"),
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

  Widget _buildPOListTable(List<SlicPOModel> data) {
    _DataSource dataSource =
        _DataSource(data, selectedRowIndex, (index, selected) {
      setState(() {
        if (selected) {
          selectedRowIndex = index;
          LineItemCubit.get(context).selectedSysId =
              data[index].listOfPO!.hEADSYSID;
          context.read<LineItemCubit>().slicLineItemsById(
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
        columns: const [
          DataColumn(label: Text('hEADSYSID')),
          DataColumn(label: Text('dOCNO')),
          DataColumn(label: Text('dOCDT')),
          DataColumn(label: Text('sTATUS')),
          DataColumn(label: Text('sUPPNAME')),
        ],
        source: dataSource,
        columnSpacing: 20,
        horizontalMargin: 10,
        rowsPerPage: 3,
        showCheckboxColumn: true,
      ),
    );
  }

  Widget _buildLineItemsTable(List<SlicLineItemModel> data) {
    LineItemSource dataSource = LineItemSource(data, (SlicLineItemModel item) {
      Navigation.push(context, UpdateLineItemScreen(lineItem: item));
    });
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: PaginatedDataTable(
        header: const Text('Line Items'),
        headingRowColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return ColorPallete.primary.withOpacity(0.3);
            }
            return ColorPallete.primary.withOpacity(0.1);
          },
        ),
        columns: const [
          DataColumn(label: Text('gRADE')),
          DataColumn(label: Text('iTEMSYSID')),
          DataColumn(label: Text('iTEMNAME')),
          DataColumn(label: Text('iTEMCODE')),
          DataColumn(label: Text('pOQTY')),
          DataColumn(label: Text('rECEIVEDQTY')),
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
  final List<SlicPOModel> _data;
  final int? _selectedRowIndex; // Single selected row index
  final Function(int index, bool selected) _onSelectRow;

  _DataSource(this._data, this._selectedRowIndex, this._onSelectRow);

  @override
  DataRow getRow(int index) {
    final SlicPOModel data = _data[index];
    return DataRow.byIndex(
      index: index,
      selected: _selectedRowIndex == index,
      onSelectChanged: (selected) {
        if (selected != null) {
          _onSelectRow(index, selected);
        }
      },
      cells: <DataCell>[
        DataCell(Text(data.listOfPO?.hEADSYSID ?? '')),
        DataCell(Text(data.listOfPO?.dOCNO ?? '')),
        DataCell(Text(data.listOfPO?.dOCDT ?? '')),
        DataCell(Text(data.listOfPO?.sTATUS ?? '')),
        DataCell(Text(data.listOfPO?.sUPPNAME ?? '')),
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
  final List<SlicLineItemModel> _data;
  final void Function(SlicLineItemModel) onDoubleTap;

  LineItemSource(this._data, this.onDoubleTap);

  @override
  DataRow getRow(int index) {
    final SlicLineItemModel data = _data[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfPOItem?.gRADE ?? ''),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfPOItem!.iTEMSYSID.toString()),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfPOItem!.iTEMNAME.toString()),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfPOItem!.iTEMCODE.toString()),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfPOItem!.pOQTY.toString()),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfPOItem!.rECEIVEDQTY.toString()),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfPOItem!.uOM.toString()),
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
