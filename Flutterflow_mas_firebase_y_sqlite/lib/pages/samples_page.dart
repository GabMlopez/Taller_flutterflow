import 'package:flutter/material.dart';
import '../styles/color_templates.dart';

class SamplesPageWidget extends StatefulWidget {
  const SamplesPageWidget({super.key});

  @override
  State<SamplesPageWidget> createState() => _SamplesPageWidgetState();
}

class _SamplesPageWidgetState extends State<SamplesPageWidget> {
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
      child: NestedScrollView(  // Usa NestedScrollView para consistencia con tus otras páginas
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: false,
            floating: true,
            backgroundColor: const Color(0xFF0EB0BE),
            automaticallyImplyLeading: false,
            title: const Align(
              alignment: AlignmentDirectional(0, 0),
              child: Text(
                'Samples',
                style: TextStyle(color: Colors.white),
              ),
            ),
            centerTitle: false,
            elevation: 3,
          ),
        ],
        body: SafeArea(
          top: false,
          child: Center(  // Ejemplo simple – cámbialo por tu contenido real
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 20),
                // Agrega ListView, GridView, botones, etc.
              ],
            ),
          ),
        ),
      ),
    );
  }
}