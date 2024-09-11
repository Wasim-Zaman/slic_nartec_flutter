import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/foreign_po/foreign_po_cubit.dart';
import 'package:slic/cubits/home/home_cubit.dart';
import 'package:slic/cubits/line_item/line_item_cubit.dart';
import 'package:slic/cubits/sales_order/sales_order_cubit.dart';
import 'package:slic/models/sales_order_model.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/view/screens/sales_order/selected_so_screen.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/loading/loading_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SalesOrderScreen extends StatefulWidget {
  const SalesOrderScreen({super.key});

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  Set<int> selectedRowIndices = {};

  @override
  void initState() {
    super.initState();
    SalesOrderCubit.get(context)
        .getSlicSalesOrder("${HomeCubit.get(context).locationCode}");
    LineItemCubit.get(context).lineItems.clear();
    LineItemCubit.get(context).poLineItemsMap.clear();
    ForeignPoCubit.get(context).selectedPOList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Sales Order',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) =>
                    context.read<SalesOrderCubit>().updateSearchQuery(value),
              ),
            ),
            Expanded(
              child: Container(
                color: ColorPallete.background,
                child: BlocConsumer<SalesOrderCubit, SalesOrderState>(
                  listener: (context, state) {
                    if (state is SalesOrderSlicSOSuccess) {
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.success(
                            message: "Sales Orders Loaded"),
                      );
                    } else if (state is SalesOrderSlicSOError) {
                      showTopSnackBar(
                        Overlay.of(context),
                        CustomSnackBar.error(message: state.message),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is SalesOrderSlicSOLoading) {
                      return const LoadingWidget();
                    } else if (state is SalesOrderGetAllFilteredSuccess) {
                      return _buildDataTable(
                          SalesOrderCubit.get(context).filterSalesOrders);
                    }
                    return _buildDataTable(
                        SalesOrderCubit.get(context).salesOrders);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    text: "Proceed",
                    onPressed: () {
                      if (SalesOrderCubit.get(context)
                          .selectedSalesOrder
                          .isNotEmpty) {
                        Navigation.push(
                          context,
                          const SelectedSoScreen(),
                        );
                      } else {
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.info(
                            message:
                                "Select at least one row for farther process",
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable(List<SalesOrderModel> data) {
    _DataSource dataSource =
        _DataSource(data, selectedRowIndices, (index, selected) {
      setState(() {
        if (selected) {
          selectedRowIndices.add(index);
          SalesOrderCubit.get(context).selectedSalesOrder.add(data[index]);

          for (var index in selectedRowIndices) {
            SalesOrderCubit.get(context)
                .selectedSysId
                .add(data[index].listOfSO?.hEADSYSID);
          }
        } else {
          SalesOrderCubit.get(context).selectedSalesOrder.removeAt(index);
          selectedRowIndices.remove(index);
        }
      });
    });
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: ColorPallete.background,
      child: PaginatedDataTable(
        primary: true,
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
        rowsPerPage: 7,
        showCheckboxColumn: true,
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  final List<SalesOrderModel> _data;
  final Set<int> _selectedRowIndices;
  final Function(int index, bool selected) _onSelectRow;

  _DataSource(this._data, this._selectedRowIndices, this._onSelectRow);

  @override
  DataRow getRow(int index) {
    final SalesOrderModel data = _data[index];
    return DataRow.byIndex(
      index: index,
      selected: _selectedRowIndices.contains(index),
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
  int get selectedRowCount => _selectedRowIndices.length;
}
