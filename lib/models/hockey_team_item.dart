import 'package:flutter/material.dart';

class HockeyTeam {
  String path;
  String nameOfTeam;
  HockeyTeam(this.path, this.nameOfTeam);
}

class HockeyTeams {
  List<HockeyTeam> _getHockeyTeams() {
    return [
      HockeyTeam('anaheim_ducks', 'Anaheim Ducks'),
      HockeyTeam('arizona_coyotes', 'Arizona Coyotes'),
      HockeyTeam('boston_bruins', 'Boston Bruins'),
      HockeyTeam('buffalo_sabres', 'Buffalo Sabres'),
      HockeyTeam('calgary_flames', 'Calgary Flames'),
      HockeyTeam('carolina_hurricanes', 'Carolina Hurricanes'),
      HockeyTeam('chicago_blackhawks', 'Chicago Blackhawks'),
      HockeyTeam('colorado_avalanche', 'Colorado Avalanche'),
      HockeyTeam('columbus_blue_jackets', 'Columbus Blue Jackets'),
      HockeyTeam('dallas_stars', 'Dallas Stars'),
      HockeyTeam('detroit_red_wings', 'Detroit Red Wings'),
      HockeyTeam('edmonton_oilers', 'Edmonton Oilers'),
      HockeyTeam('florida_panthers', 'Florida Panthers'),
      HockeyTeam('los_angeles_kings', 'Los Angeles Kings'),
      HockeyTeam('minnesota_wild', 'Minnesota Wild'),
      HockeyTeam('montreal_canadiens', 'Montreal Canadiens'),
      HockeyTeam('nashville_predators', 'Nashville Predators'),
      HockeyTeam('new_jersey_devils', 'New Jersey Devils'),
      HockeyTeam('new_york_islanders', 'New York Islanders'),
      HockeyTeam('new_york_rangers', 'New York Rangers'),
      HockeyTeam('ottawa_senators', 'Ottawa Senators'),
      HockeyTeam('philadelphia_flyers', 'Philadelphia Flyers'),
      HockeyTeam('pittsburgh_penguins', 'Pittsburgh Penguins'),
      HockeyTeam('san_jose_sharks', 'San Jose Sharks'),
      HockeyTeam('st_louis_blues', 'St. Louis Blues'),
      HockeyTeam('tampa_bay_lightning', 'Tampa Bay lightning'),
      HockeyTeam('toronto_maple_leafs', 'Toronto Maple Leafs'),
      HockeyTeam('vancouver_canucks', 'Vancouver Canucks'),
      HockeyTeam('vegas_golden_knights', 'Vegas Golden Knights'),
      HockeyTeam('washington_capitals', 'Washington Capitals'),
      HockeyTeam('winnipeg_jets', 'Winnipeg Jets'),
    ];
  }

  List<DropdownMenuItem<HockeyTeam>> getDropdownMenuItems(BuildContext context) {
    List<DropdownMenuItem<HockeyTeam>> teams = [];
    for (HockeyTeam team in _getHockeyTeams()) {
      teams.add(DropdownMenuItem(
        child: Row(
          children: [
            Image.asset('teams/${team.path}.png', width: 60, height: 60),
            const SizedBox(width: 15),
            Text(team.nameOfTeam, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        value: team,
      ));
    }
    return teams;
  }
}
