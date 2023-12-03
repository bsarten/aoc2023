#include <fstream>
#include <string>
#include <list>
#include <regex>
#include <sstream>
#include <cstring>

const std::string input_filename = "input.txt";

struct showing
{
  int red;
  int blue;
  int green;
};

struct game
{
  int id;
  std::list<showing> showings;
};

void add_cube_str(showing& showing, const std::string cube_str)
{
  int num;
  char color[20];
  sscanf(cube_str.c_str(), "%d %s", &num, color);
  if (strcmp(color, "blue") == 0)
  {
    showing.blue = num;
  }
  else if (strcmp(color, "green") == 0)
  {
    showing.green = num;
  }
  else if (strcmp(color, "red") == 0)
  {
    showing.red = num;
  }
}

showing create_showing(const std::string showing_str)
{
  showing new_showing = { 0,0,0 };
  std::stringstream ss(showing_str);
  std::string cube_str;
  while (getline(ss, cube_str, ','))
  {
    add_cube_str(new_showing, cube_str);
  }
  return new_showing;
}

void parse_showings(game& game, const std::string& showings_str)
{
  std::stringstream ss(showings_str);
  std::string showing_str;
  while (getline(ss, showing_str, ';'))
  {
    game.showings.push_back(create_showing(showing_str));
  }
}

int main()
{
  std::ifstream input_file(input_filename);
  std::string line;
  int sum = 0;
  std::list<game> games;
  while (std::getline(input_file, line))
  {
    std::regex rgx_game("^Game ([0-9]+): (.*)$");
    std::smatch match;
    std::regex_search(line, match, rgx_game);
    int game_number = atoi(match[1].str().c_str());
    std::string showings_str = match[2].str();
    game new_game;
    new_game.id = game_number;
    parse_showings(new_game, showings_str);
    games.push_back(new_game);
  }

  int sum_ids = 0;
  int sum_powers = 0;
  for (auto& game : games)
  {
    int max_red = 0;
    int max_blue = 0;
    int max_green = 0;
    for (auto& showing : game.showings)
    {
      max_red = (max_red < showing.red) ? showing.red : max_red;
      max_blue = (max_blue < showing.blue) ? showing.blue : max_blue;
      max_green = (max_green < showing.green) ? showing.green : max_green;
    }

    if (max_red <= 12 && max_green <= 13 && max_blue <= 14)
      sum_ids += game.id;
    sum_powers += max_red * max_blue * max_green;
  }

  printf("%d, %d\n", sum_ids, sum_powers);
}

