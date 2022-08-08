class Character{

  int id=0;
  String name="";
  String titleEN="";
  String titleROM="";
  String imageURL="";

  Character();

  Character.fromJson(Map<String, dynamic> json){
    id = json["data"]["Character"]["id"];
    name = json["data"]["Character"]["name"]["full"];

    try{
      titleEN =
          json["data"]["Character"]["media"]["nodes"][0]["title"]["english"];
    }catch(e){
      titleEN="";
    }

    try
    {
      titleROM =
      json["data"]["Character"]["media"]["nodes"][0]["title"]["romaji"];
    }catch(e){
      titleROM="";
    }

    imageURL = json["data"]["Character"]["image"]["medium"];

  }

  Character.byShow(Map<String, dynamic> json, int index){
    try{
      titleEN =
      json["data"]["Media"]["title"]["english"];
    }catch(e){
      titleEN="";
    }

    try
    {
      titleROM =
      json["data"]["Media"]["title"]["romaji"];
    }catch(e){
      titleROM="";
    }

    id = json["data"]["Media"]["characters"]["nodes"][index]["id"];
    name = json["data"]["Media"]["characters"]["nodes"][index]["name"]["full"];
    imageURL = json["data"]["Media"]["characters"]["nodes"][index]["image"]["medium"];

  }
}