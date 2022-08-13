
import 'package:cypress/app/data/local/local_database.dart';
import 'package:cypress/app/data/model/album_model.dart';
import 'package:cypress/app/data/repository/album_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;
  final LocalDatabase localDatabase;
  AlbumBloc({
    required this.albumRepository,
    required this.localDatabase
  }) : super(AlbumInitial()) {
    on<LoadAlbumEvent>((event, emit)async {
      /**
          Get data from the local database if it exist, if it does not exist if fetch
          data from the internet and store it on the local data base
        **/
      var data = await localDatabase.getAlbum();
      if(data!=null){
        emit(AlbumLoadedState(data));
      }else{
      await loadFromApi(emit);
      }
    });
  }

  Future<void> loadFromApi(Emitter<AlbumState> emit)async {
    try{
      var data = await albumRepository.getAlbum();
      if(data!=null){
        //stores album list on the local  database
        localDatabase.storeAlbum(data);
        emit(AlbumLoadedState(data));
      }
    }catch(e){
      emit(const ErrorState("Something went wrong"));
    }

  }
}
