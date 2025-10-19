
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/core/models/loan_auth_model.dart';
import 'package:flutterapppart2hr/core/models/loan_request_model.dart';
import 'package:flutterapppart2hr/core/models/loan_type_model.dart';
import 'package:flutterapppart2hr/core/models/resignation_auth_model.dart';
import 'package:flutterapppart2hr/core/models/resignation_request_model.dart';
import 'package:flutterapppart2hr/core/models/user_transaction_info_model.dart';
import 'package:flutterapppart2hr/core/models/vacation_auth_model.dart';
import 'package:flutterapppart2hr/core/models/vacation_request_model.dart';
import 'package:flutterapppart2hr/features/loans/models/my_loan_request_model.dart';
import 'package:flutterapppart2hr/features/resignations/models/my_resignation_request_model.dart';
import 'package:flutterapppart2hr/features/vacations/models/my_vacation_request_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../api/api_constants.dart';
import '../services/data_fetch_service.dart';

// ---== نماذج الموافقات ==---

// ---== نماذج طلباتي ==---

class HrProvider with ChangeNotifier {
  final DataFetchService _dataFetchService = DataFetchService();
  bool _isLoading = false;
  String? _error;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool _isSubmittingAction = false;
  String? _actionError;
  bool get isSubmittingAction => _isSubmittingAction;
  String? get actionError => _actionError;

  // ---===< 1. حالة الموافقات >===---
  List<VacationRequestItem> _vacationRequests = [];
  VacationRequestItem? _selectedVacationRequest;
  VacationAuthResponse? _vacationAuthDetails;
  List<VacationRequestItem> get vacationRequests => _vacationRequests;
  VacationRequestItem? get selectedVacationRequest => _selectedVacationRequest;
  VacationAuthResponse? get vacationAuthDetails => _vacationAuthDetails;

  List<LoanRequestItem> _loanRequests = [];
  LoanRequestItem? _selectedLoanRequest;
  LoanAuthResponse? _loanAuthDetails;
  List<LoanTypeItem> _loanTypes = [];
  List<LoanRequestItem> get loanRequests => _loanRequests;
  LoanRequestItem? get selectedLoanRequest => _selectedLoanRequest;
  LoanAuthResponse? get loanAuthDetails => _loanAuthDetails;
  List<LoanTypeItem> get loanTypes => _loanTypes;

  List<ResignationRequestItem> _resignationRequests = [];
  ResignationRequestItem? _selectedResignationRequest;
  ResignationAuthResponse? _resignationAuthDetails;
  List<ResignationRequestItem> get resignationRequests => _resignationRequests;
  ResignationRequestItem? get selectedResignationRequest => _selectedResignationRequest;
  ResignationAuthResponse? get resignationAuthDetails => _resignationAuthDetails;

  // ---===< 2. حالة "طلباتي" >===---
  List<MyVacationRequestItem> _myVacationRequests = [];
  MyVacationRequestItem? _selectedMyVacationRequest;
  VacationAuthResponse? _myVacationAuthDetails;
  List<MyVacationRequestItem> get myVacationRequests => _myVacationRequests;
  MyVacationRequestItem? get selectedMyVacationRequest => _selectedMyVacationRequest;
  VacationAuthResponse? get myVacationAuthDetails => _myVacationAuthDetails;

  List<MyLoanRequestItem> _myLoanRequests = [];
  MyLoanRequestItem? _selectedMyLoanRequest;
  LoanAuthResponse? _myLoanAuthDetails;
  List<MyLoanRequestItem> get myLoanRequests => _myLoanRequests;
  MyLoanRequestItem? get selectedMyLoanRequest => _selectedMyLoanRequest;
  LoanAuthResponse? get myLoanAuthDetails => _myLoanAuthDetails;

  List<MyResignationRequestItem> _myResignationRequests = [];
  MyResignationRequestItem? _selectedMyResignationRequest;
  ResignationAuthResponse? _myResignationAuthDetails;
  List<MyResignationRequestItem> get myResignationRequests => _myResignationRequests;
  MyResignationRequestItem? get selectedMyResignationRequest => _selectedMyResignationRequest;
  ResignationAuthResponse? get myResignationAuthDetails => _myResignationAuthDetails;

  // --== حالة إنشاء طلب جديد ==--
  bool _isCreatingRequest = false;
  bool get isCreatingRequest => _isCreatingRequest;

// ---===< دوال إنشاء الطلبات الجديدة (POST) >===---

