import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cypress/app/data/endpoint/app_endpoint.dart';
import 'package:cypress/app/data/model/album_model.dart';
import 'package:cypress/app/data/model/failure.dart';
import 'package:cypress/app/data/model/photo_model.dart';
import 'package:cypress/app/domain/repository/album_repository_interface.dart';
import 'package:http/http.dart' as http;

class AlbumRepository extends AlbumRepositoryInterface{
  final Duration _timeOutDuration = const Duration(seconds: 60);
  final http.Client _client =  http.Client();

  @override
  Future<List<AlbumModel>?> getAlbum() async{
    try {
      final url = Uri.parse(ApiUrl.getAlbum);

      final response = await _client.get(
        url,
      ).timeout(_timeOutDuration);
      if (response.statusCode == 200) {
        return albumModelFromJson(response.body);
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    }catch(e){
      throw Failure("something went wrong");
    }
    return null;
  }


  @override
  Future<List<PhotoModel>?> getAlbumPhoto(String id) async{
    try {
      final url = Uri.parse("${ApiUrl.getAlbumPhoto}?albumId=$id");
      final response = await _client.get(
        url,
      ).timeout(_timeOutDuration);

      if (response.statusCode == 200) {
        var data = photoModelFromJson(response.body);
       return data;
      }
    } on SocketException catch (_) {
      throw Failure("No internet connection");
    } on HttpException {
      throw Failure("Service not currently available");
    } on TimeoutException catch (_) {
      throw Failure("Poor internet connection");
    }catch(e){
      print(e);
      throw Failure("something went wrong");
    }
    return null;
  }


}