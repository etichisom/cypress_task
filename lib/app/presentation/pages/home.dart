import 'package:cypress/app/data/local/local_database.dart';
import 'package:cypress/app/data/model/album_model.dart';
import 'package:cypress/app/data/repository/album_repository.dart';
import 'package:cypress/app/presentation/bloc/album/album_bloc.dart';
import 'package:cypress/app/presentation/widget/album_wideget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
   Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   final ScrollController controller=ScrollController();
  bool reversed = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create:(context)=>AlbumBloc(
            albumRepository: RepositoryProvider.of<AlbumRepository>(context),
            localDatabase: RepositoryProvider.of<LocalDatabase>(context)
        )..add(LoadAlbumEvent()),
      child: Scaffold(
        floatingActionButton:FloatingActionButton(
          child: const Icon(Icons.arrow_upward,color: Colors.white,),
          onPressed: (){
            controller.animateTo(
                controller.position.minScrollExtent,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut
            );
          },
        ) ,
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
                  return ListView.separated(
                    controller: controller,
                      reverse: reversed,
                      physics: const BouncingScrollPhysics(),
                      itemCount:state.albums.length ,
                      itemBuilder: (context,index){
                        AlbumModel data = state.albums[index];
                        return ExpansionTile(
                            title: Text("$index  ${data.title}"),
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
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if(reversed){
        if (controller.position.pixels == controller.position.minScrollExtent-100){
          print("yhhh");
          setState(() {
            reversed=!reversed;
          });
        }
      }else{
        if (controller.position.pixels == controller.position.maxScrollExtent-100){
          print("yap");
          setState(() {
            reversed=!reversed;
          });
        }
      }
    //   if (controller.position.pixels == controller.position.maxScrollExtent) {
    //     print('bottom');
    //     // controller.animateTo(
    //     //     controller.position.minScrollExtent,
    //     //     duration: const Duration(milliseconds: 100),
    //     //     curve: Curves.easeOut
    //     // );
    //     setState(() {
    //       reversed=!reversed;
    //     });
    //
    //
    // }
    });
  }
}
