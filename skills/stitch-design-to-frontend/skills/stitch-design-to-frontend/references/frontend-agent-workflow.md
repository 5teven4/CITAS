# frontend-agent-workflow

## Purpose

Estandarizar cómo los agentes de IA (GitHub Copilot en VS Code y Codex) aplican las Skills de frontend: orden de lectura, alcance de cambios, verificación y reporte.

## When to use

- Al iniciar cualquier tarea de desarrollo frontend asistida por IA.
- Al configurar un repositorio para trabajar con Copilot o Codex.

## When not to use

- Para tareas que no son de frontend.
- Como sustituto de las reglas técnicas de las demás Skills.

## Inputs

- Descripción de la tarea.
- Archivos del proyecto (estructura, `package.json` o equivalente, configuración de tema).
- Ubicación de las Skills en el repositorio: `./` (raíz del proyecto).
- Instrucciones de repositorio de la herramienta: `.github/copilot-instructions.md` para Copilot y `.github/AGENTS.md` para Codex.

## Instructions

1. **Explorar antes de escribir**: identificar el stack real del repositorio: `React 18 + TypeScript`, `Tailwind CSS`, `React Router`, `Context/useReducer`, `TanStack Query` o `fetch` y `Vitest + Testing Library`. Si no se pueden inferir, preguntar por los datos imprescindibles o documentar el supuesto.
2. **Seleccionar Skills** según la tarea y aplicarlas en este orden: `frontend-design-system` → `frontend-ui-components` → `frontend-layout-navigation` → Skill de pantalla (`frontend-landing-sections`, `frontend-auth-forms` o `frontend-dashboard-data`) → `frontend-ui-states-feedback` → `frontend-quality-a11y-testing`.
3. **Planificar**: listar archivos a crear/modificar y componentes existentes a reutilizar antes de codificar.
4. **Implementar en incrementos pequeños**: primero tokens/componentes, luego layout, luego pantalla, luego estados.
5. **Verificar** con lint, tipos y pruebas tras cada incremento relevante, no solo al final.
6. **Reportar** al terminar: archivos cambiados, Skills aplicadas, supuestos tomados, placeholders pendientes y comprobaciones ejecutadas.
7. Adaptación por herramienta:
   - **GitHub Copilot (VS Code)**: trabajar sobre los archivos abiertos y el contexto del espacio de trabajo; citar en cada solicitud el archivo de Skill relevante; usar los archivos de instrucciones del repositorio para no repetir reglas.
   - **Codex**: leer el archivo de instrucciones del repositorio antes de actuar, ejecutar las comprobaciones de la tarea y entregar el resultado como cambios revisables y acotados.
8. Si las Skills entran en conflicto, prevalece la más específica a la tarea; si persiste, priorizar accesibilidad y consistencia con los tokens y preguntar al usuario.

## Design rules

- Las instrucciones del repositorio para cada herramienta deben referenciar las Skills, no copiar su contenido, para evitar divergencias.
- Cada tarea produce cambios revisables de tamaño acotado.

## Implementation rules

- Reutilizar antes de crear; no introducir dependencias sin justificación.
- No modificar archivos fuera del alcance de la tarea.
- Mantener las convenciones de nombres, estructura y formato existentes en el repositorio.
- No hardcodear secretos, URLs de entorno ni datos de ejemplo como si fueran reales.
- Registrar supuestos con el prefijo "Supuesto:" y, si se necesita, dejar un nombre explícito del componente o servicio, no un placeholder genérico.

## Validation

- Informe final presente y con supuestos y placeholders listados.
- Skills aplicadas en el orden indicado.
- Verificaciones ejecutadas y resultados registrados.
- Diff limitado a los archivos previstos en el plan.

## Constraints

- No asumir framework, librería de UI, gestor de estado ni patrón de API no confirmados.
- No inventar funcionalidades no justificadas por las imágenes o por el usuario.
- No ejecutar acciones destructivas ni instalar dependencias globales sin confirmación.

## Examples

- Tarea "crear pantalla de login": aplicar design-system → components (Button, TextField, Checkbox) → layout (`AuthSplitLayout`) → `frontend-auth-forms` → states (error de campo) → quality; reportar el proveedor de autenticación real como pendiente si no existe.
- Instrucción de repositorio recomendada: "Antes de cualquier cambio de UI, leer la carpeta de Skills del proyecto y aplicar las Skills en el orden definido por `frontend-agent-workflow`".