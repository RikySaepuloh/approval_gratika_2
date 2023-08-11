import 'dart:convert';
import 'package:al_downloader/al_downloader.dart';
import 'package:approval_gratika/constants.dart';
import 'package:approval_gratika/model/approval_detail.dart';
import 'package:approval_gratika/model/approval_list_item.dart';
import 'package:approval_gratika/model/history_list_item.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../model/confirm_data_model.dart';
import '../model/profile.dart';
import '../shared_preferences_utils.dart';
import 'logging_client.dart';

class Repository{
  Future<void> downloadFile(String url, String fileName) async {
    final directory = await getExternalStorageDirectory();
    // final directory = await getDownloadsDirectory();

    ALDownloader.download(url,
      directoryPath: directory!.path,
      fileName: fileName,
      downloaderHandlerInterface: ALDownloaderHandlerInterface(
        progressHandler: (progress) {
          debugPrint(
              'ALDownloader | download progress = $progress, url = $url\n');
        },
        succeededHandler: () {
          debugPrint('ALDownloader | download succeeded, url = $url\n');
        },
        failedHandler: () {
          debugPrint('ALDownloader | download failed, url = $url\n');
        },
        pausedHandler: () {
          debugPrint('ALDownloader | download paused, url = $url\n');
        },
      ),
    );
  }



  Future sendNotif(String no_pesan) async {
    try{
        http.Client client = LoggingClient();
        final Map<String, String> queryParams = {
          'no_pesan': no_pesan,
        };
        Uri url = Uri.parse("${Constants.apiURL}/siaga-auth/notif-approval").replace(queryParameters: queryParams);
        final response = await client.post(url);
        print(response.body);
        if(response.statusCode == 200){
          final jsonData = json.decode(response.body);
          // final myApprovalDetail = ApprovalDetail.fromJson(jsonData);
          // return myApprovalDetail;
        }else if(response.statusCode == 401 && jsonDecode(response.body)['message'] == "Unauthorized"){
          Fluttertoast.showToast(
              msg: "Sesi telah habis. Silakan login kembali.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              fontSize: 12.0
          );
          await SharedPreferencesUtils.clearLoginToken();
          return 0;
        }


    }catch( e ){

    }
  }

  Future sendNotifEmail(String noPooling,String noPooling2) async {
    try{
      http.Client client = LoggingClient();
      final Map<String, String> queryParams = {
        'no_pooling': noPooling,
        'no_pooling2': noPooling2,
      };
      Uri url = Uri.parse("${Constants.apiURL}/siaga-trans/send-email").replace(queryParameters: queryParams);
      final response = await client.post(url);
      print(response.body);
      if(response.statusCode == 200){
        // final jsonData = json.decode(response.body);
        // Fluttertoast.showToast(
        //     msg: jsonData['message'],
        //     toastLength: Toast.LENGTH_LONG,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     fontSize: 12.0
        // );
      }else if(response.statusCode == 401 && jsonDecode(response.body)['message'] == "Unauthorized"){
        Fluttertoast.showToast(
            msg: "Sesi telah habis. Silakan login kembali.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 12.0
        );
        await SharedPreferencesUtils.clearLoginToken();
        return 0;
      }


    }catch( e ){

    }
  }

  Future getProfile() async {
    try{
      http.Client client = LoggingClient();
      Uri url = Uri.parse("${Constants.apiURL}/siaga-auth/profile").replace();
      final response = await client.get(url);
      print(response.body);
      if(response.statusCode == 200){
        final jsonData = json.decode(response.body);
        final userModel = UserModel.fromJson(jsonData);
        return userModel;
      }else if(response.statusCode == 401 && jsonDecode(response.body)['message'] == "Unauthorized"){
        Fluttertoast.showToast(
            msg: "Sesi telah habis. Silakan login kembali.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 12.0
        );
        await SharedPreferencesUtils.clearLoginToken();
        return 0;
      }
    }catch( e ){

    }
  }



  Future setApproveBeban(String noBukti, String modul,String keterangan,String noUrut,String tanggal,String status) async {
    try{

      if(keterangan.isEmpty || keterangan=="" || keterangan.trim().isEmpty || keterangan.trim() == ""){
        Fluttertoast.showToast(
            msg: "Keterangan tidak boleh kosong.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 12.0
        );
      }else{
        http.Client client = LoggingClient();
        final Map<String, String> queryParams = {
          'no_aju': noBukti,
          'modul': modul,
          'keterangan': keterangan,
          'no_urut': noUrut,
          'tanggal': tanggal,
          'status': status,
        };
        Uri url = Uri.parse("${Constants.apiURL}/siaga-trans/app").replace(queryParameters: queryParams);
        final response = await client.post(url);
        print(response.body);
        if(response.statusCode == 200){
          final jsonData = json.decode(response.body);
          final jsonResponse = ConfirmDataModel.fromJson(jsonData);
          sendNotif(jsonResponse.noPesan);
          sendNotifEmail(jsonResponse.noPooling,jsonResponse.noPooling2);
          return jsonResponse;
        }else if(response.statusCode == 401 && jsonDecode(response.body)['message'] == "Unauthorized"){
          Fluttertoast.showToast(
              msg: "Sesi telah habis. Silakan login kembali.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              fontSize: 12.0
          );
          await SharedPreferencesUtils.clearLoginToken();
          return "Sesi telah habis. Silakan login kembali.";
        }
      }

    }catch( e ){

    }
  }

  Future getDetailApprovalData(noBukti) async {
    try{
      http.Client client = LoggingClient();
      final Map<String, String> queryParams = {
        'no_aju': noBukti,
      };
      Uri url = Uri.parse("${Constants.apiURL}/siaga-trans/app-detail").replace(queryParameters: queryParams);
      final response = await client.get(url);
      print(response.body);
      if(response.statusCode == 200){
        final jsonData = json.decode(response.body);
        final myApprovalDetail = ApprovalDetail.fromJson(jsonData);
        return myApprovalDetail;
      }else if(response.statusCode == 401 && jsonDecode(response.body)['message'] == "Unauthorized"){
        Fluttertoast.showToast(
            msg: "Sesi telah habis. Silakan login kembali.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 12.0
        );
        await SharedPreferencesUtils.clearLoginToken();
        return 0;
      }
    }catch( e ){

    }
  }

  Future getApprovalListData() async {
    try{
      http.Client client = LoggingClient();
      Uri url = Uri.parse("${Constants.apiURL}/siaga-trans/app-aju");
      final response = await client.get(url);
      print(response.body);
      if(response.statusCode == 200){
        Iterable it = jsonDecode(response.body)['data'];
        List<ApprovalListItem> listData = it.map((e) => ApprovalListItem.fromJson(e)).toList();
        return listData;
      }else if(response.statusCode == 401 && jsonDecode(response.body)['message'] == "Unauthorized"){
        Fluttertoast.showToast(
            msg: "Sesi telah habis. Silakan login kembali.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 12.0
        );
        await SharedPreferencesUtils.clearLoginToken();
        return 0;
      }
    }catch( e ){

    }
  }

  Future getHistoryApprovalListData() async {
    try{
      http.Client client = LoggingClient();
      Uri url = Uri.parse("${Constants.apiURL}/siaga-trans/app");
      final response = await client.get(url);
      print(response.body);
      if(response.statusCode == 200){
        Iterable it = jsonDecode(response.body)['data'];
        List<HistoryListItem> listData = it.map((e) => HistoryListItem.fromJson(e)).toList();
        return listData;
      }
    }catch( e ){

    }
  }
}