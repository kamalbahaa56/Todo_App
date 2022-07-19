import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/pages/archived_screen.dart';
import 'package:todoapp/pages/done_screen.dart';
import 'package:todoapp/pages/tasks_screen.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

import '../shared/componants/constans.dart';
import '../widgets/custum_formfield.dart';

class HomeScreen extends StatelessWidget {
  
  var ScaffouldKey = GlobalKey<ScaffoldState>();
  var FormKey = GlobalKey<FormState>();
  var TitleConroller = TextEditingController();
  var TimeConroller = TextEditingController();
  var DateContorller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..CreateDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if(state is AppInsertDataBaseState){
            Navigator.pop(context);
          }
          // TODO: implement listener
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: ScaffouldKey,
            appBar: AppBar(
              title: Text(cubit.Titles[cubit.Currentindex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isbotmSheetShow) {
                  if (FormKey.currentState!.validate()) {
                    cubit.insertTODataBase(title: TitleConroller.text, time: TimeConroller.text, date: DateContorller.text);
                    TitleConroller.clear();
                    TimeConroller.clear();
                    DateContorller.clear();
                  }
                } else {
                  ScaffouldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: FormKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Title Filed
                                CustomFormFiled(
                                    onTap: () {
                                      print('Title printed');
                                    },
                                    Controller: TitleConroller,
                                    type: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty || value == null) {
                                        return 'Must not be Empty';
                                      }
                                    },
                                    Lable: 'Task Title',
                                    PreFixIcon: Icons.title),
                                const SizedBox(
                                  height: 20,
                                ),
                                // Time Filed
                                CustomFormFiled(
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        return TimeConroller.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    Controller: TimeConroller,
                                    type: TextInputType.datetime,
                                    validator: (value) {
                                      if (value!.isEmpty || value == null) {
                                        return 'Must not be Empty';
                                      }
                                    },
                                    Lable: 'Task Time',
                                    PreFixIcon: Icons.watch_later_outlined),
                                const SizedBox(
                                  height: 20,
                                ),
                                // Date Filed
                                CustomFormFiled(
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2022-12-30'),
                                      ).then((value) {
                                        print(
                                            DateFormat.yMMMd().format(value!));
                                        DateContorller.text =
                                            DateFormat.yMMMd().format(value);
                                      });
                                    },
                                    Controller: DateContorller,
                                    type: TextInputType.datetime,
                                    validator: (value) {
                                      if (value!.isEmpty || value == null) {
                                        return 'Must not be Empty';
                                      }
                                    },
                                    Lable: 'Task Date',
                                    PreFixIcon: Icons.date_range),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                        cubit.ChangeBottomnSheetState(IsShow: false, icon: Icons.edit);
                  });
                  cubit.ChangeBottomnSheetState(IsShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.FabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
                onTap: (index) {
                  cubit.ChangeIndex(index);
                },
                currentIndex:cubit.Currentindex,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'New Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done), label: 'Done Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: 'Archive Tasks'),
                ]),
            body: ConditionalBuilder(
              condition: state is! AppGetDataBaseLodingState,
              builder: (context) => cubit.screens[cubit.Currentindex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }

 
}
