// Función que imprime la ayuda
import 'const.dart';

void printHelp() {
  print(
      '${App.colorBlue}Help information:${App.colorReset}\n------------------');
  print('  <number> - number of the file or directory you want to open.');
  print('  "0" - to go up one level in the directory tree.');
  print('  "h" - to display this help information.');
  print('  "d <number>" - to delete a file or directory.');
  print('  "d <number>-<number>" - to delete a range of files.');
  print('  "r <number>" - to rename a file or directory.');
  print('  "nd <name>" - to create a new directory.');
  print('  "nf <name>" - to create a new file.');
  print('  "s <number>" - to select a file or directory.');
  print('  "s <number>-<number>" - to select a range of files.');
  print('  "." - to show the hidden files.');
  print('  "q" - to quit the program.');
  print('');
  print('${App.colorBlue}Press Enter to continue...${App.colorReset}');
}
