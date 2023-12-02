#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

const char * input_filename = "input.txt";

const char * numbers[] = 
{
  "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"
};

bool get_number_at(const char * str, int index, int * digit)
{
  bool found = false;
  if (isdigit(str[index]))
  {
    *digit = str[index] - '0';
    found = true;
  }
  else
  {
    for (int i = 0; i < 10; i++)
    {
      if (strncmp(str + index, numbers[i], strlen(numbers[i])) == 0)
      {
        found = true;
        *digit = i;
        break;
      }
    }
  }

  return found;
}

int find_digit(const char *str, size_t start, size_t end, int increment)
{
  int digit = 0;

  int index = start;

  do
  {
    if (get_number_at(str, index, &digit))
      break;
    index += increment;
  } while (index != end + increment);

  return digit;
}

int main()
{
  FILE* input_file = fopen(input_filename, "r");
  char line[1024];
  int sum = 0;
  while (true)
  {
    fgets(line, sizeof(line), input_file);
    if (feof(input_file)) break;
    int calibration_value = find_digit(line, 0, strlen(line) - 1, 1) * 10 + find_digit(line, strlen(line) - 1, 0, -1);
    sum += calibration_value;
  }

  printf("%d\n", sum);
}

