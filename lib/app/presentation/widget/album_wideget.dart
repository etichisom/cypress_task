import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cypress/app/data/local/local_database.dart';
import 'package:cypress/app/data/model/album_model.dart';
import 'package:cypress/app/data/repository/album_repository.dart';
import 'package:cypress/app/presentation/bloc/photo_bloc/photo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'loading_list.dart';

// ignore: must_be_immutable
class AlbumWidget extends StatelessWidget {
  final AlbumModel albumModel;
   AlbumWidget(this.albumModel,{Key? key}) : super(key: key);
 final ScrollController controller=ScrollController();
 bool  scroll = true;
 @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 200,
      child: BlocProvider(
          create:(_)=>PhotoBloc(
              albumRepository:RepositoryProvider.of<AlbumRepository>(context),
              localDatabase: RepositoryProvider.of<LocalDatabase>(context),
          )..add(LoadPhotoEvent(albumModel.id.toString())),
        child: Scaffold(
          body: BlocBuilder<PhotoBloc,PhotoState>(
              builder: (context,state){
                if(state is PhotoInitial){
                  return const LoadingList();
                }else if(state is PhotoError) {
                  return const Center(child: Text("Error"));
                }else if(state is PhotoLoaded){
                  controller.addListener(() {
                    if (controller.position.pixels == controller.position.maxScrollExtent) {
                      //scroll list to the  last item
                      controller.position.restoreOffset(0);
                    }
                  });
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: ListView.builder(
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                            itemCount: 10000000,
                            itemBuilder: (context,i){
                              final index = i % state.photoModel.length;
                               var data =state.photoModel[index];
                             var imageLink = data.url;

                               return Padding(
                                 padding: const EdgeInsets.only(left: 10,right: 10),
                                 child: CachedNetworkImage(
                                     height: 150,
                                     width: 200,
                                     fit: BoxFit.cover,
                                     imageUrl: imageLink,
                                      errorWidget: (context, url, error){
                                       print(error);
                                       return Container(
                                         height: 150,
                                         width: 200,
                                         color:Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                         child: const Center(
                                           child: Text("600 X 600",style: TextStyle(
                                             color: Colors.white,
                                             fontWeight: FontWeight.w600
                                           ),),
                                         ),
                                       );
                                      },
                                   placeholder: (context,string){
                                      return Shimmer.fromColors(
                                        baseColor: Colors.red,
                                        highlightColor: Colors.yellow,
                                        child: Container(
                                          height: 150,
                                          width: 200,
                                          color: Colors.white,
                                        ),
                                      );
                                   },
                                 ),
                               );
                            }
                        ))
                      ],
                    ),
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
