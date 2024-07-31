import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/foreign_po/foreign_po_cubit.dart';
import 'package:slic/cubits/line_item/line_item_cubit.dart';
import 'package:slic/models/slic_po_model.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/view/screens/foreign_po/selected_po_screen.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/loading/loading_widget.dart';

class ForeignPoScreen extends StatefulWidget {
  const ForeignPoScreen({super.key});

  @override
  State<ForeignPoScreen> createState() => _ForeignPoScreenState();
}

class _ForeignPoScreenState extends State<ForeignPoScreen> {
  final TextEditingController _searchController = TextEditingController();
  Set<int> selectedRowIndices = {};

  @override
  void initState() {
    super.initState();
    context.read<ForeignPoCubit>().getSlicPoList();
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
                    if (state is ForiegnPoGetSlicPOListLoading) {
                      return const LoadingWidget();
                    } else if (state is ForeignPoGetSlicPOListSuccess ||
                        state is ForeignPoSlicPoSearchSuccess) {
                      final data = state is ForeignPoGetSlicPOListSuccess
                          ? state.data
                          : (state as ForeignPoSlicPoSearchSuccess).data;
                      return _buildDataTable(data);
                    }
                    return _buildDataTable(
                        ForeignPoCubit.get(context).slicPOList);
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: "Proceed",
                      onPressed: () {
                        // save selected tables rows in the following list
                        // LineItemCubit.get(context).getLineItemsBySysIds(
                        //   ForeignPoCubit.get(context).selectedSysIds,
                        // );
                        if (ForeignPoCubit.get(context)
                            .selectedPOList
                            .isNotEmpty) {
                          Navigation.push(context, const SelectedPoScreen());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable(List<SlicPOModel> data) {
    _DataSource dataSource =
        _DataSource(data, selectedRowIndices, (index, selected) {
      setState(() {
        if (selected) {
          selectedRowIndices.add(index);
          ForeignPoCubit.get(context).selectedPOList.add(data[index]);

          for (var index in selectedRowIndices) {
            ForeignPoCubit.get(context)
                .selectedSysIds
                .add(data[index].listOfPO?.hEADSYSID);
          }
        } else {
          ForeignPoCubit.get(context).selectedPOList.removeAt(index);
          selectedRowIndices.remove(index);
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
        rowsPerPage: 5,
        showCheckboxColumn: true,
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  final List<SlicPOModel> _data;
  final Set<int> _selectedRowIndices;
  final Function(int index, bool selected) _onSelectRow;

  _DataSource(this._data, this._selectedRowIndices, this._onSelectRow);

  @override
  DataRow getRow(int index) {
    final SlicPOModel data = _data[index];
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
  int get selectedRowCount => _selectedRowIndices.length;
}