  Future<bool> createNewVacationRequest({
    required int empCode,
    required int userCode,
    required int vacationType,
    required DateTime startDate,
    required DateTime endDate,
    required int period,
    required String notes,
    required int compEmpCode,
    re
  }) async {
    return _createRequest(
      requestType: 'vacation',
      empCode: empCode,
      usersCode: userCode,
      bodyBuilder: (nextSerial) => {
        "CompEmpCode": compEmpCode, "EmpCode": empCode, "TrnsType": vacationType,
        "StartDt": DateFormat('yyyy-MM-dd').format(startDate),
        "EndDt": DateFormat('yyyy-MM-dd').format(endDate),
        "Period": period, "TrnsDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "Notes": notes, "AgreeFlag": 0, "SerialPyv": nextSerial,
        "AltKey": "$empCode-$nextSerial","InsertUser":userCode
      },
      endpoint: ApiConstants.createVacationRequestEndpoint,
    );
  }

  Future<bool> createNewLoanRequest({
    required int empCode,
    required int userCode,
    required int loanType,
    required DateTime startDate,
    required int installmentsCount,
    required double totalValue,
    required double installmentValue,
    required String notes,
    required int compEmpCode,
  }) async {
    return _createRequest(
      requestType: 'loan',
      usersCode: userCode,
      empCode: empCode,
      bodyBuilder: (nextSerial) => {
        "EmpCode": empCode, "CompEmpCode": compEmpCode, "LoanType": loanType,
        "LoanStartDate": DateFormat('yyyy-MM-dd').format(startDate),
        "LoanNos": installmentsCount, "LoanValuePys": totalValue, "LoanInstlPys": installmentValue,
        "ReqLoanDate": DateTime.now().toIso8601String(),
        "DescA": notes, "AuthFlag": null, "ReqSerial": nextSerial,
        "AltKey": "$empCode-$nextSerial","InsertUser":userCode
      },
      endpoint: ApiConstants.createLoanRequestEndpoint,
    );
  }

  Future<bool> createNewResignationRequest({
    required int empCode,
    required int usersCode,
    required DateTime endDate,
    required DateTime lastWorkDate,
    required String reasons,
    required int compEmpCode,
  }) async {
    return _createRequest(
      requestType: 'resignation',
      empCode: empCode,
      usersCode: usersCode,
      bodyBuilder: (nextSerial) => {
        "EmpCode": empCode, "CompEmpCode": compEmpCode,
        "LastWorkDt": DateFormat('yyyy-MM-dd').format(lastWorkDate),
        "EndDate": DateFormat('yyyy-MM-dd').format(endDate),
        "TrnsDate": DateTime.now().toIso8601String(),
        "EndReasons": reasons, "AproveFlag": 0, "Serial": nextSerial,
        "AltKey": "$empCode-$nextSerial","InsertUser":usersCode
      },
      endpoint: ApiConstants.createResignationRequestEndpoint,
    );
  }

  // ---===< دوال مساعدة ومنطق عام >===---

