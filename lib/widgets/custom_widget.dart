import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/shared/cubit/cubit.dart';

Widget CustumTaskItem (Map model,context) =>Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);
  },
  child:   Padding(
  
        padding: const EdgeInsets.all(20.0),
  
        child: Row(
  
          children: [
  
            CircleAvatar(
  
              radius: 40,
  
              child: Text('${model['time']}'),
  
            ) , 
  
            SizedBox(width: 20,),
  
            Expanded(
  
              child: Column(
  
                crossAxisAlignment: CrossAxisAlignment.start,
  
                mainAxisSize:  MainAxisSize.min,
  
                children: [
  
                  Text('${model['title']}',style: TextStyle(
  
                fontWeight: FontWeight.bold,
  
                fontSize: 16.0
  
              ),) ,
  
              Text('${model['date']}',style: TextStyle(
  
                color: Colors.grey
  
              ),)
  
                ],
  
              ),
  
            ) ,
  
             SizedBox(width: 20,),
  
             IconButton(onPressed: (){
  
              AppCubit.get(context).UpdateData(String: 'done', id: model['id']);
  
             }, icon: Icon(Icons.check_box,color: Colors.amber,)),
  
              IconButton(onPressed: (){
  
                 AppCubit.get(context).UpdateData(String: 'archive', id: model['id']);
  
              }, icon: Icon(Icons.archive,color: Colors.red,)),
  
  
  
          ],
  
        ),
  
  ),
);

Widget TasksBuilder({
  required List<Map> tasks ,
})=>ConditionalBuilder(
          condition:tasks.length>0 , 
          builder: (BuildContext context) {  
           return ListView.separated(
              itemBuilder: (context, index) {
              
                return CustumTaskItem(tasks[index],context);
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: tasks.length);
          }, 
          fallback: (BuildContext context) {  
         return   Center(
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
                children:const [
                  Icon(
                    Icons.menu,size: 100,
                    color: Colors.grey,
                    ),
                  Text(
                    'No Tasks Yet , Please Add Some Tasks',style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    ),
                ],
              ),
         );
          },
         
        );