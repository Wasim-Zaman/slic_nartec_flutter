import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/line_item/line_item_cubit.dart';
import 'package:slic/cubits/sales_order/sales_order_cubit.dart';
import 'package:slic/models/line_item.dart';
import 'package:slic/models/sales_order.dart';

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
    context.read<SalesOrderCubit>().getAllSalesOrder();
    LineItemCubit.get(context).lineItems = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Orders'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Sales Orders',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) =>
                      context.read<SalesOrderCubit>().updateSearchQuery(value),
                ),
              ),
              SizedBox(
                child: BlocConsumer<SalesOrderCubit, SalesOrderState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is SalesOrderGetAllLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SalesOrderGetAllSuccess) {
                      return _buildDataTable(
                          SalesOrderCubit.get(context).filteredSalesOrders);
                    }
                    return const Text('No data available.');
                  },
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                child: BlocConsumer<LineItemCubit, LineItemState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is LineItemGetBySysIdsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is LineItemGetBySysIdsSuccess) {
                      return _buildLineItemsTable(
                          LineItemCubit.get(context).lineItems);
                    } else if (state is LineItemGetBySysIdsError) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorPallete.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(state.message),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable(List<SalesOrder> data) {
    _SalesOrderDataSource dataSource =
        _SalesOrderDataSource(data, selectedRowIndices, (index, selected) {
      setState(() {
        if (selected) {
          selectedRowIndices.add(index);

          final selectedSysIds = [];

          for (var index in selectedRowIndices) {
            selectedSysIds.add(data[index].hEADSYSID);
          }
          LineItemCubit.get(context).getLineItemsBySysIds(selectedSysIds);
        } else {
          selectedRowIndices.remove(index);
        }
      });
    });
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: PaginatedDataTable(
        header: const Text('Sales Order Data'),
        headingRowColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return ColorPallete.primary.withOpacity(0.3);
            }
            return ColorPallete.primary.withOpacity(0.1);
          },
        ),
        arrowHeadColor: ColorPallete.secondary,
        actions: [
          IconButton(
            onPressed: () => context.read<SalesOrderCubit>().getAllSalesOrder(),
            icon: const Icon(Icons.refresh),
          ),
        ],
        columns: const [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('Order Number')),
          DataColumn(label: Text('Customer Name')),
          DataColumn(label: Text('Location Code')),
          DataColumn(label: Text('Delivery Location')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Head SYS ID')),
        ],
        source: dataSource,
        columnSpacing: 20,
        horizontalMargin: 10,
        rowsPerPage: 5,
        showCheckboxColumn: true,
      ),
    );
  }

  Widget _buildLineItemsTable(List<LineItem> data) {
    LineItemSource dataSource = LineItemSource(data);
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
          DataColumn(label: Text('Head Sys Id')),
          DataColumn(label: Text('Item Code')),
          DataColumn(label: Text('Item Name')),
          DataColumn(label: Text('Grade')),
          DataColumn(label: Text('UOM')),
          DataColumn(label: Text('PO_QTY')),
          DataColumn(label: Text('Received_QTY')),
          DataColumn(label: Text('Item Sys Id')),
        ],
        source: dataSource,
        columnSpacing: 20,
        horizontalMargin: 10,
        rowsPerPage: 5,
        showCheckboxColumn: false,
      ),
    );
  }
}

class _SalesOrderDataSource extends DataTableSource {
  final List<SalesOrder> _data;
  final Set<int> _selectedRowIndices;
  final Function(int index, bool selected) _onSelectRow;

  _SalesOrderDataSource(
      this._data, this._selectedRowIndices, this._onSelectRow);

  @override
  DataRow getRow(int index) {
    final SalesOrder data = _data[index];
    return DataRow.byIndex(
      index: index,
      selected: _selectedRowIndices.contains(index),
      onSelectChanged: (selected) {
        if (selected != null) {
          _onSelectRow(index, selected);
        }
      },
      cells: <DataCell>[
        DataCell(Text(index.toString())),
        DataCell(Text(data.sONUMBER ?? '')),
        DataCell(Text(data.sOCUSTNAME ?? '')),
        DataCell(Text(data.sOLOCNCODE ?? '')),
        DataCell(Text(data.dELLOCN ?? '')),
        DataCell(Text(data.sTATUS ?? '')),
        DataCell(Text(data.hEADSYSID.toString())),
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

class LineItemSource extends DataTableSource {
  final List<LineItem> _data;

  LineItemSource(this._data);

  @override
  DataRow getRow(int index) {
    final LineItem data = _data[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(data.hEADSYSID.toString())),
        DataCell(Text(data.iTEMCODE ?? '')),
        DataCell(Text(data.iTEMNAME ?? '')),
        DataCell(Text(data.gRADE ?? '')),
        DataCell(Text(data.uOM ?? '')),
        DataCell(Text(data.pOQTY.toString())),
        DataCell(Text(data.rECEIVEDQTY ?? '')),
        DataCell(Text(data.iTEMSYSID.toString())),
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
