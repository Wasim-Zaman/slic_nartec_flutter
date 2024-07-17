import 'package:slic/models/api_response.dart';
import 'package:slic/models/auth.dart';
import 'package:slic/models/company_location.dart';
import 'package:slic/models/foreign_po.dart';
import 'package:slic/models/line_item.dart';
import 'package:slic/models/sales_order.dart';
import 'package:slic/models/tblPOFPOMaster.dart';
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
    return ApiResponse.fromJson(
      response,
      (data) => items,
    );
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
    return ApiResponse.fromJson(
      response,
          (data) => items,
    );
  }

}
