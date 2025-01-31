import 'package:slic/config/app_config.dart';
import 'package:slic/models/api_response.dart';
import 'package:slic/models/auth.dart';
import 'package:slic/models/company.dart';
import 'package:slic/models/company_location.dart';
import 'package:slic/models/customer_model.dart';
import 'package:slic/models/foreign_po.dart';
import 'package:slic/models/invoice_header_and_details_model.dart';
import 'package:slic/models/item_code.dart';
import 'package:slic/models/line_item.dart';
import 'package:slic/models/location.dart';
import 'package:slic/models/pos_invoice_model.dart';
import 'package:slic/models/sales_order.dart';
import 'package:slic/models/slic_line_item_model.dart';
import 'package:slic/models/slic_po_model.dart';
import 'package:slic/models/so_line_item_model.dart';
import 'package:slic/models/tblPOFPOMaster.dart';
import 'package:slic/models/trx_codes_model.dart';
import 'package:slic/services/http_service.dart';
import 'package:slic/utils/shared_storage.dart';

class ApiService {
  // * User Section ***
  static Future<ApiResponse> login(String email, password) async {
    const endpoint = "/users/v1/login";
    final response = await HttpService().request(
      endpoint,
      method: "POST",
      data: {"userLoginID": email, "userPassword": password},
    );

    // save the token locally
    if (response['success'] && response['data']['token'] != null) {
      await SharedStorage.setToken(response['data']['token'].toString());
    }
    return ApiResponse.fromJson(
      response,
      (data) => AuthModel.fromJson(response['data']),
    );
  }

  static Future<void> slicLogin() async {
    const endpoint = "/oneerpauth/api/login";
    final response = await HttpService.baseUrl(ApiConfig.slicDomain).request(
      endpoint,
      method: "POST",
      data: {
        "apiKey":
            "b4d21674cd474705f6caa07d618b389ddc7ebc25a77a0dc591f49e9176beda01",
      },
      headers: {
        'Content-Type': 'application/json',
        'X-tenanttype': 'live',
      },
    );

    await SharedStorage.setSlicToken(response['token'].toString());
  }

  // * POFPOPMaster Section ***

  static Future<ApiResponse> getPaginatedforeignPO(int page, int limit) async {
    final endpoint = "/POFPOPMaster/v1/getforeignPO?page=$page&limit=$limit";
    final response = await HttpService().request(
      endpoint,
      method: "GET",
    );
    return ApiResponse.fromJson(
      response,
      (data) => ForeignPo.fromJson(response['data']),
    );
  }

  static Future<ApiResponse> getAllforeignPO() async {
    const endpoint = "/foreignPO/v1/foreignPo/all";
    final response = await HttpService().request(
      endpoint,
      method: "GET",
    );
    List<POFPOMaster> masterList = [];
    response['data'].forEach((data) {
      masterList.add(POFPOMaster.fromJson(data));
    });
    return ApiResponse.fromJson(
      response,
      (data) => masterList,
    );
  }

  static Future<List<SlicPOModel>> getPoList() async {
    const url = "/oneerpreport/api/getapi";
    final slicToken = SharedStorage.getSlicToken();
    final response = await HttpService.baseUrl(ApiConfig.slicDomain).request(
      url,
      data: {
        "filter": {},
        "M_COMP_CODE": "SLIC",
        "M_USER_ID": "SYSADMIN",
        "APICODE": "ListOfPO",
        "M_LANG_CODE": "ENG"
      },
      headers: {
        "Authorization": "Bearer $slicToken",
        'Content-Type': 'application/json',
      },
      method: "POST",
    );

    List<SlicPOModel> poList = [];

    response.forEach((data) {
      poList.add(SlicPOModel.fromJson(data));
    });
    return poList;
  }

  static Future<List<PoLineItemModel>> getPoLineItems(sysId) async {
    const url = "/oneerpreport/api/getapi";
    final slicToken = SharedStorage.getSlicToken();
    final response = await HttpService.baseUrl(ApiConfig.slicDomain).request(
      url,
      data: {
        "filter": {"P_PI_PH_SYS_ID": sysId},
        "M_COMP_CODE": "SLIC",
        "M_USER_ID": "SYSADMIN",
        "APICODE": "ListOfPOItem",
        "M_LANG_CODE": "ENG"
      },
      headers: {
        "Authorization": "Bearer $slicToken",
        'Content-Type': 'application/json',
      },
      method: "POST",
    );

    List<PoLineItemModel> lineItems = [];

    response.forEach((data) {
      lineItems.add(PoLineItemModel.fromJson(data));
    });
    return lineItems;
  }

