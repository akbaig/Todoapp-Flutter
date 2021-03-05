import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

Future<String> getFilePath(String filename) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/$filename.txt'; // 3
    return filePath;
}

void saveFile(String filename, dynamic fileContent) async {
  String convertedString;
  File file = File(await getFilePath(filename));
  if(filename == 'content')
    convertedString = convertListToString(fileContent);
  else if (filename =='reminder_counter')
    convertedString = fileContent.toString();
  file.writeAsString(convertedString);
}

String convertListToString(dynamic list) {
  return jsonEncode(list);
}

Future<dynamic> readFile(String filename) async {
  File file = File(await getFilePath(filename));
  if(await file.exists())
  {
    
    String fileContent = await file.readAsString();
    if(filename == 'content')
      return convertListFromString(fileContent);
    else if(filename == 'reminder_counter')
      return int.parse(fileContent);
  }
  else 
  {
    print('File $filename doesn\'t exist');
    return null;
  }
}

List<dynamic> convertListFromString(String content) {
  List<dynamic> myL = jsonDecode(content);
  return myL;
}