
import 'package:flutter/material.dart';
import 'package:shopapp/medules/login/login_screen.dart';
import 'package:shopapp/shared/network/local/cache_helper.dart';

import 'componants.dart';

const String apiKey = '150abe050c3445b8b41b6722b4671941';

const String baseUrl = 'https://student.valuxapps.com/api/';


void signOut(context){
  CacheHelper.removeData(key: 'token').then((value) {
    if(value){
      navigateAndFinish(context, LoginScreen());
    }
  });
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}

String? token;

