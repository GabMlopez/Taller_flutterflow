import 'package:flutter/material.dart';
import 'package:flutterflow_taller/Data/dataServices/chat_service.dart';
import 'package:go_router/go_router.dart';

import '../Data/entities/group_chat.dart';


class ChatPageWidget extends StatefulWidget {
  const ChatPageWidget({super.key});

  @override
  State<ChatPageWidget> createState() => _ChatPageWidgetState();
}

class _ChatPageWidgetState extends State<ChatPageWidget> {
  ChatService _chatService = ChatService();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: false,
            floating: true,
            backgroundColor: const Color(0xFF0EB0BE),
            automaticallyImplyLeading: false,
            title: const Align(
              alignment: AlignmentDirectional(0, 0),
              child: Text('Chats de Proyectos'),
            ),
            centerTitle: false,
            elevation: 3,
          )
        ],
        body: Builder(
          builder: (context) {
            return SafeArea(
              top: false,
              child: StreamBuilder(stream: _chatService.getChats(),
                  builder: (context, snapshot){

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No hay chats'));
                    }
                    if(snapshot.hasData)
                    {
                      return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index)
                          {
                            return Card(
                                child: ListTile(
                                    title: Text(snapshot.data![index].name),
                                    subtitle: Text("${snapshot.data![index].getMemberName(snapshot.data![index].lastMessageSender)}: ${snapshot.data![index].lastMessage}"),
                                    trailing: Text((snapshot.data![index].lastMessageTimestamp != "") ? snapshot.data![index].lastMessageTimestamp.toString().substring(11, 16) : " : "),
                                    onTap: () {
                                      GroupChat chat = snapshot.data![index];
                                      context.push(
                                        '/chat/messages',
                                        extra: chat,
                                      );
                                    }
                                ));
                          });
                    }
                    else
                    {
                      return CircularProgressIndicator();
                    }
                  }
              ),
            );
          },
        ),
      ),
    );
  }
}
