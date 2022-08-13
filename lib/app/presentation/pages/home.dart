import 'package:cypress/app/data/local/local_database.dart';
import 'package:cypress/app/data/model/album_model.dart';
import 'package:cypress/app/data/repository/album_repository.dart';
import 'package:cypress/app/presentation/bloc/album/album_bloc.dart';
import 'package:cypress/app/presentation/widget/album_wideget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
   Home({Key? key}) : super(key: key);
  final ScrollController controller=ScrollController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(context)=>AlbumBloc(
          albumRepository: RepositoryProvider.of<AlbumRepository>(context),
          localDatabase: RepositoryProvider.of<LocalDatabase>(context)
      )..add(LoadAlbumEvent()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title:const Text("Album",style: TextStyle(color: Colors.black),),
        ),
        body: SafeArea(
          child: BlocBuilder<AlbumBloc, AlbumState>(
              builder: (context,state){
                if(state is AlbumInitial){
                  return const Center(child: CircularProgressIndicator());
                }else if(state is AlbumLoadedState){
                  controller.addListener(() {
                    if (controller.position.pixels == controller.position.maxScrollExtent) {
                      //scroll list to the  last item
                      controller.position.restoreOffset(0);
                    }
                  });
                  return ListView.separated(
                    controller: controller,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount:state.albums.length ,
                    itemBuilder: (context,index){
                      AlbumModel data = state.albums[index];
                      return ExpansionTile(
                        title: Text(data.title),
                        children: [AlbumWidget(data)],
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                    return const Padding(
                      padding:  EdgeInsets.only(left: 10,right: 10),
                      child:  Divider(thickness: 0.2,color: Colors.black,),
                    );
                  },
                  );
                }
                return Container();
              }
          ),
        ),
      ),
    );
  }
}
