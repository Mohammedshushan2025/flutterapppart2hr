// lib/core/api/api_constants.dart

class ApiConstants {
  static const String baseUrl = 'http://162.55.104.180:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1';
  //http://37.27.112.187:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1


  // Endpoints لطلبات GET
  static const String usersEndpoint = '/UsersVO1';
  static const String userSalaryInfoEndpoint = '/PySlrsInfoVO1';
  static const String userTransactionsInfoEndpoint = '/UsersTrnInfoVRO1';

  // --== Endpoints سابقة ==--
  static const String purchaseOrdersEndpoint = '/PrOrderProcessVRO1';

  // --== Endpoints جديدة ==--  //PyOrderVcncHVO1
  static const String vacationRequestsEndpoint = '/PyOrderVcncHProcessVRO1';
  static const String loanRequestsEndpoint = '/PyPrsnlLoanReqProcessVRO1';
  static const String resignationRequestsEndpoint = '/PyEndsrvOrderHProcessVRO1';
  static const String loanTypesEndpoint = '/PyPrsnlLoanTypesVRO1';

  // Endpoint لطلب POST الخاص بالإجراءات (مشترك)
  static const String submitActionUrl = "$baseUrl/SeUsersAuthVO1";

  // ---== Endpoints طلباتي ==---
  static const String myVacationRequestsEndpoint = '/PyOrderVcncHVO1';
  static const String myLoanRequestsEndpoint = '/PyPrsnlLoanReqVO1';
  static const String myResignationRequestsEndpoint = '/PyEndsrvOrderHVO1';

  // ---== Endpoints طلباتي (POST) ==---
  static const String createVacationRequestEndpoint = '/PyOrderVcncHVO1';
  static const String createLoanRequestEndpoint = '/PyPrsnlLoanReqVO1';
  static const String createResignationRequestEndpoint = '/PyEndsrvOrderHVO1';


  // ---== Endpoints الحضور والانصراف ==---
  static const String attendanceMonthsEndpoint = '/TaEmpSheetDummyMastVRO1'; // <-- الإضافة المصححة
// ---== إضافة جديدة ==---
  static const String checkedAttendanceMonthsEndpoint = '/TaEmpSheetMastVRO1';

  // ---== إضافة جديدة ==---
  static const String createAttendanceLogEndpoint = '/TaEmpSheetDummyVO1';

  static const String userTransactionInfoEndpoint = '/UsersTrnInfoVRO1';
  // -- الإضافة الجديدة --
  static const String checkInOutEndpoint = '$baseUrl/TaEmpSheetDummyVO1';
}