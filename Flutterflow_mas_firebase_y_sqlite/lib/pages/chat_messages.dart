import 'package:flutter/material.dart';
import '../Data/dataServices/message_service.dart';
import '../Data/dataServices/chat_service.dart';
import 'package:provider/provider.dart';
import '../Data/entities/group_chat.dart';
import '../Data/entities/chat_user.dart';
import '../Data/entities/message.dart';
import 'provider/user_provider.dart';

class ChatMessages extends StatefulWidget {
  final GroupChat chatInfo;
  const ChatMessages({super.key, required this.chatInfo});

  @override
  State<ChatMessages> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatMessages> {
  bool _enteredChat=false;
  final TextEditingController _messageController = TextEditingController();
  ChatService _chatService = ChatService();
  MessageService _messageService = MessageService();
  TextEditingController _inputControl=TextEditingController();
  late GroupChat chatInfo;
  ChatUser? userData;



  @override
  void initState() {
    super.initState();
    chatInfo = widget.chatInfo;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final providerUser = context.watch<UserProvider>().chat_user;

    if (providerUser != null && !_enteredChat) {
      userData = providerUser;
      _enteredChat = true;
      enterChat();
    }
  }


  void enterChat ()async
  {
    if (userData == null) return;
    await _chatService.addUserToChat(chatInfo.id, userData!.id);
  }

  void _sendMessage() async{
    if (userData == null) return;
    if(_messageController.text.isNotEmpty)
    {
      await _messageService.sendMessage(_messageController.text, chatInfo.id, userData!.id);
      _messageController.clear();
    }
  }

  //Lista de mensajes
  Widget _buildMessageList(){
    if (userData == null) return const SizedBox();
    return StreamBuilder(
        stream: _chatService.getMessages(chatInfo.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay mensajes'));
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return _buildMessageItem(snapshot.data![index]);
                }
            );
          }
          else {
            return CircularProgressIndicator();
          }
        }
          );
  }

  Widget _buildMessageItem(Message messageData){
    bool _currentUserMessage = messageData.user == userData!.id;
    var alignment = (_currentUserMessage) ? Alignment.centerRight : Alignment.centerLeft;
    String displayName = (_currentUserMessage) ? "Tú" : chatInfo.getMemberName(messageData.user);

    return (
      Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayName, style: TextStyle(
              fontWeight: FontWeight.bold,
            ),),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (_currentUserMessage) ? Colors.lightBlueAccent : Colors.lightGreenAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(messageData.content),
            )
          ],
        ),
      )
    );
  }
  
  Widget _buildMessageInput(){
    return Row(
      children: [
        Expanded(child: TextField(
            controller: _messageController,
            decoration: InputDecoration(

              border: OutlineInputBorder(),
              hintText: 'Escribe un mensaje',
            ))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: (){
            _sendMessage();
            _messageController.clear();
          },
          child: Icon(Icons.send),
        )
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(chatInfo.name),
      ),
      body: Column(
        children : [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ]
      )
    );
  }
}






