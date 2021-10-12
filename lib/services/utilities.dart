// import 'dart:io';
// import 'package:my_board_new/models/Lecture.dart';
// import 'package:my_board_new/models/Resident.dart';
// import 'package:path/path.dart';
// import 'package:excel/excel.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class Utilities {
//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }
//
//   Future<String> get _downloadsDirectory async {
//     Directory downloadsDirectory =
//         await DownloadsPathProvider.downloadsDirectory;
//     return downloadsDirectory.path;
//   }
//
//   Future<Excel> createExcel() async {
//     var status = await Permission.storage.status;
//     final path = await _localPath;
//     if (status.isDenied) {
//       print('Permission Denied');
//       await Permission.storage.request().then((value) => createExcel());
//     }
//
//     return Excel.createExcel();
//   }
//
//   setExcelLectureAttendees(Lecture lecture, List<Resident> residents) async {
//     Excel excel = await createExcel();
//     String downloadDirectory = await _downloadsDirectory;
//     List<String> dataHeaders = ["Name", "phone"];
//     var excelSheet = await excel.getDefaultSheet();
//     excel.insertRowIterables(excelSheet, dataHeaders, 0);
//
//     int index = 0;
//     residents
//         .map((element) => {
//               print(residents[index].name),
//               excel.insertRowIterables(
//                   excelSheet, [element.name, element.phone], index + 1),
//               index++
//             })
//         .toList();
//     excel.insertRowIterables(
//         excelSheet,
//         [
//           'Lecture date: ${lecture.date}, Lecturer: ${lecture.lecturer}'
//         ],
//         index+2);
//     excel.insertRowIterables(
//         excelSheet,
//         [
//           'Lecture subject: ${lecture.subject}, location: ${lecture.location}'
//         ],
//         index+3);
//     excel.encode().then((onValue) {
//       File(join("$downloadDirectory/excel.xlsx"))
//         ..createSync(recursive: true)
//         ..writeAsBytesSync(onValue);
//     });
//   }
//
// }
