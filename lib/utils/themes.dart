import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class HockeyThemes {
  List<AppTheme> themes = [];

  void _createThemes() {
    themes = [
      AppTheme(
          id: 'anaheim_ducks',
          data: ThemeData(
              primaryColor: Color(0xffb5985a),
              accentColor: Color(0xfff95602),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff111111))),
          description: 'Anaheim Ducks'),
      AppTheme(
          id: 'arizona_coyotes',
          data: ThemeData(
              primaryColor: Color(0xff8c2633),
              accentColor: Color(0xffe2d6b5),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff000000))),
          description: 'Arizona Coyotes'),
      AppTheme(
          id: 'boston_bruins',
          data: ThemeData(
              primaryColor: Color(0xfffcb514),
              accentColor: Color(0xfffcb514),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff000000))),
          description: 'Boston Bruins'),
      AppTheme(
          id: 'buffalo_sabres',
          data: ThemeData(
              primaryColor: Color(0xff002654),
              accentColor: Color(0xff002654),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xfffcb514))),
          description: 'Buffalo Sabres'),
      AppTheme(
          id: 'calgary_flames',
          data: ThemeData(
              primaryColor: Color(0xffce1126),
              accentColor: Color(0xfff3bc52),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff111111))),
          description: 'Calgary Flames'),
      AppTheme(
          id: 'carolina_hurricanes',
          data: ThemeData(
              primaryColor: Color(0xffcc0000),
              accentColor: Color(0xffa2a9af),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff000000))),
          description: 'Carolina Hurricanes'),
      AppTheme(
          id: 'chicago_blackhawks',
          data: ThemeData(
              primaryColor: Color(0xffce1126),
              accentColor: Color(0xffcc8a00),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff000000))),
          description: 'Chicago BlackHawks'),
      AppTheme(
          id: 'colorado_avalanche',
          data: ThemeData(
              primaryColor: Color(0xff6f263d),
              accentColor: Color(0xffc1c6c8),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff236192))),
          description: 'Colorado Avalanche'),
      AppTheme(
          id: 'columbus_blue_jackets',
          data: ThemeData(
              primaryColor: Color(0xff041e42),
              accentColor: Color(0xffa2aaad),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffc8102e))),
          description: 'Columbus Blue Jackets'),
      AppTheme(
          id: 'dallas_stars',
          data: ThemeData(
              primaryColor: Color(0xff006341),
              accentColor: Color(0xffa2aaad),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff010101))),
          description: 'Dallas Stars'),
      AppTheme(
          id: 'detroit_red_wings',
          data: ThemeData(
              primaryColor: Color(0xffc8102e),
              accentColor: Color(0xffc8102e),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff000000))),
          description: 'Detroit Red Wings'),
      AppTheme(
          id: 'edmonton_oilers',
          data: ThemeData(
              primaryColor: Color(0xfffc4c02),
              accentColor: Color(0xfffc4c02),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff041e42))),
          description: 'Edmonton Oilers'),
      AppTheme(
          id: 'florida_panthers',
          data: ThemeData(
              primaryColor: Color(0xffb9975b),
              accentColor: Color(0xffc8102e),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff041e42))),
          description: 'Florida Panthers'),
      AppTheme(
          id: 'los_angeles_kings',
          data: ThemeData(
              primaryColor: Color(0xff010101),
              accentColor: Color(0xff010101),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffa2aaad))),
          description: 'Los Angeles Kings'),
      AppTheme(
          id: 'minnesota_wild',
          data: ThemeData(
              primaryColor: Color(0xff154734),
              accentColor: Color(0xffeaaa00),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffa6192e))),
          description: 'Minnesota Wild'),
      AppTheme(
          id: 'montreal_canadiens',
          data: ThemeData(
              primaryColor: Color(0xffa6192e),
              accentColor: Color(0xffa6192e),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff001e62))),
          description: 'Montreal Canadiens'),
      AppTheme(
          id: 'nashville_predators',
          data: ThemeData(
              primaryColor: Color(0xffffb81c),
              accentColor: Color(0xffffb81c),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff041e42))),
          description: 'Nashville Predators'),
      AppTheme(
          id: 'new_jersey_devils',
          data: ThemeData(
              primaryColor: Color(0xffc8102e),
              accentColor: Color(0xffc8102e),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff010101))),
          description: 'New Jersey Devils'),
      AppTheme(
          id: 'new_york_islanders',
          data: ThemeData(
              primaryColor: Color(0xfffc4c02),
              accentColor: Color(0xfffc4c02),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff003087))),
          description: 'New York Islanders'),
      AppTheme(
          id: 'new_york_rangers',
          data: ThemeData(
              primaryColor: Color(0xff0033a0),
              accentColor: Color(0xff0033a0),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffc8102e))),
          description: 'New York Rangers'),
      AppTheme(
          id: 'ottawa_senators',
          data: ThemeData(
              primaryColor: Color(0xffc69214),
              accentColor: Color(0xff010101),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffc8102e))),
          description: 'Ottawa Senators'),
      AppTheme(
          id: 'philadelphia_flyers',
          data: ThemeData(
              primaryColor: Color(0xff010101),
              accentColor: Color(0xff010101),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xfffa4616))),
          description: 'Philadelphia Flyers'),
      AppTheme(
          id: 'pittsburgh_penguins',
          data: ThemeData(
              primaryColor: Color(0xffffb81c),
              accentColor: Color(0xffffb81c),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff010101))),
          description: 'Pittsburgh Penguins'),
      AppTheme(
          id: 'san_jose_sharks',
          data: ThemeData(
              primaryColor: Color(0xff006272),
              accentColor: Color(0xffe57200),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff010101))),
          description: 'San Jose Sharks'),
      AppTheme(
          id: 'st_louis_blues',
          data: ThemeData(
              primaryColor: Color(0xff041e42),
              accentColor: Color(0xff002f87),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffffb81c))),
          description: 'St.Louis Blues'),
      AppTheme(
          id: 'tampa_bay_lightning',
          data: ThemeData(
              primaryColor: Color(0xff00205b),
              accentColor: Color(0xffffffff),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff000000))),
          description: 'Tampa bay Lighting'),
      AppTheme(
          id: 'toronto_maple_leafs',
          data: ThemeData(
              primaryColor: Color(0xff00205b),
              accentColor: Color(0xffffffff),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff000000))),
          description: 'Toronto Maple Leafs'),
      AppTheme(
          id: 'vancouver_canucks',
          data: ThemeData(
              primaryColor: Color(0xff041c2c),
              accentColor: Color(0xff00205b),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff97999b))),
          description: 'Vancouver Canucks'),
      AppTheme(
          id: 'vegas_golden_knights',
          data: ThemeData(
              primaryColor: Color(0xffb9975b),
              accentColor: Color(0xffb9975b),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff333f48))),
          description: 'Vegas Golden Knights'),
      AppTheme(
          id: 'washington_capitals',
          data: ThemeData(
              primaryColor: Color(0xffc8102e),
              accentColor: Color(0xffc8102e),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xff041e42))),
          description: 'Washington Capitals'),
      AppTheme(
          id: 'winnipeg_jets',
          data: ThemeData(
              primaryColor: Color(0xff041e42),
              accentColor: Color(0xffa2aaad),
              scaffoldBackgroundColor: Color(0xffffffff),
              floatingActionButtonTheme:
                  FloatingActionButtonThemeData(foregroundColor: Color(0xffa6192e))),
          description: 'Winnipeg Jets'),
    ];
  }

  List<AppTheme> getThemes() {
    _createThemes();
    return themes;
  }
}