  static Future<List<SoLineItemModel>> getSoLineItems(sysId) async {
    const url = "/oneerpreport/api/getapi";
    final slicToken = SharedStorage.getSlicToken();
    final response = await HttpService.baseUrl(ApiConfig.slicDomain).request(
      url,
      data: {
        "filter": {"P_SOI_SOH_SYS_ID": sysId},
        "M_COMP_CODE": "SLIC",
        "M_USER_ID": "SYSADMIN",
        "APICODE": "ListOfSOItem",
        "M_LANG_CODE": "ENG"
      },
      headers: {
        "Authorization": "Bearer $slicToken",
        'Content-Type': 'application/json',
      },
      method: "POST",
    );

    List<SoLineItemModel> lineItems = [];

    response.forEach((data) {
      lineItems.add(SoLineItemModel.fromJson(data));
    });
    return lineItems;
  }

  // * Location Company Section ***
  static Future<ApiResponse> getCompaniesLocations() async {
    const endpoint = "/locationsCompanies/v1/all";
    final response = await HttpService().request(
      endpoint,
      method: "GET",
    );

    return ApiResponse.fromJson(
      response,
      (data) => CompanyLocation.fromJson(response['data']),
    );
  }

  static Future<List<CompanyModel>> getSlicCompanies() async {
    const endpoint = "/oneerpreport/api/getapi";
    final slicToken = SharedStorage.getSlicToken();
    final response = await HttpService.baseUrl(ApiConfig.slicDomain).request(
      endpoint,
      method: "POST",
      data: {
        "filter": {},
        "M_COMP_CODE": "001",
        "M_USER_ID": "SYSADMIN",
        "APICODE": "CompanyMaster",
        "M_LANG_CODE": "ENG"
      },
      headers: {
        "Authorization": "Bearer $slicToken",
        'Content-Type': 'application/json',
      },
    );

    List<CompanyModel> companies = [];
    response.forEach((data) {
      companies.add(CompanyModel.fromJson(data));
    });
    return companies;
  }

  static Future<List<LocationModel>> getSlicLocations() async {
    const endpoint = "/oneerpreport/api/getapi";
    final slicToken = SharedStorage.getSlicToken();
    final response = await HttpService.baseUrl(ApiConfig.slicDomain).request(
      endpoint,
      method: "POST",
      data: {
        "filter": {},
        "M_COMP_CODE": "001",
        "M_USER_ID": "SYSADMIN",
        "APICODE": "LocationMaster",
        "M_LANG_CODE": "ENG"
      },
      headers: {
        "Authorization": "Bearer $slicToken",
        'Content-Type': 'application/json',
      },
    );

    List<LocationModel> locations = [];
    response.forEach((data) {
      locations.add(LocationModel.fromJson(data));
    });
    return locations;
  }

  // * Sales Order Section ***
  static Future<ApiResponse> getSalesOrder() async {
    const endpoint = "/salesOrders/v1/all";
    final response = await HttpService().request(
      endpoint,
      method: "GET",
    );
    final List<SalesOrder> salesOrders = [];
    response['data'].forEach((data) {
      salesOrders.add(SalesOrder.fromJson(data));
    });
    return ApiResponse.fromJson(
      response,
      (data) => salesOrders,
    );
  }

  // * Line Items Section ***
  static Future<ApiResponse> getLineItems(headSysId) async {
    final endpoint = "/lineItems/v1/$headSysId";
    final response = await HttpService().request(
      endpoint,
      method: "GET",
    );

    List<LineItem> items = [];
    response['data'].forEach((data) {
      items.add(LineItem.fromJson(data));
    });
    return ApiResponse.fromJson(response, (data) => items);
  }

  static Future<ApiResponse> getLineItemsBySysIds(headSysIds) async {
    const endpoint = "/lineItems/v1/fetchByMultipleIds";
    final response = await HttpService().request(
      endpoint,
      method: "POST",
      data: {"headSysIds": headSysIds},
    );

    List<LineItem> items = [];
    response['data'].forEach((data) {
      items.add(LineItem.fromJson(data));
    });
    return ApiResponse.fromJson(response, (data) => items);
  }

