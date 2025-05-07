// // import 'package:shared_preferences/shared_preferences.dart';

// // class SharedpreferenceHelper {
// //   static String userIdKey = "USERKEY";
// //   static String userNameKey = "USERNAMEKEY";
// //   static String userEmailKey = "USEREMAILKEY";
// //   static String userImageKey = "USERIMAGEKEY";

// //   Future<bool> saveUserId(String getUserId) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     return prefs.setString(userIdKey, getUserId);
// //   }

// //   Future<bool> saveUserName(String getUserName) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     return prefs.setString(userNameKey, getUserName);
// //   }

// //   Future<bool> saveUserImage(String getUserImage) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     return prefs.setString(userImageKey, getUserImage);
// //   }

// //   Future<bool> saveUserEmail(String getUserEmail) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     return prefs.setString(userEmailKey, getUserEmail);
// //   }

// //   Future<String?> getUserId() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     return prefs.getString(userIdKey);
// //   }

// //   Future<String?> getUserName() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     return prefs.getString(userNameKey);
// //   }

// //   Future<String?> getUserEmail() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     return prefs.getString(userEmailKey);
// //   }

// //   Future<String?> getUserImage() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     return prefs.getString(userImageKey);
// //   }
// // }
// ---------
// import 'package:shared_preferences/shared_preferences.dart';

// class SharedpreferenceHelper {
//   // User-related keys
//   static String userIdKey = "USERKEY";
//   static String userNameKey = "USERNAMEKEY";
//   static String userEmailKey = "USEREMAILKEY";
//   static String userImageKey = "USERIMAGEKEY";

//   // Admin-related keys (new keys for admin data)
//   static String adminIdKey = "ADMINIDKEY";
//   static String adminNameKey = "ADMINNAMEKEY";
//   static String adminEmailKey = "ADMINEMAILKEY";

//   // Save user data
//   Future<bool> saveUserId(String getUserId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString(userIdKey, getUserId);
//   }

//   Future<bool> saveUserName(String getUserName) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString(userNameKey, getUserName);
//   }

//   Future<bool> saveUserImage(String getUserImage) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString(userImageKey, getUserImage);
//   }

//   Future<bool> saveUserEmail(String getUserEmail) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString(userEmailKey, getUserEmail);
//   }

//   // Save admin data
//   Future<bool> saveAdminId(String getAdminId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString(adminIdKey, getAdminId);
//   }

//   Future<bool> saveAdminName(String getAdminName) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString(adminNameKey, getAdminName);
//   }

//   Future<bool> saveAdminEmail(String getAdminEmail) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString(adminEmailKey, getAdminEmail);
//   }

//   // Get user data
//   Future<String?> getUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(userIdKey);
//   }

//   Future<String?> getUserName() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(userNameKey);
//   }

//   Future<String?> getUserEmail() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(userEmailKey);
//   }

//   Future<String?> getUserImage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(userImageKey);
//   }

//   // Get admin data
//   Future<String?> getAdminId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(adminIdKey);
//   }

//   Future<String?> getAdminName() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(adminNameKey);
//   }

//   Future<String?> getAdminEmail() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(adminEmailKey);
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferenceHelper {
  // User-related keys
  static const String userIdKey = "USERKEY";
  static const String userNameKey = "USERNAMEKEY";
  static const String userEmailKey = "USEREMAILKEY";
  static const String userImageKey = "USERIMAGEKEY";

  // Admin-related keys
  static const String adminIdKey = "ADMINIDKEY";
  static const String adminNameKey = "ADMINNAMEKEY";
  static const String adminEmailKey = "ADMINEMAILKEY";

  // Save user data
  Future<bool> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, userId);
  }

  Future<bool> saveUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, userName);
  }

  Future<bool> saveUserImage(String userImage) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImageKey, userImage);
  }

  Future<bool> saveUserEmail(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, userEmail);
  }

  // Get user data
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }

  // Save admin data
  Future<bool> saveAdminId(String adminId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(adminIdKey, adminId);
  }

  Future<bool> saveAdminName(String adminName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(adminNameKey, adminName);
  }

  Future<bool> saveAdminEmail(String adminEmail) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(adminEmailKey, adminEmail);
  }

  // Get admin data
  Future<String?> getAdminId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(adminIdKey);
  }

  Future<String?> getAdminName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(adminNameKey);
  }

  Future<String?> getAdminEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(adminEmailKey);
  }
}
