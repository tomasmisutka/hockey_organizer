import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class HockeyThemes {
  List<AppTheme> themes = [];

  void _createThemes() {
    themes = [
      AppTheme(
          id: 'anahaim_ducks',
          data: ThemeData(
              primaryColor: Color(0xffb5985a),
              accentColor: Color(0xfff95602),
              scaffoldBackgroundColor: Color(0xffa4a9ad),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Colors.white)),
          description: 'anaheim'),
      AppTheme(
          id: 'arizona_coyotes',
          data: ThemeData(
              primaryColor: Color(0xff8c2633),
              accentColor: Color(0xff8c2633),
              scaffoldBackgroundColor: Color(0xffe2d6b5),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff000000))),
          description: 'arizona'),
      AppTheme(
          id: 'boston_bruins',
          data: ThemeData(
              primaryColor: Color(0xfffcb514),
              accentColor: Color(0xfffcb514),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff000000))),
          description: 'boston'),
      AppTheme(
          id: 'buffalo_sabres',
          data: ThemeData(
              primaryColor: Color(0xff002654),
              accentColor: Color(0xfffcb514),
              scaffoldBackgroundColor: Color(0xffadafaa),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffffffff))),
          description: 'buffalo'),
      AppTheme(
          id: 'calgary_flames',
          data: ThemeData(
              primaryColor: Color(0xffce1126),
              accentColor: Color(0xfff3bc52),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff111111))),
          description: 'calgary'),
      AppTheme(
          id: 'carolina_hurricanes',
          data: ThemeData(
              primaryColor: Color(0xffcc0000),
              accentColor: Color(0xff76232F),
              scaffoldBackgroundColor: Color(0xffa2a9af),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff000000))),
          description: 'carolina'),
      AppTheme(
          id: 'chicago_blackhawks',
          data: ThemeData(
              primaryColor: Color(0xffce1126),
              accentColor: Color(0xffffd100),
              scaffoldBackgroundColor: Color(0xffcc8a00),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff001871))),
          description: 'chicago'),
      AppTheme(
          id: 'colorado_avalanche',
          data: ThemeData(
              primaryColor: Color(0xff236192),
              accentColor: Color(0xff6f263d),
              scaffoldBackgroundColor: Color(0xffc1c6c8),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff010101))),
          description: 'colorado'),
      AppTheme(
          id: 'columbus_bluejackets',
          data: ThemeData(
              primaryColor: Color(0xff041e42),
              accentColor: Color(0xffc8102e),
              scaffoldBackgroundColor: Color(0xffa2aaad),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffffffff))),
          description: 'columbus'),
      AppTheme(
          id: 'dallas_stars',
          data: ThemeData(
              primaryColor: Color(0xff006341),
              accentColor: Color(0xff006341),
              scaffoldBackgroundColor: Color(0xff010101),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffa2aaad))),
          description: 'dallas'),
      AppTheme(
          id: 'detroid_redwings',
          data: ThemeData(
              primaryColor: Color(0xffc8102e),
              accentColor: Color(0xffc8102e),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff000000))),
          description: 'detroit'),
      AppTheme(
          id: 'edmonton_oilers',
          data: ThemeData(
              primaryColor: Color(0xfffc4c02),
              accentColor: Color(0xfffc4c02),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff041e42))),
          description: 'edmonton'),
      AppTheme(
          id: 'florida_panthers',
          data: ThemeData(
              primaryColor: Color(0xffc8102e),
              accentColor: Color(0xffb9975b),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff041e42))),
          description: 'florida'),
      AppTheme(
          id: 'los_angeles_kings',
          data: ThemeData(
              primaryColor: Color(0xffa2aaad),
              accentColor: Color(0xffa2aaad),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff010101))),
          description: 'los angeles'),
      AppTheme(
          id: 'minnesota_wild',
          data: ThemeData(
              primaryColor: Color(0xff154734),
              accentColor: Color(0xffeaaa00),
              scaffoldBackgroundColor: Color(0xffddcba4),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffa6192e))),
          description: 'minnesota'),
      AppTheme(
          id: 'montreal_canediens',
          data: ThemeData(
              primaryColor: Color(0xffa6192e),
              accentColor: Color(0xffa6192e),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff001e62))),
          description: 'montreal'),
      AppTheme(
          id: 'nashville_predators',
          data: ThemeData(
              primaryColor: Color(0xffffb81c),
              accentColor: Color(0xffffb81c),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff041e42))),
          description: 'nashville'),
      AppTheme(
          id: 'new_jersey_devils',
          data: ThemeData(
              primaryColor: Color(0xffc8102e),
              accentColor: Color(0xffc8102e),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff010101))),
          description: 'new jersey'),
      AppTheme(
          id: 'new_york_islanders',
          data: ThemeData(
              primaryColor: Color(0xfffc4c02),
              accentColor: Color(0xfffc4c02),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff003087))),
          description: 'new york islanders'),
      AppTheme(
          id: 'new_york_rangers',
          data: ThemeData(
              primaryColor: Color(0xff0033a0),
              accentColor: Color(0xff0033a0),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffc8102e))),
          description: 'new york rangers'),
      AppTheme(
          id: 'ottawa_senators',
          data: ThemeData(
              primaryColor: Color(0xffc8102e),
              accentColor: Color(0xff010101),
              scaffoldBackgroundColor: Color(0xffc69214),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffffffff))),
          description: 'ottawa'),
      AppTheme(
          id: 'philadelphia_flyers',
          data: ThemeData(
              primaryColor: Color(0xfffa4616),
              accentColor: Color(0xfffa4616),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff010101))),
          description: 'philadelphia'),
      AppTheme(
          id: 'pittsburgh_penguins',
          data: ThemeData(
              primaryColor: Color(0xffffb81c),
              accentColor: Color(0xffffb81c),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff010101))),
          description: 'pittsburgh'),
      AppTheme(
          id: 'san_jose_sharks',
          data: ThemeData(
              primaryColor: Color(0xff006272),
              accentColor: Color(0xffe57200),
              scaffoldBackgroundColor: Color(0xff010101),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffffffff))),
          description: 'san jose'),
      AppTheme(
          id: 'st_louis_blues',
          data: ThemeData(
              primaryColor: Color(0xff002f87),
              accentColor: Color(0xffffb81c),
              scaffoldBackgroundColor: Color(0xffa2aaad),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff041e42))),
          description: 'st louis'),
      AppTheme(
          id: 'tampa_bay_lighting',
          data: ThemeData(
              primaryColor: Color(0xffffffff),
              accentColor: Color(0xffffffff),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff00205b))),
          description: 'tampa bay'),
      AppTheme(
          id: 'torronto_mapleleafs',
          data: ThemeData(
              primaryColor: Color(0xffffffff),
              accentColor: Color(0xffffffff),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff00205b))),
          description: 'torronto'),
      AppTheme(
          id: 'vancouver_canucks',
          data: ThemeData(
              primaryColor: Color(0xff041c2c),
              accentColor: Color(0xff041c2c),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff97999b))),
          description: 'vancouver'),
      AppTheme(
          id: 'vegas_goldenknights',
          data: ThemeData(
              primaryColor: Color(0xffb9975b),
              accentColor: Color(0xffb9975b),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff333f48))),
          description: 'vegas'),
      AppTheme(
          id: 'washington_capitals',
          data: ThemeData(
              primaryColor: Color(0xffc8102e),
              accentColor: Color(0xffc8102e),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff041e42))),
          description: 'washington'),
      AppTheme(
          id: 'winnipeg_jets',
          data: ThemeData(
              primaryColor: Color(0xff041e42),
              accentColor: Color(0xffa6192e),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffa2aaad))),
          description: 'winnipeg'),
    ];
  }

  List<AppTheme> getThemes() {
    _createThemes();
    return themes;
  }
}
