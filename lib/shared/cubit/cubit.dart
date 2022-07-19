import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/shared/cubit/states.dart';

import '../../pages/archived_screen.dart';
import '../../pages/done_screen.dart';
import '../../pages/tasks_screen.dart';
import '../componants/constans.dart';

class AppCubit extends Cubit <AppStates> {
  AppCubit() : super(AppInitioalStates());
  static AppCubit get(context)=>BlocProvider.of(context);
   
   int Currentindex = 0;

  List<Widget> screens = [
    TaskScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];
  List<String> Titles = [
   'New Tasks' , 
   'Done Tasks', 
   'Archived Tasks'
  ];
  Database? database;
     List<Map>Newtasks =[];
      List<Map>Donetasks =[];
       List<Map>Archivetasks =[];
     bool isbotmSheetShow = false;
  IconData FabIcon = Icons.edit;
  void ChangeIndex(int index){
    Currentindex = index ;
    emit(AppChangeBtmnNavBarState());
  }
   Future CreateDataBase()  {
  return  openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
      // await db.execute(  'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
      // id intger
      // title Strig
      // data string
      // time stirng
      // status string
      print('database is created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)')
          .then((value) {
        print('table is created');
      }).catchError((error) {
        print('error when created teable ${error.toString()}');
      });
    }, onOpen: (database) {
    getDataFormDatabase(database);
      print('database is opened');
    },
    ).then((value){
      database=value ;
      emit(AppCreateDataBaseState());
    });
  }

   insertTODataBase({
    required String title,
    required String time,
    required String date,
  }) async {
  await  database!.transaction((txn) {
 return      txn.rawInsert(
              'INSERT INTO tasks(title, time, date, status) VALUES("$title", "$time", "$date", "new")')
          .then((value) {
        print('$value inserted  Sucssefuly ');
        emit(AppInsertDataBaseState());
         getDataFormDatabase(database!);
      }).catchError((error) {
        print('error when Inserted New Record ${error.toString()}');
      });
    });
  }
  void UpdateData({
    required String  ,
    required int id ,
  })async{
    await database!.rawUpdate(
    'UPDATE tasks SET status = ? WHERE id = ?',
    ['$String', '$id',],
    ).then((value){
      getDataFormDatabase(database!);
      emit(AppUpdateDataBaseState());
    });
  }
  void deleteData({
    required int id ,
  })async{
    await database!.rawDelete(
    'DELETE FROM tasks WHERE id = ?',
    ['$id',],
    ).then((value){
      getDataFormDatabase(database!);
      emit(AppDeleteDataBaseState());
    });
  }

  void getDataFormDatabase(Database database)  {
    Newtasks = [];
    Donetasks = [];
    Archivetasks = [];
    emit(AppGetDataBaseLodingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
       value.forEach((element) {
         print(element['status']);
         if(element['status']=='new')
          Newtasks.add(element);
          else if (element['status']=='done')
          Donetasks.add(element);
         else Archivetasks.add(element);
       },);
       emit(AppGetDataBaseState());
     });;
  }

  void ChangeBottomnSheetState({required bool IsShow ,required IconData icon }){
    isbotmSheetShow = IsShow ;
    FabIcon = icon ;
    emit(AppChangeBtmnSheetState());
  }
}