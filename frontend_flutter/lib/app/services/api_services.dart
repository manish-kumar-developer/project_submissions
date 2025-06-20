// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ApiServices {
//   SharedPrefHelper pref = SharedPrefHelper();
//   String bearerAccessToken = '';
//
//   Future<void> getSavedAccessToken() async {
//     await pref.getAccessToken();
//     bearerAccessToken = 'Bearer ${pref.accessToken}';
//   }
//
//   Future<SignInModel> loginUser({
//     required String email,
//     required String password,
//   }) async {
//     final response = await http.post(
//       Uri.parse(ApiList.login),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(
//         <String, String>{
//           'email': email,
//           'password': password,
//         },
//       ),
//     );
//     Map<String, dynamic> responseData = jsonDecode(response.body);
//     if (response.statusCode == 200) {
//       return SignInModel.fromJson(responseData);
//     } else if (response.statusCode != 200) {
//       if (response.statusCode == 403) {
//         await pref.setLoginSession(
//           isLoggedInValue: true,
//         );
//         Get.offAll(() => CheckYourEmailScreen(
//           email: email,
//         ));
//       }
//       return SignInModel.fromJson(responseData);
//     } else {
//       throw Exception('Something went wrong');
//     }
//   }
//
//
//   Future<GetPatientExerciseModel> getPatientExercises(
//       {required String id}) async {
//     await getSavedAccessToken();
//     final response = await http.get(
//       Uri.parse("${ApiList.getPatientExercises}/$id"),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': bearerAccessToken,
//       },
//     );
//     Map<String, dynamic> responseData = jsonDecode(response.body);
//     if (response.statusCode == 200) {
//       return GetPatientExerciseModel.fromJson(responseData);
//     } else if (response.statusCode != 200) {
//       if (response.statusCode == 401) {
//         Get.offAll(() => SignInScreen());
//       }
//       return GetPatientExerciseModel.fromJson(responseData);
//     } else {
//       throw Exception('Something went wrong');
//     }
//   }
//
//
//   Future<DeletePatientModel> deletePatient({required String id}) async {
//     await getSavedAccessToken();
//     final response = await http.delete(
//       Uri.parse("${ApiList.deletePatient}/$id"),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': bearerAccessToken,
//       },
//     );
//     Map<String, dynamic> responseData = jsonDecode(response.body);
//     if (response.statusCode == 200) {
//       return DeletePatientModel.fromJson(responseData);
//     } else if (response.statusCode != 200) {
//       if (response.statusCode == 401) {
//         Get.offAll(() => SignInScreen());
//       }
//       return DeletePatientModel.fromJson(responseData);
//     } else {
//       throw Exception('Something went wrong');
//     }
//   }
//
//
//   Future<LogOutModel> logoutUser() async {
//     await getSavedAccessToken();
//     final response = await http.post(
//       Uri.parse(ApiList.logout),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': bearerAccessToken,
//       },
//     );
//     Map<String, dynamic> responseData = jsonDecode(response.body);
//     if (response.statusCode == 200) {
//       return LogOutModel.fromJson(responseData);
//     } else if (response.statusCode != 200) {
//       if (response.statusCode == 401) {
//         Get.offAll(() => SignInScreen());
//       }
//       return LogOutModel.fromJson(responseData);
//     } else {
//       throw Exception('Something went wrong');
//     }
//   }
// }
