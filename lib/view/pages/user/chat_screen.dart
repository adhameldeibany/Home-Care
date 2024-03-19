import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/code/constants_value.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';
import 'package:graduation_project/view_model/database/local/cache_helper.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../../../model/homecare_model.dart';
import '../../components/message.dart';

class ChatUserScreen extends StatefulWidget {
  ChatUserScreen({Key? key, required this.homecareModel});

  HomecareModel? homecareModel;

  @override
  State<ChatUserScreen> createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
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
                  .where('customerId',
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
                        ? message.get('customerName')
                        : message.get('homecareName');
                    messageWidgets.add(MessageLine(
                      type: message['type'],
                      customerID: message['customerId'],
                      homecareID: message['homecareID'],
                      id: message.id,
                      sender: sender,
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
                          borderSide: BorderSide(
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
                    radius: 25,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        cubit.sendMessage(
                            senderID:
                                CacheHelper.getDataString(key: 'id').toString(),
                            homecareID: widget.homecareModel!.id,
                            message: messageController.text,
                            homecareName: widget.homecareModel!.name,
                            customerId:
                                CacheHelper.getDataString(key: 'id').toString(),
                            customerName: cubit.userModel!.name,
                            type: 'text');
                        // cubit.sendMessage(text: cubit.messageController.text , time:DateTime.now().toString() );
                        //
                        messageController.clear();
                      },
                    )),
                CircleAvatar(
                    backgroundColor: buttonColor,
                    radius: 25,
                    child: IconButton(
                      icon: const Icon(
                        Icons.file_copy,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        cubit.pickFileMessage(
                            homecareID: widget.homecareModel!.id,
                            homecareName: widget.homecareModel!.name,
                            customerId:
                                CacheHelper.getDataString(key: 'id').toString(),
                            customerName: cubit.userModel!.name,
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
                    ))
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