  // * SLIC APIs Section ***
  static Future<dynamic> slicPostData(body) async {
    const endpoint = "/oneerpreport/api/postdata";
    final slicToken = SharedStorage.getSlicToken();

    final response = await HttpService.baseUrl(ApiConfig.slicDomain).request(
      endpoint,
      method: "POST",
      data: body,
      headers: <String, String>{
        "Authorization": "Bearer $slicToken",
        "Content-Type": "application/json",
        "Host": "slicuat05api.oneerpcloud.com",
      },
    );
    return response;
  }

  static Future<dynamic> slicGetData(var body) async {
    const endpoint = "/oneerpreport/api/getapi";
    final slicToken = SharedStorage.getSlicToken();
    final response = await HttpService.baseUrl(ApiConfig.slicDomain).request(
      endpoint,
      method: "POST",
      data: body,
      headers: {
        "Authorization": "Bearer $slicToken",
        "Content-Type": "application/json",
        "Host": "slicuat05api.oneerpcloud.com",
      },
    );
    return response;
  }

  // * Item Codes Section ***
  static Future<ApiResponse> getItemCodesByGtin(String gtin) async {
    final endpoint = "/itemCodes/v2/searchByGTIN?GTIN=$gtin";
    final response = await HttpService().request(
      endpoint,
      method: "GET",
    );

    return ApiResponse.fromJson(
      response,
      (data) => ItemCode.fromJson(response['data']),
    );
  }

  static Future<ApiResponse> getItemCodesByItemCode(String itemCode) async {
    final endpoint = "/itemCodes/v1/findByItemCode?itemCode=$itemCode";
    final response = await HttpService().request(
      endpoint,
      method: "GET",
    );

    return ApiResponse.fromJson(
      response,
      (data) => ItemCode.fromJson(response['data']),
    );
  }

  static Future<ApiResponse> getItemCodeByItemCode(String itemCode) async {
    final endpoint = "/itemCodes/v1/findByItemCode?itemCode=$itemCode";
    final response = await HttpService().request(
      endpoint,
      method: "GET",
    );

    return ApiResponse.fromJson(
      response,
      (data) => ItemCode.fromJson(response['data']),
    );
  }

  // * Transaction Code Section ***
  static Future<ApiResponse> getTrx(locationCode) async {
    final endpoint =
        "/transactions/v1/byLocationCode?locationCode=$locationCode";
    final response = await HttpService().request(
      endpoint,
      method: "GET",
    );

    List<TrxCodesModel> transactions = [];

    response['data'].forEach((data) {
      transactions.add(TrxCodesModel.fromJson(data));
    });

    return ApiResponse.fromJson(response, (data) => transactions);
  }

  // * POS-INVOICE SECTION ***
  static Future<ApiResponse> getPOSDetailsByInvoice(invoiceNO, trxCode) async {
    final endpoint =
        "/invoice/v1/invoice-details/?invoiceNo=$invoiceNO&transactionCode=$trxCode";
    final response = await HttpService().request(
      endpoint,
      method: "GET",
    );

    List<POSInvoiceModel> invoices = [];

    response['data'].forEach((data) {
      invoices.add(POSInvoiceModel.fromJson(data));
    });

    return ApiResponse.fromJson(response, (data) => invoices);
  }

  static Future<ApiResponse> getInvoiceHeaderDetails(invoiceNO) async {
    final endpoint = "/invoice/v1/headers-and-line-items?InvoiceNo=$invoiceNO";
    final response = await HttpService().request(
      endpoint,
      method: "GET",
    );

    return ApiResponse.fromJson(response,
        (data) => InvoiceHeaderAndDetailsModel.fromJson(response['data']));
  }

  static Future<ApiResponse> updateInvoiceTemp(
      itemSysID, itemCode, num? returnQty) async {
    const endpoint = "/invoice/v1/update-invoice-temp";
    final response = await HttpService().request(endpoint,
        method: "PUT",
        data: {
          "ItemSysID": itemSysID,
          "ItemCode": itemCode,
          "ReturnQty": returnQty
        });

    return ApiResponse.fromJson(response, (data) => null);
  }

  // * CUSTOMERS SECTION ***
  static Future<ApiResponse> getCustomers() async {
    const endpoint = "/customerNames/v1/all";
    final response = await HttpService().request(
      endpoint,
      method: "GET",
    );

    List<CustomerModel> customers = [];

    response['data'].forEach((data) {
      customers.add(CustomerModel.fromJson(data));
    });

    return ApiResponse.fromJson(response, (data) => customers);
  }
}
