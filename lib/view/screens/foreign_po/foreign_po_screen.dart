import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/foreign_po/foreign_po_cubit.dart';
import 'package:slic/cubits/line_item/line_item_cubit.dart';
import 'package:slic/models/line_item.dart';
import 'package:slic/models/tblPOFPOMaster.dart';
import 'package:slic/utils/snackbar.dart';

class ForeignPoScreen extends StatefulWidget {
  const ForeignPoScreen({super.key});

  @override
  State<ForeignPoScreen> createState() => _ForeignPoScreenState();
}

class _ForeignPoScreenState extends State<ForeignPoScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedRowIndex;

  @override
  void initState() {
    super.initState();
    context.read<ForeignPoCubit>().getAllForeignPo();
    LineItemCubit.get(context).lineItems = [];
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Foreign PO',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) =>
                      context.read<ForeignPoCubit>().updateSearchQuery(value),
                ),
              ),
              SizedBox(
                child: BlocConsumer<ForeignPoCubit, ForeignPoState>(
                  listener: (context, state) {
                    if (state is ForeignPoGetSuccess) {
                      context.read<ForeignPoCubit>().models = state.res.data;
                    }
                  },
                  builder: (context, state) {
                    if (state is ForeignPoGetLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ForeignPoGetSuccess) {
                      return _buildDataTable(state.res.data);
                    } else if (state is ForeignPoSearchSuccess) {
                      return _buildDataTable(state.data);
                    }
                    return const Text('No data');
                  },
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                child: BlocConsumer<LineItemCubit, LineItemState>(
                  listener: (context, state) {
                    if (state is LineItemGetBySysIdError) {
                      CustomSnackbar.show(
                        context: context,
                        message: state.message,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LineItemGetBySysIdLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is LineItemGetBySysIdSuccess) {
                      return _buildLineItemsTable(
                          LineItemCubit.get(context).lineItems);
                    }
                    return _buildLineItemsTable(
                        LineItemCubit.get(context).lineItems);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable(List<POFPOMaster> data) {
    _DataSource dataSource = _DataSource(data, _selectedRowIndex, (index) {
      setState(() {
        _selectedRowIndex = index;
        LineItemCubit.get(context)
            .slicLineItemsById(data[index].headSYSID ?? '');
      });
    });
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: PaginatedDataTable(
        header: const Text('Foreign PO Data'),
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
            onPressed: () => context.read<ForeignPoCubit>().getAllForeignPo(),
            icon: const Icon(Icons.refresh),
          ),
        ],
        columns: const [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('PO Number')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Supplier Name')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Head SYS ID')),
          DataColumn(label: Text('Created At')),
          DataColumn(label: Text('Updated At')),
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
          // DataColumn(label: Text('Created At')),
          // DataColumn(label: Text('Updated At')),
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

class _DataSource extends DataTableSource {
  final List<POFPOMaster> _data;
  final int? _selectedRowIndex;
  final Function(int index) _onSelectRow;

  _DataSource(this._data, this._selectedRowIndex, this._onSelectRow);

  @override
  DataRow getRow(int index) {
    final POFPOMaster data = _data[index];
    return DataRow.byIndex(
      index: index,
      selected: _selectedRowIndex == index,
      onSelectChanged: (selected) {
        if (selected != null && selected) {
          _onSelectRow(index);
        }
      },
      cells: <DataCell>[
        DataCell(Text(data.tblPOFPOMasterID.toString())),
        DataCell(Text(data.pONumber ?? '')),
        DataCell(DateTime.tryParse(data.pODate.toString()) == null
            ? Text(data.pODate.toString())
            : Text(DateFormat('dd-MM-yyyy')
                .format(DateTime.parse(data.pODate.toString())))),
        DataCell(Text(data.supplierName ?? '')),
        DataCell(Text(data.pOStatus ?? '')),
        DataCell(Text(data.headSYSID ?? '')),
        DataCell(Text(data.createdAt != null
            ? DateFormat('dd-MM-yyyy')
                .format(DateTime.parse(data.createdAt.toString()))
            : '')),
        DataCell(Text(data.updatedAt != null
            ? DateFormat('dd-MM-yyyy')
                .format(DateTime.parse(data.updatedAt.toString()))
            : '')),
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
