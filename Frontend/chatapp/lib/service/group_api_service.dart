import 'dart:convert';

import 'package:demo_isar_app/global_variable.dart';
import 'package:demo_isar_app/model/group.dart';
import 'package:http/http.dart' as http;

class GroupApiService {

  Future<List<Group>> getAllGroups (String token)async{
    try{
      http.Response response = await http.get(
          Uri.parse('$uri/api/get-all-groups'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token!
        }
      );

      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        print(data);
        final List<Group> groups = data.map((group)=>Group.fromMap(group)).toList();
        return groups;
      }
      else{
        throw Exception("We got the error:${response.body}");
      }

    }catch(e){
      throw Exception("We got the error:${e.toString()}");
    }
  }
  
  
}