import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/foreign_po/foreign_po_cubit.dart';
import 'package:slic/models/tblPOFPOMaster.dart';

class ForeignPoScreen extends StatefulWidget {
  const ForeignPoScreen({super.key});

  @override
  State<ForeignPoScreen> createState() => _ForeignPoScreenState();
}

class _ForeignPoScreenState extends State<ForeignPoScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ForeignPoCubit>().getAllForeignPo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foreign PO'),
      ),
      body: Column(
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
              // onChanged: (value) =>
              //     context.read<ForeignPoCubit>().updateSearchQuery(value),
            ),
          ),
          Expanded(
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
                }
                return const Text('No data');
              },
            ),
          ),
          _buildTotalRow(context),
        ],
      ),
    );
  }

  Widget _buildDataTable(List<POFPOMaster> data) {
    _DataSource dataSource = _DataSource(data);
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
        showCheckboxColumn: false,
      ),
    );
  }

  Widget _buildTotalRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  final List<POFPOMaster> _data;

  _DataSource(this._data);

  @override
  DataRow getRow(int index) {
    final POFPOMaster data = _data[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(data.tblPOFPOMasterID.toString())),
        DataCell(Text(data.pONumber ?? '')),
        DataCell(Text(DateFormat('dd-MM-yyyy')
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
  int get selectedRowCount => 0;
}
