import 'dart:convert';
import 'package:anitierlist/models/character/character.dart';
import 'package:http/http.dart' as http;


class QueryClass{
  QueryClass();

  Future<Character> searchCharacterByID(int id) async{
    var variables = {
      'id':id,
    };

    String queryString = """query (\$id: Int){
      Character (id:\$id){
        id
        name{
          full
        }
        media(type:ANIME, sort:[ID]){
          nodes{
            title{
              english
              romaji
            }
          }
        }
       image{
         medium
       }
      }
    }""";

    try{
      var headers = {"Content-type": "application/json"};
      var body = jsonEncode({"query": queryString,"variables":variables});
      var response = await http.post(Uri.parse('https://graphql.anilist.co'),
          headers: headers,body: body);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode==200){
        var resList = jsonDecode(response.body);
        Character character = Character.fromJson(resList);
        return character;
      }


      return Character();
    }catch(e){
      rethrow;
    }
  }

  // search char by name
  Future<Character> searchCharacterByName(String charName) async{
    var variables = {
      'search':charName,
    };

    String queryString = """query (\$search: String){
      Character (search:\$search, sort:[SEARCH_MATCH]){
        id
        name{
          full
        }
        media(type:ANIME, sort:[ID]){
          nodes{
            title{
              english
              romaji
            }
          }
        }
       image{
         medium
       }
      }
    }""";

    try{
      var headers = {"Content-type": "application/json"};
      var body = jsonEncode({"query": queryString,"variables":variables});
      var response = await http.post(Uri.parse('https://graphql.anilist.co'),
          headers: headers,body: body);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode==200){
        var resList = jsonDecode(response.body);
        Character character = Character.fromJson(resList);
        return character;
      }


      return Character();
    }catch(e){
      rethrow;
    }
  }

  // Get characters by show
  Future<List<Character>> searchMainCharacterByShow(String showName) async{
    var variables = {
      'search':showName,
    };

    String queryString = """query (\$search: String){
      Media (search:\$search){
        id
        title{
          english
          romaji
        }
        characters(role:MAIN,sort:[RELEVANCE]){
          nodes{
            id
            name{
              full
            }
            image{
              medium
            }
          }
        }
      }
    }""";

    try{
      List<Character> charList=[];
      var headers = {"Content-type": "application/json"};
      var body = jsonEncode({"query": queryString,"variables":variables});
      var response = await http.post(Uri.parse('https://graphql.anilist.co'),
          headers: headers,body: body);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode==200) {
        var resList = jsonDecode(response.body);
        for (int i = 0; i<resList["data"]["Media"]["characters"]["nodes"].length; i++) {
          Character character = Character.byShow(resList, i);
          charList.add(character);
        }
      }
      return charList;
    }catch(e){
      rethrow;
    }
  }

  // Get characters by show
  Future<List<Character>> searchSideCharacterByShow(String showName) async{
    var variables = {
      'search':showName,
    };

    String queryString = """query (\$search: String){
      Media (search:\$search){
        id
        title{
          english
          romaji
        }
        characters(role:SUPPORTING,sort:[RELEVANCE]){
          nodes{
            id
            name{
              full
            }
            image{
              medium
            }
          }
        }
      }
    }""";

    try{
      List<Character> charList=[];
      var headers = {"Content-type": "application/json"};
      var body = jsonEncode({"query": queryString,"variables":variables});
      var response = await http.post(Uri.parse('https://graphql.anilist.co'),
          headers: headers,body: body);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode==200) {
        var resList = jsonDecode(response.body);
        for (int i = 0; i<resList["data"]["Media"]["characters"]["nodes"].length; i++) {
          Character character = Character.byShow(resList, i);
          charList.add(character);
        }
      }
      return charList;
    }catch(e){
      rethrow;
    }
  }



}