import 'dart:io';

void main() async {
  print('🚀 Configurando envío a GitHub...\n');

  // 1. Obtener Link del Repositorio
  stdout.write(
    '🔗 Introduce el link del repositorio (ej. https://github.com/usuario/repo.git): ',
  );
  String? repoLink = stdin.readLineSync();
  if (repoLink == null || repoLink.isEmpty) {
    print('❌ Error: El link del repositorio es obligatorio.');
    return;
  }

  // 2. Obtener Tipo de Commit
  print('\n📝 Tipos de commit:');
  print('   crear: Para cuando subes el proyecto por primera vez');
  print('   actualizar: Para cuando haces cambios en el proyecto');
  stdout.write('\n🛠️  Tipo de commit (crear/actualizar): ');
  String? type = stdin.readLineSync();
  if (type == null || type.isEmpty) type = 'crear';

  // 3. Obtener Mensaje de Commit
  stdout.write('💬 Mensaje del commit: ');
  String? message = stdin.readLineSync();
  if (message == null || message.isEmpty) {
    print('❌ Error: El mensaje de commit es obligatorio.');
    return;
  }

  String finalCommitMessage = '[$type]: $message';

  try {
    print('\n📦 Iniciando comandos de Git...');

    // Verificar si ya existe .git
    if (!Directory('.git').existsSync()) {
      await runCommand('git', ['init']);
    }

    await runCommand('git', ['add', '.']);

    await runCommand('git', ['commit', '-m', finalCommitMessage]);

    // Manejar el remote
    await Process.run('git', ['remote', 'remove', 'origin']);
    await runCommand('git', ['remote', 'add', 'origin', repoLink]);

    print('📤 Subiendo a GitHub...');
    await runCommand('git', ['push', '-u', 'origin', 'main']);

    print('\n✅ ¡Proyecto enviado con éxito a $repoLink!');
  } catch (e) {
    if (e.toString().contains('403')) {
      print('\n🚫 ERROR DE PERMISOS (403):');
      print(
        'Tu cuenta de GitHub actual no tiene permiso para subir a este repositorio.',
      );
      print('\n💡 SOLUCIÓN RECOMENDADA:');
      print('1. Ve al "Administrador de credenciales" en Windows.');
      print('2. Elimina las credenciales de "git:https://github.com".');
      print('3. Vuelve a ejecutar este script.');
    } else {
      print('\n❌ Ocurrió un error durante el proceso: $e');
    }
  }
}

Future<void> runCommand(String executable, List<String> arguments) async {
  print('   > Ejecutando: $executable ${arguments.join(' ')}');
  var result = await Process.run(executable, arguments);

  if (result.exitCode != 0) {
    // Si el error es "nothing to commit", lo ignoramos y seguimos
    if (result.stdout.toString().contains('nothing to commit') ||
        result.stderr.toString().contains('nothing to commit')) {
      print('   ℹ️  Sin cambios nuevos para commit, continuando...');
      return;
    }

    // Si falla main, intentar con master (por compatibilidad)
    if (arguments.contains('main') &&
        result.stderr.toString().contains('main')) {
      print('   ⚠️  Fallo rama "main", intentando con "master"...');
      var retry = await Process.run(executable, [
        'push',
        '-u',
        'origin',
        'master',
      ]);
      if (retry.exitCode == 0) return;
    }
    throw Exception(
      'Comando fallido (${result.exitCode}):\n${result.stderr}${result.stdout}',
    );
  }
}
