import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatDetailsWidget extends StatefulWidget {
  const ChatDetailsWidget({super.key});

  @override
  State<ChatDetailsWidget> createState() => _ChatDetailsWidgetState();
}

class _ChatDetailsWidgetState extends State<ChatDetailsWidget> {

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
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF0EB0BE),
          automaticallyImplyLeading: false,
          leading: IconButton(
            color: Colors.transparent,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Page Title',
          ),
          actions: [],
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
