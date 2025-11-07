---
description: Create a new file with content
---

Create a file named $ARGUMENTS.dart in the directory lib/widgets
with the following content: 

import 'package:flutter/material.dart';

class $ARGUMENTS extends StatelessWidget {
  const $ARGUMENTS({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Título'),
      ),
      body: const Center(
        child: Text('Contenido del componente'),
      ),
    );
  }
}
