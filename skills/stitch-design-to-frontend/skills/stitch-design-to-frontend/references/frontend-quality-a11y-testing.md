# frontend-quality-a11y-testing

## Purpose

Verificar objetivamente que el código frontend generado cumple accesibilidad, responsive, rendimiento, mantenibilidad y pruebas, y guiar revisiones y refactorizaciones sin alterar el comportamiento.

## When to use

- Al finalizar cualquier tarea de las demás Skills.
- Al revisar un pull request o cambio propuesto.
- Al refactorizar componentes o eliminar duplicación.

## When not to use

- Para decidir el diseño visual o funcional (lo definen las otras Skills).
- Para auditorías de seguridad de backend.

## Inputs

- Stack base: `React 18 + TypeScript` con `Vitest` + `@testing-library/react` + `eslint` + `prettier`.
- Lista de archivos modificados y la Skill aplicada.
- Criterios de accesibilidad objetivo: WCAG 2.2 AA.

## Instructions

1. Ejecutar y registrar: lint, formato, comprobación de tipos y pruebas existentes. No dar por terminada una tarea con fallos sin explicarlos.
2. Accesibilidad:
   - Contraste AA en todos los pares de color usados.
   - Foco visible y orden lógico de tabulación.
   - Etiquetas asociadas a controles; `alt` correcto en imágenes; botones de solo icono con nombre accesible.
   - Landmarks, jerarquía de encabezados sin saltos y un `h1` por página.
   - Componentes complejos (tabs, acordeón, carrusel, tooltip, drawer) con roles y atributos ARIA correctos y navegación por teclado.
   - Información no transmitida solo por color (variaciones +/−, errores, estados activos).
   - Respeto de `prefers-reduced-motion`.
3. Responsive: revisar en anchos de móvil, tablet y desktop (y zoom 200%); sin scroll horizontal, sin solapamientos y con áreas táctiles suficientes.
4. Pruebas:
   - Unitarias para utilidades (formato de números, validación, mappers).
   - De componente para estados y accesibilidad básica (roles, nombres, teclado).
   - De flujo para las pantallas críticas: login (envío válido/ inválido), 404 (enlace a home), filtro de fechas del dashboard.
   - Tipo/herramientas según `Vitest` + `@testing-library/react`.
5. Rendimiento: imágenes con tamaño reservado y carga diferida, código dividido por ruta, gráficos/mapa cargados de forma diferida, sin re-renderizados innecesarios evidentes.
6. Revisión de código: comprobar contra las reglas de `frontend-design-system` (sin literales), `frontend-ui-components` (reutilización) y la Skill de pantalla aplicada. Emitir hallazgos clasificados por severidad: bloqueante, importante, sugerencia.
7. Refactorización: preservar el comportamiento, hacer cambios pequeños y verificables, y añadir pruebas antes si faltan.

## Design rules

- Un hallazgo debe indicar archivo, problema, regla incumplida y corrección propuesta.
- Priorizar accesibilidad y regresiones sobre preferencias de estilo.

## Implementation rules

- No desactivar reglas de lint ni pruebas para "hacer pasar" un cambio sin justificarlo por escrito.
- No añadir dependencias de testing o a11y sin comprobar antes las existentes.
- Las pruebas no dependen de textos frágiles ni de implementación interna: consultar por rol y nombre accesible.
- Mantener los cambios de refactorización separados de los cambios funcionales.

## Validation

- Lint, tipos y pruebas en verde (o fallos documentados).
- Checklist de accesibilidad completado sin incumplimientos bloqueantes.
- Ausencia de duplicación evidente y de literales visuales.
- Informe final con: comprobaciones realizadas, hallazgos y supuestos abiertos.

## Constraints

- No declarar cumplimiento de WCAG sin haber comprobado los criterios listados; indicar lo que no se pudo verificar (por ejemplo, pruebas con lector de pantalla real).
- No modificar el alcance funcional durante la revisión.

## Examples

- Hallazgo: "`DeltaBadge` distingue positivo/negativo solo por color → añadir signo/icono (importante)".
- Prueba: "Al enviar el login vacío se enfoca el campo email y aparece un mensaje de error asociado".