  Future<bool> _createRequest({
    required String requestType,
    required int usersCode,
    required int empCode,

    required Map<String, dynamic> Function(int) bodyBuilder,
    required String endpoint,
  }) async {
    _isCreatingRequest = true;
    _error = null;
    notifyListeners();

    try {
      final nextSerial = await _fetchNextSerial(usersCode, requestType);
      final requestBody = bodyBuilder(nextSerial);

      debugPrint("--- Creating New Request ($requestType) ---");
      debugPrint("Endpoint: $endpoint");
      debugPrint("Body: ${json.encode(requestBody)}");

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}$endpoint"),
        headers: {"Content-Type": "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) { // 201 Created
        return true;
      } else {
        throw _handleApiError('createRequest ($requestType)', response);
      }
    } catch (e) {
      _error = e.toString().replaceFirst("Exception: ", "");
      debugPrint("Error in _createRequest: $_error");
      return false;
    } finally {
      _isCreatingRequest = false;
      notifyListeners();
    }
  }

  Future<int> _fetchNextSerial(int userCode, String type) async {

    final url = "${ApiConstants.baseUrl}${ApiConstants.userTransactionsInfoEndpoint}?q=UsersCode=$userCode";
    print('URL is $url');
    final data = await _dataFetchService.fetchDataFromUrl(url);
    if (data == null || data['items'] == null || (data['items'] as List).isEmpty) {
      throw Exception("لم يتم العثور على معلومات الأرقام التسلسلية للمستخدم.");
    }

    final info = UserTransactionInfoItem.fromJson(data['items'][0]);
    int? lastSerial;
    switch (type) {
      case 'vacation': lastSerial = info.lastVcncSeq; break;
      case 'loan': lastSerial = info.lastLoanSeq; break;
      case 'resignation': lastSerial = info.lastEndsrvSeq; break;
      default: throw Exception("نوع طلب غير معروف لجلب الرقم التسلسلي.");
    }
    if (lastSerial == null) throw Exception("الرقم التسلسلي الأخير ($type) غير موجود.");
    return lastSerial + 1;
  }

  Exception _handleApiError(String functionName, http.Response response) {
    String responseBody = utf8.decode(response.bodyBytes);
    debugPrint("--- API Error in $functionName [${response.statusCode}] ---\n$responseBody");
    String serverErrorMsg = "فشل الإجراء.";
    try {
      final errorData = json.decode(responseBody);
      serverErrorMsg = errorData["title"] ?? errorData["detail"] ?? errorData["o:errorDetails"]?[0]?["detail"] ?? serverErrorMsg;
    } catch (e) {
      if(responseBody.isNotEmpty) serverErrorMsg = responseBody;
    }
    return Exception("خطأ ${response.statusCode}: $serverErrorMsg");
  }

  // دوال تحميل القوائم والاعتمادات ودوال المساعدة الأخرى تبقى كما هي من الردود السابقة
  // ...


  // ---===< 3. دوال تحميل البيانات >===---

  // -- دوال تحميل قوائم الموافقات --
  Future<void> loadVacationRequests(int usersCode) async {
    _isLoading = true; _error = null;
    notifyListeners();
    try {
      final url = "${ApiConstants.baseUrl}${ApiConstants.vacationRequestsEndpoint}?q=UsersCode=$usersCode";
      final data = await _dataFetchService.fetchDataFromUrl(url);
      _vacationRequests = VacationRequestList.fromJson(data!).items;
    } catch (e) {
      _error = "خطأ تحميل طلبات الإجازة: ${e.toString()}";
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  Future<void> loadLoanRequests(int usersCode) async {
    _isLoading = true; _error = null;
    notifyListeners();
    try {
      if (_loanTypes.isEmpty) { await _fetchLoanTypes(); }
      final url = "${ApiConstants.baseUrl}${ApiConstants.loanRequestsEndpoint}?q=UsersCode=$usersCode";
      final data = await _dataFetchService.fetchDataFromUrl(url);
      _loanRequests = LoanRequestList.fromJson(data!).items;
    } catch (e) {
      _error = "خطأ تحميل طلبات السلف: ${e.toString()}";
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  Future<void> loadResignationRequests(int usersCode) async {
    _isLoading = true; _error = null;
    notifyListeners();
    try {
      final url = "${ApiConstants.baseUrl}${ApiConstants.resignationRequestsEndpoint}?q=UsersCode=$usersCode";
      final data = await _dataFetchService.fetchDataFromUrl(url);
      _resignationRequests = ResignationRequestList.fromJson(data!).items;
    } catch (e) {
      _error = "خطأ تحميل طلبات الاستقالة: ${e.toString()}";
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  // -- دوال تحميل قوائم "طلباتي" --
  Future<void> loadMyVacationRequests(int empCode) async {
    await _loadData<MyVacationRequestList>(
      url: "${ApiConstants.baseUrl}${ApiConstants.myVacationRequestsEndpoint}?q=EmpCode=$empCode",
      onSuccess: (data) => _myVacationRequests = data.items,
      onError: (e) => _error = "خطأ تحميل طلبات الإجازة: $e",
    );
    print('Length Data is ${_myVacationRequests.length}');
    print('Value Data is ${_myVacationRequests.length}');
    print('Url is ${ApiConstants.baseUrl+ApiConstants.myVacationRequestsEndpoint}?q=EmpCode=$empCode}');
  }

  Future<void> loadMyLoanRequests(int empCode) async {
    if (_loanTypes.isEmpty) await _fetchLoanTypes();
    await _loadData<MyLoanRequestList>(
      url: "${ApiConstants.baseUrl}${ApiConstants.myLoanRequestsEndpoint}?q=EmpCode=$empCode",
      onSuccess: (data) => _myLoanRequests = data.items,
      onError: (e) => _error = "خطأ تحميل طلبات السلف: $e",
    );
  }

  Future<void> loadMyResignationRequests(int empCode) async {
    await _loadData<MyResignationRequestList>(
      url: "${ApiConstants.baseUrl}${ApiConstants.myResignationRequestsEndpoint}?q=EmpCode=$empCode",
      onSuccess: (data) => _myResignationRequests = data.items,
      onError: (e) => _error = "خطأ تحميل طلبات الاستقالة: $e",
    );
  }

  // دالة عامة لتحميل القوائم
  Future<void> _loadData<T>(
      {required String url, required Function(T) onSuccess, required Function(dynamic) onError}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if(data == null) throw Exception("No data received from the server.");

      // التحويل من json بناءً على النوع T
      if (T == VacationRequestList) onSuccess(VacationRequestList.fromJson(data) as T);
      else if (T == LoanRequestList) onSuccess(LoanRequestList.fromJson(data) as T);
      else if (T == ResignationRequestList) onSuccess(ResignationRequestList.fromJson(data) as T);
      else if (T == MyVacationRequestList) onSuccess(MyVacationRequestList.fromJson(data) as T);
      else if (T == MyLoanRequestList) onSuccess(MyLoanRequestList.fromJson(data) as T);
      else if (T == MyResignationRequestList) onSuccess(MyResignationRequestList.fromJson(data) as T);
      else throw Exception("Unknown data type for parsing: $T");

    } catch (e) {
      onError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---===< 4. دوال تحميل تفاصيل الاعتمادات >===---

  void selectVacationRequest(VacationRequestItem request) { _selectedVacationRequest = request; _vacationAuthDetails = null; notifyListeners(); }
  void selectLoanRequest(LoanRequestItem request) { _selectedLoanRequest = request; _loanAuthDetails = null; notifyListeners(); }
  void selectResignationRequest(ResignationRequestItem request) { _selectedResignationRequest = request; _resignationAuthDetails = null; notifyListeners(); }

  void selectMyVacationRequest(MyVacationRequestItem request) { _selectedMyVacationRequest = request; _myVacationAuthDetails = null; notifyListeners(); }
  void selectMyLoanRequest(MyLoanRequestItem request) { _selectedMyLoanRequest = request; _myLoanAuthDetails = null; notifyListeners(); }
  void selectMyResignationRequest(MyResignationRequestItem request) { _selectedMyResignationRequest = request; _myResignationAuthDetails = null; notifyListeners(); }

  Future<void> loadVacationAuthDetails() async {
    final url = _selectedVacationRequest?.getLink('PyOrderVcncHAuthVO');
    if (url == null) return;
    await _loadAuthDetails<VacationAuthResponse>(url: url, onSuccess: (data) => _vacationAuthDetails = data, fromJson: (json) => VacationAuthResponse.fromJson(json));
  }

  Future<void> loadLoanAuthDetails() async {
    final url = _selectedLoanRequest?.getLink('PyPrsnlLoanReqAuthVO');
    if (url == null) return;
    await _loadAuthDetails<LoanAuthResponse>(url: url, onSuccess: (data) => _loanAuthDetails = data, fromJson: (json) => LoanAuthResponse.fromJson(json));
  }

  Future<void> loadResignationAuthDetails() async {
    final url = _selectedResignationRequest?.getLink('PyEndsrvOrderHAuthVO');
    if (url == null) return;
    await _loadAuthDetails<ResignationAuthResponse>(url: url, onSuccess: (data) => _resignationAuthDetails = data, fromJson: (json) => ResignationAuthResponse.fromJson(json));
  }

  Future<void> loadMyVacationAuthDetails() async {
    final url = _selectedMyVacationRequest?.getLink('PyOrderVcncHAuthVO');
    if (url == null) return;
    await _loadAuthDetails<VacationAuthResponse>(url: url, onSuccess: (data) => _myVacationAuthDetails = data, fromJson: (json) => VacationAuthResponse.fromJson(json));
  }

  Future<void> loadMyLoanAuthDetails() async {
    final url = _selectedMyLoanRequest?.getLink('PyPrsnlLoanReqAuthVO');
    if (url == null) return;
    await _loadAuthDetails<LoanAuthResponse>(url: url, onSuccess: (data) => _myLoanAuthDetails = data, fromJson: (json) => LoanAuthResponse.fromJson(json));
  }

  Future<void> loadMyResignationAuthDetails() async {
    final url = _selectedMyResignationRequest?.getLink('PyEndsrvOrderHAuthVO');
    if (url == null) return;
    await _loadAuthDetails<ResignationAuthResponse>(url: url, onSuccess: (data) => _myResignationAuthDetails = data, fromJson: (json) => ResignationAuthResponse.fromJson(json));
  }

  Future<void> _loadAuthDetails<T>({required String url, required Function(T) onSuccess, required T Function(Map<String, dynamic>) fromJson}) async {
    _isLoading = true; _error = null; notifyListeners();
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if(data == null) throw Exception("No auth details received.");
      onSuccess(fromJson(data));
    } catch (e) {
      _error = "خطأ تحميل الاعتمادات: $e";
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  // ---===< 5. دوال مساعدة ومنطق عام >===---

  Future<void> _fetchLoanTypes() async {
    try {
      final data = await _dataFetchService.fetchDataFromUrl("${ApiConstants.baseUrl}${ApiConstants.loanTypesEndpoint}");
      if(data != null) _loanTypes = LoanTypeList.fromJson(data).items;
    } catch (e) {
      debugPrint("Failed to load loan types: $e");
    }
  }

  String getLoanTypeName(int? typeCode,bool langType) {
    if (typeCode == null) return 'غير محدد';
    try {
      if(langType)
      return _loanTypes.firstWhere((type) => type.loanTypeCode == typeCode).nameA ?? 'غير معروف';
      else
        return _loanTypes.firstWhere((type) => type.loanTypeCode == typeCode).nameE ?? 'غير معروف';
    } catch (e) {
      return 'غير معروف ($typeCode)';
    }
  }

  String getVacationTypeName(int? typeCode) {
    switch (typeCode) {
      case 12: return 'سنوية';
      case 1: return 'عادية';
      case 2: return 'بدون مرتب';
      case 4: return 'مرضية';
      default: return 'غير معروف';
    }
  }

  String getRequestStatusName(int? flag) {
    switch (flag) {
      case 1: return 'معتمدة';
      case -1: return 'مرفوضة';
      case 0: return 'تحت الإجراء';
      default: return 'جديدة';
    }
  }

  // دالة الإرسال تبقى كما هي...
  Future<bool> submitAction({
    required int usersCode,
    required String usersDesc,
    required int authFlag,
    required String authTableName,
    required String authPk1,
    required String authPk2,
    required List<dynamic> authChain,
    required int systemNumber,
    required int fileSerial,
  }) async {
    _isSubmittingAction = true;
    _actionError = null;
    notifyListeners();

    try {
      int lastPrevSer = 0;
      if (authChain.isNotEmpty) {
        // تأكد من أن prevSer ليس null قبل استخدامه
        lastPrevSer = authChain.last.prevSer ?? 0;
      }

      int calculatedPrevSer = (lastPrevSer == 0) ? 1 : int.parse("${lastPrevSer}1");

      // --== التصحيح الأهم: تغيير فورمات التاريخ ==--
      final String authDate = DateTime.now().toIso8601String();

      final Map<String, dynamic> requestBody = {
        "AltKey": "$authTableName-$authPk1-$authPk2-$calculatedPrevSer",
        "AuthDate": authDate,
        "AuthFlag": authFlag,
        "AuthPk1": authPk1,
        "AuthPk2": authPk2,
        "AuthPk3": null, "AuthPk4": null, "AuthPk5": null,
        "AuthTableName": authTableName,
        "FileSerial": fileSerial,
        "PrevSer": calculatedPrevSer,
        "SystemNumber": systemNumber,
        "UsersCode": usersCode,
        "UsersDesc": usersDesc.isEmpty ? (authFlag == 1 ? "تم الاعتماد" : "تم الرفض") : usersDesc,
        "MobileAuth": 1,
      };

      final response = await http.post(
        Uri.parse(ApiConstants.submitActionUrl),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode(requestBody),
      );

      debugPrint("--- HR Action Response [${response.statusCode}] ---");
      debugPrint(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        String serverErrorMsg = "فشل الإجراء.";
        try {
          final errorData = json.decode(utf8.decode(response.bodyBytes));
          serverErrorMsg = errorData["title"] ?? errorData["detail"] ?? serverErrorMsg;
        } catch (_) {}
        throw Exception("خطأ ${response.statusCode}: $serverErrorMsg");
      }
    } catch (e) {
      _actionError = e.toString().replaceFirst("Exception: ", "");
      return false;
    } finally {
      _isSubmittingAction = false;
      notifyListeners();
    }
  }
}