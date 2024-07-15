import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/sales_order/sales_order_cubit.dart';
import 'package:slic/models/sales_order.dart';

class SalesOrderScreen extends StatefulWidget {
  const SalesOrderScreen({super.key});

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SalesOrderCubit>().getAllSalesOrder();
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
                height: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    160,
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
              // _buildTotalRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable(List<SalesOrder> data) {
    _SalesOrderDataSource dataSource = _SalesOrderDataSource(data);
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
            child: const Text('Finalize Orders'),
          ),
        ],
      ),
    );
  }
}

class _SalesOrderDataSource extends DataTableSource {
  final List<SalesOrder> _data;

  _SalesOrderDataSource(this._data);

  @override
  DataRow getRow(int index) {
    final SalesOrder data = _data[index];
    return DataRow.byIndex(
      index: index,
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
  int get selectedRowCount => 0;
}
