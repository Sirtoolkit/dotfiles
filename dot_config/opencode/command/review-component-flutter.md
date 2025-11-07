---
description: Review widget
---

Review the widget in lib/widgets/$ARGUMENTS.dart.
Check for performance issues and suggest improvements.
Análisis de Rendimiento

- Uso de const constructors: Asegúrate de que todos los widgets inmutables usen const para evitar reconstrucciones innecesarias.
- Evitar reconstrucciones excesivas: Si el widget cambia frecuentemente, considera usar StatefulWidget solo cuando sea necesario; de lo contrario, optimiza con const y memo equivalents en Flutter (como const widgets).
- Árbol de widgets: Mantén el árbol de widgets lo más plano posible para reducir el overhead de renderizado.
- Llaves (Keys): Usa Key apropiadamente para widgets que cambian de posición en listas, pero evita keys innecesarios.
  Sugerencias de Mejora
- Convierte a StatelessWidget si no maneja estado interno.
- Usa const en constructores de widgets hijos siempre que sea posible.
- Para listas grandes, considera ListView.builder en lugar de ListView con todos los items.
- Monitorea con Flutter DevTools para identificar bottlenecks.
