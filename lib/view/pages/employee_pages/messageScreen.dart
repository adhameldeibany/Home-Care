import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/view/pages/employee_pages/employee_message.dart';
import 'package:graduation_project/view_model/bloc/product/employee_cubit.dart';
import '../ChatScreen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  void initState() {
    // TODO: implement initState
    EmployeeCubit.get(context).getUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      body: BlocConsumer<EmployeeCubit, HomecareState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var cubit = EmployeeCubit.get(context);
          return   (state is GetUsersMessageLoading )? Center(child: CircularProgressIndicator(),):
          ListView.builder(itemCount: cubit.usersMessage.length,itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EmployeeMessage(homecareModel: cubit.usersMessage[index],)));
              },
              child: ListTile(

                leading: CircleAvatar(
                  backgroundImage: NetworkImage(cubit.usersMessage[index].photo),
                ),
                title: Text(cubit.usersMessage[index].name),
                subtitle: Text(cubit.usersMessage[index].email),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            );
          },);

        },
      ),
    );
  }
}
