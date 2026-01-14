import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // si lo usas en algún texto
import '../styles/color_templates.dart';
import 'package:provider/provider.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});
  static String routeName = 'home_page';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late final templateColors colors;

  @override
  void initState() {
    super.initState();
    // Si necesitas inicializar colors aquí (ej: Provider)
    // colors = Provider.of<templateColors>(context, listen: false);
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
      child: NestedScrollView(  // ← Aquí va el contenido directamente (sin Scaffold)
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: false,
            floating: true,
            snap: false,
            backgroundColor: const Color(0xFF0EB0BE),
            automaticallyImplyLeading: false,
            title: const Align(
              alignment: AlignmentDirectional(0, 0),
              child: Text(
                'Mezclador',
                style: TextStyle(color: Colors.white), // opcional: para que el título se vea bien
              ),
            ),
            centerTitle: false,
            elevation: 3,
          ),
        ],
        body: Builder(
          builder: (context) {
            return SafeArea(
              top: false,
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: const [], // Aquí van tus widgets de home (ej: cards, sliders, etc.)
                      ),
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