import 'package:http/http.dart';
Future<bool> deleteProduct(String productId) async {
  final url = Uri.parse("https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId");
  final response = await get(url);

  if(response.statusCode == 200){
    return true;
  }else {
    return false;
  }

}