import 'package:slic/models/api_response.dart';
import 'package:slic/models/auth.dart';
import 'package:slic/models/company.dart';
import 'package:slic/models/company_location.dart';
import 'package:slic/models/foreign_po.dart';
import 'package:slic/models/line_item.dart';
import 'package:slic/models/location.dart';
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

  static Future<void> slicLogin() async {
    const endpoint = "/oneerpauth/api/login";
    final response =
        await HttpService.baseUrl("http://slicuat05api.oneerpcloud.com")
            .request(endpoint, method: "POST", data: {
      "apiKey":
          "b4d21674cd474705f6caa07d618b389ddc7ebc25a77a0dc591f49e9176beda01",
    }, headers: {
      'Content-Type': 'application/json',
      'X-tenanttype': 'live'
    });

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
    final response =
        await HttpService.baseUrl("https://slicuat05api.oneerpcloud.com")
            .request(endpoint, method: "POST", data: {
      "filter": {},
      "M_COMP_CODE": "001",
      "M_USER_ID": "SYSADMIN",
      "APICODE": "LocationMaster",
      "M_LANG_CODE": "ENG"
    }, headers: {
      "Authorization": "Bearer $slicToken",
      'Content-Type': 'application/json',
    });

    List<CompanyModel> companies = [];
    response.forEach((data) {
      companies.add(CompanyModel.fromJson(data));
    });
    return companies;
  }

  static Future<List<LocationModel>> getSlicLocations() async {
    const endpoint = "/oneerpreport/api/getapi";
    final slicToken = SharedStorage.getSlicToken();
    final response =
        await HttpService.baseUrl("https://slicuat05api.oneerpcloud.com")
            .request(endpoint, method: "POST", data: {
      "filter": {},
      "M_COMP_CODE": "001",
      "M_USER_ID": "SYSADMIN",
      "APICODE": "LocationMaster",
      "M_LANG_CODE": "ENG"
    }, headers: {
      "Authorization": "Bearer $slicToken",
      'Content-Type': 'application/json',
    });

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
}
