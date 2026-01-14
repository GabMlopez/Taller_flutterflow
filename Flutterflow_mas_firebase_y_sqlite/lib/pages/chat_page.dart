import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class ChatPageWidget extends StatefulWidget {
  const ChatPageWidget({super.key});

  @override
  State<ChatPageWidget> createState() => _ChatPageWidgetState();
}

class _ChatPageWidgetState extends State<ChatPageWidget> {

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
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: const [], // tus chats aquí
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
