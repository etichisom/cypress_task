part of 'album_bloc.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();
}

class AlbumInitial extends AlbumState {
  @override
  List<Object> get props => [];
}

class AlbumLoadedState extends AlbumState{
  final List<AlbumModel> albums;

  const AlbumLoadedState(this.albums);

  @override
  List<Object?> get props => [albums];

}


class ErrorState extends AlbumState{
  final String message;

  const ErrorState(this.message);

  @override
  List<Object?> get props => [];

}
