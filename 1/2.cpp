#include <fstream>
#include <string>
#include <array>

const std::string input_filename = "input.txt";

std::array<std::string, 10> numbers =
{
  "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"
};

bool get_number_at(const std::string& str, int index, int & digit)
{
  bool found = false;
  if (isdigit(str[index]))
  {
    digit = str[index] - '0';
    found = true;
  }
  else
  {
    for (int i = 0; i < numbers.size(); i++)
    {
      if (str.compare(index, numbers[i].length(), numbers[i]) == 0)
      {
        found = true;
        digit = i;
        break;
      }
    }
  }

  return found;
}

int find_digit(const std::string &str, size_t start, size_t end, int increment)
{
  int digit = 0;

  int index = start;

  do
  {
    if (get_number_at(str, index, digit))
      break;
    index += increment;
  } while (index != end + increment);

  return digit;
}

int main()
{
  std::ifstream input_file(input_filename);
  std::string line;
  int sum = 0;
  while (std::getline(input_file, line))
  {
    int calibration_value = find_digit(line, 0, line.length() - 1, 1) * 10 + find_digit(line, line.length() - 1, 0, -1);
    sum += calibration_value;
  }

  printf("%d\n", sum);
}

