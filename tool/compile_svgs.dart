import 'dart:io';

void main() {
  for (var source in Directory('assets/svg')
      .listSync()
      .where((f) => f.path.endsWith('.svg'))) {
    var destination = 'assets/optimized/${source.uri.pathSegments.last}.vec';

    var result = Process.runSync(Platform.resolvedExecutable, [
      'run',
      'vector_graphics_compiler',
      '-i',
      source.absolute.path,
      '-o',
      destination,
    ]);
    if (result.exitCode != 0) {
      throw Exception(
          'Fail to optimize svg: ${result.stderr}\n${result.stdout}');
    } else {
      print('Converted ${source.path}');
    }
  }
}
