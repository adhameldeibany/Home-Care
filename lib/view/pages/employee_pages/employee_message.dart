import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/code/constants_value.dart';
import 'package:graduation_project/model/user_model.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';
import 'package:graduation_project/view_model/database/local/cache_helper.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../components/message.dart';

class EmployeeMessage extends StatefulWidget {
  EmployeeMessage({Key? key, required this.homecareModel});

  UserModel? homecareModel;

  @override
  State<EmployeeMessage> createState() => _EmployeeMessageState();
}

class _EmployeeMessageState extends State<EmployeeMessage> {
  final fireStore = FirebaseFirestore.instance;
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        print(widget.homecareModel!.id);
        return Scaffold(
          appBar: AppBar(),
          body:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.homecareModel!.id)
                  .collection('messages')
                  .where('homecareID',
                      isEqualTo: CacheHelper.getDataString(key: 'id'))
                  .orderBy('time')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text("no message");
                } else {
                  final messages = snapshot.data!.docs.reversed;
                  List<MessageLine> messageWidgets = [];

                  for (var message in messages) {
                    final messageText = message.get('message');
                    final sender = (message['senderID'] ==
                            CacheHelper.getDataString(key: 'id'))
                        ? message.get('homecareName')
                        : message.get('customerName');
                    messageWidgets.add(
                        MessageLine
                      (
                      type: message['type'],
                      id: message.id,
                      sender: sender,
                      customerID: message['customerId'],
                      homecareID: message['homecareID'],
                      messageText: messageText,
                      isMe: message['senderID'] ==
                          CacheHelper.getDataString(key: 'id'),
                      baseName: message['baseName'],
                      dateTime: message['time'],
                    ));
                  }

                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: messageWidgets,
                    ),
                  );
                }
              },
            ),
            // (cubit.messageList.length>0)? Expanded(
            //   child: ListView.separated(itemBuilder: (context , index){
            //     var message  = cubit.messageList[index];
            //
            //    return MessageLine(sender: message.senderId,messageText: message.text,isMe:message.senderId == CacheHelper.getDataString(key: 'currentUser') );
            //
            //
            //   } ,itemCount: cubit.messageList.length,separatorBuilder: (context , index){
            //     return SizedBox(
            //       height: 15,
            //     );
            //   }, ),
            // ): Center(
            //   child: CircularProgressIndicator(),
            // ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        labelText: "Enter Message",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                CircleAvatar(
                    backgroundColor: buttonColor,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        cubit.sendMessage(
                            homecareID:
                                CacheHelper.getDataString(key: 'id').toString(),
                            message: messageController.text,
                            homecareName: cubit.userModel!.name,
                            customerId: widget.homecareModel!.id,
                            senderID:
                                CacheHelper.getDataString(key: 'id').toString(),
                            customerName: widget.homecareModel!.name,
                            type: 'text');
                        // cubit.sendMessage(text: cubit.messageController.text , time:DateTime.now().toString() );
                        //
                        messageController.clear();
                      },
                    )),
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                    backgroundColor: buttonColor,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(
                        Icons.file_copy,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        cubit.pickFileMessage(
                            homecareID:
                                CacheHelper.getDataString(key: 'id').toString(),
                            homecareName: cubit.userModel!.name,
                            customerId: widget.homecareModel!.id,
                            customerName: widget.homecareModel!.name,
                            type: 'pdf');

                        //   const oneMegabyte = 1024 * 1024;
                        //   final Uint8List? data = await islandRef.getData(oneMegabyte);
                        //   // Data for "images/island.jpg" is returned, use this as needed.
                        // } on FirebaseException catch (e) {
                        //   // Handle any errors.
                        // }

                        // cubit.sendMessage(text: cubit.messageController.text , time:DateTime.now().toString() );
                        //
                        // cubit.messageController.clear();
                      },
                    )),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ]),
        );
      },
    );
  }
}

Future openFile({required String url, required String fileName}) async {
  final file = await downloadFile(url, fileName);
  if (file == null) {
    return;
  }
  OpenFilex.open(file.path);
}

Future<io.File?> downloadFile(String url, String filName) async {
  final appStorage = await getApplicationDocumentsDirectory();
  final filePath = io.File('${appStorage.path}/$filName');
  final response = await Dio().get(url,
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0));
  final ref = filePath.openSync(mode: io.FileMode.write);
  ref.writeFromSync(response.data);
  await ref.close();
  print("Adham");
  return filePath;
}
