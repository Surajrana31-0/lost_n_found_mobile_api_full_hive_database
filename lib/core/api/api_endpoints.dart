import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();


  static const bool  isPhysicalDevice =false; // Set to true if running on a physical device, false for emulator/simulator.
  static const String compIpAddress = 'http://192.168.1.1';
  // static const String compIpAddress = '2400:1a00:4b82:a550:2b65:dd04:5dc8:d6b0';//My laptop's IP address.


  
  //Get the base URL based on the platform
  static String get baseUrl {
    if (isPhysicalDevice){
      return 'http://$compIpAddress:300/api/v1';
    }
    //check the device type and return the appropriate base URL
    if(kIsWeb){
      return 'http://localhost:3000/api/v1';
    } else if (Platform.isAndroid){
      return 'http://10.0.2.2:3000/api/v1';
    } else if (Platform.isIOS){
      return 'http://localhost:3000/api/v1';
    } else {
      return 'http://localhost:3000/api/v1';
    }
  }
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // =========== Batch Endpoints ===========
  static const String batches = '/batches';
  static String batchById(String id) => '/batches/$id';

  // =========== Category Endpoints ===========
  static const String categories = '/categories';
  static String categoryById(String id) => '/categories/$id';

  // =========== Student Endpoints ===========
  static const String students = '/students';
  static const String studentLogin = '/students/login';
  static String studentById(String id) => '/students/$id';
  static String studentPhoto(String id) => '/students/$id/photo';

  // =========== Item Endpoints ===========
  static const String items = '/items';
  static String itemById(String id) => '/items/$id';
  static String itemClaim(String id) => '/items/$id/claim';
  static String itemUploadPhoto = 'items/upload-photo';
  static String itemUploadVideo = 'items/upload-video';
  

  // =========== Comment Endpoints ===========
  static const String comments = '/comments';
  static String commentById(String id) => '/comments/$id';
  static String commentsByItem(String itemId) => '/comments/item/$itemId';
  static String commentLike(String id) => '/comments/$id/like';
}
