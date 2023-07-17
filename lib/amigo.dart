import 'dart:io';

import 'const.dart';
import 'help.dart';

/// [EN]: Asynchronous function to run the file explorer.
/// [ES]: Función asincrónica para ejecutar el explorador de archivos.
Future<void> runFileExplorer() async {
  String?
      newFileName; // Variable to store the name of a new file to be created.
  bool showHidden = false; // Flag to determine whether to show hidden files.

  while (true) {
    // Infinite loop to keep the file explorer running.

    /// [EN]: Default value for the number of columns in the terminal.
    /// [ES]: Valor predeterminado para el número de columnas en el terminal.
    int columns = 80;

    try {
      // Try to get the number of columns in the terminal.
      columns = stdout.terminalColumns;
    } catch (e) {
      /// [EN]: Handles the exception when the terminal size cannot be obtained.
      /// [ES]: Maneja la excepción cuando no se puede obtener el tamaño del terminal.
      print('${App.colorRed}Error getting terminal size: ${App.colorReset} $e');
    }

    // Get a list of files and directories in the current working directory.
    final files = Directory.current.listSync();

    // If the 'showHidden' flag is false, remove hidden files from the list.
    if (!showHidden) {
      files.removeWhere((entity) =>
          entity.path.split(Platform.pathSeparator).last.startsWith('.'));
    }

    // Extract the names of the files and directories from their paths.
    final names =
        files.map((entity) => entity.path.split(Platform.pathSeparator).last);

    // Calculate the maximum length of the file/directory names to format the output.
    final maxLength = names.fold(0,
        (maxLength, name) => maxLength > name.length ? maxLength : name.length);
    final columnCount = columns ~/
        (maxLength + 5); // Calculate the number of columns for the output.

    // Sort the names of the files and directories alphabetically.
    final sortedNames = names.toList()..sort();
    final rows = columnCount > 0
        ? (sortedNames.length / columnCount).ceil()
        : 0; // Calculate the number of rows for the output.

    stdout.writeln(
      '\n${App.colorYellow}${App.appName} - ${App.appVersion}${App.colorReset}',
    );
    stdout.writeln('-' * columns);
    stdout.write(
      '${App.colorGreen}0.${App.colorReset} ',
    );

    /// [EN]: Displays the parent directory.
    /// [ES]: Muestra el directorio padre.
    stdout.write('${App.colorBlue}..${App.colorReset}\n');

    // Print the files and directories in columns and rows.
    for (var rowIndex = 0; rowIndex < rows; rowIndex++) {
      for (var columnIndex = 0; columnIndex < columnCount; columnIndex++) {
        final index = rowIndex + columnIndex * rows;
        if (index < sortedNames.length) {
          final name = sortedNames[index];
          final entity = files.firstWhere((e) => e.path.endsWith(name));
          final stat = entity.statSync();
          final isDirectory = stat.type == FileSystemEntityType.directory;

          stdout.write('${App.colorGreen}${index + 1}.${App.colorReset} ');

          // If it's a directory, display the name in blue color.
          if (isDirectory) {
            /// [EN]: Blue color for directories.
            /// [ES]: Color azul para directorios.
            stdout.write('${App.colorBlue}$name${App.colorReset}');
          } else {
            stdout.write(name);
          }

          if (columnIndex < columnCount - 1) {
            // Align the columns with spaces.
            stdout.write(' ' * (maxLength - name.length + 2));
          }
        }
      }
      stdout.writeln();
    }

    stdout.writeln('-' * columns);
    stdout.writeln(
        '${App.colorMagenta}${Directory.current.path} ${App.colorReset}');

    stdout.write('(h for help): ${App.colorGreen}\$ ${App.colorReset}');
    final input = stdin.readLineSync(); // Read user input from the terminal.

    if (input != null) {
      final isQuit = input.toLowerCase() == 'q';
      final isHelp = input.toLowerCase() == 'h';
      final isNewFile = input.toLowerCase().startsWith('nf ');
      final isDelete = input.toLowerCase().startsWith('d ');
      final isShowHidden = input.toLowerCase() == '.';

      if (isQuit) {
        break; // Exit the loop and end the file explorer.
      } else if (isHelp) {
        printHelp(); // Call the 'printHelp()' function to display the help information.
        stdin
            .readLineSync(); // Wait for user input to continue after displaying help.
        continue; // Continue to the next iteration of the loop.
      } else if (isNewFile) {
        /// [EN]: Creates a new file.
        /// [ES]: Crea un nuevo archivo.
        ///
        /// [EN]: The file name is obtained without 'nf '.
        /// [ES]: Se obtiene el nombre del archivo sin 'nf '.
        final fileName = input.substring(3);
        if (fileName.isEmpty) {
          print('${App.colorRed}No file name specified${App.colorReset}');
          continue;
        }
        newFileName = fileName; // Store the new file name.
        final file = File(newFileName);
        if (!await file.exists()) {
          await file.create(); // Create the new file.
          print('New file created: ${file.path}');
        } else {
          print(
              '${App.colorRed}The file already exists: ${App.colorReset} ${file.path}');
        }
        newFileName = null; // Reset the new file name for the next iteration.
        continue; // Continue to the next iteration of the loop.
      } else if (isShowHidden) {
        showHidden = !showHidden; // Toggle the 'showHidden' flag.
        continue; // Continue to the next iteration of the loop.
      } else if (isDelete) {
        /// [EN]: Deletes a file or directory.
        /// [ES]: Elimina un archivo o directorio.
        ///
        /// [EN]: The file name is obtained without 'd '.
        /// [ES]: Se obtiene el nombre del archivo sin 'd '.
        final fileName = input.substring(2);
        if (fileName.isEmpty) {
          print(
              '${App.colorRed}No file or directory number specified${App.colorReset}');
          continue;
        }
        final selectedIndex = int.tryParse(fileName) ?? -1;

        if (selectedIndex > 0 && selectedIndex <= sortedNames.length) {
          final selectedName = sortedNames[selectedIndex - 1];
          final selectedEntity =
              files.firstWhere((e) => e.path.endsWith(selectedName));

          if (selectedEntity is File) {
            final filePath = selectedEntity.path;
            if (await File(filePath).exists()) {
              await selectedEntity.delete(); // Delete the selected file.
              print('File deleted: $filePath');
            } else {
              print(
                  '${App.colorRed}The file does not exist: ${App.colorReset} $filePath');
            }
          } else if (selectedEntity is Directory) {
            final directoryPath = selectedEntity.path;
            if (await Directory(directoryPath).exists()) {
              await selectedEntity.delete(
                  recursive:
                      true); // Delete the selected directory and its contents.
              print('Directory deleted: $directoryPath');
            } else {
              print(
                  '${App.colorRed}The directory does not exist: ${App.colorReset} $directoryPath');
            }
          }
        } else {
          print('${App.colorRed}Invalid selection${App.colorReset}');
        }

        continue; // Continue to the next iteration of the loop.
      }

      // If the input is a number, check if it corresponds to a valid file/directory.
      final selectedIndex = int.tryParse(input) ?? -1;
      if (selectedIndex == 0) {
        final parent = Directory.current.parent;
        Directory.current = parent; // Navigate to the parent directory.
      } else if (selectedIndex > 0 && selectedIndex <= sortedNames.length) {
        final selectedName = sortedNames[selectedIndex - 1];
        final selectedEntity =
            files.firstWhere((e) => e.path.endsWith(selectedName));
        if (selectedEntity is File) {
          final filePath = selectedEntity.path;
          if (await File(filePath).exists()) {
            await Process.run('open', [
              filePath
            ]); // Open the selected file using the system default program.
            print('Opening file: $filePath');
          } else {
            print(
                '${App.colorRed}The file does not exist: ${App.colorReset} $filePath');
          }
        } else if (selectedEntity is Directory) {
          Directory.current =
              selectedEntity; // Navigate to the selected directory.
        }
      } else {
        print('${App.colorRed}Invalid selection${App.colorReset}');
      }
    }
  }
}
