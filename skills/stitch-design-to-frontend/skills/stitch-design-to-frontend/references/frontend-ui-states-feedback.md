# frontend-ui-states-feedback

## Purpose

Garantizar que cada pantalla y componente con datos o acciones gestione de forma consistente los estados de carga, vacío, error y feedback, incluyendo la página 404.

## When to use

- Al crear o modificar cualquier vista que cargue datos, envíe formularios o pueda fallar.
- Al implementar la página 404 u otras páginas de error.
- Al añadir tooltips, popovers o mensajes de feedback.

## When not to use

- Para lógica de reintento de red a bajo nivel, que se resuelve en la capa de servicio o fetch del proyecto.
- Para diseñar componentes base (usar `frontend-ui-components`).

## Inputs

- Stack base: `React 18 + TypeScript` y `React Router`.
- Origen de datos de la vista y sus posibles fallos.
- Textos de estado del proyecto; si no se proporcionan, se usan mensajes claros y reutilizables del dominio.

## Instructions

1. Definir un modelo de estado explícito por recurso: `idle | loading | success | empty | error`. Renderizar según él, no con banderas booleanas dispersas.
2. Componentes reutilizables:
   - `Skeleton` (mismas dimensiones que el contenido final, para evitar saltos).
   - `Spinner` para acciones puntuales (botón en carga).
   - `EmptyState` (icono, título, texto y acción opcional).
   - `ErrorState` (icono, mensaje comprensible, acción "reintentar" si aplica).
   - `InlineFieldError` (icono + texto bajo el campo).
   - `Tooltip`/`Popover` (ver `frontend-ui-components`).
3. **Página 404** (observada): `PublicLayout` con contenido centrado: icono grande de cohete en gris, "404" como título principal, "Page Not Found" como subtítulo, párrafo explicativo y botón secundario "Home Page" que enlaza a la ruta raíz. Configurar `React Router` para mostrarla en cualquier ruta no definida y devolver código HTTP 404 si el entorno lo permite.
4. Además, preparar un componente genérico `ErrorPage` reutilizable para otros códigos (500, 403). Por defecto, solo 404 está diseñada; los otros textos e iconos se extienden según el caso real.
5. Estados de carga en widgets y listas: usar `Skeleton` con la forma del contenido (tarjetas KPI, gráficos, filas de tabla).
6. Errores de acción (envío de formulario): mostrar mensaje sin perder los datos introducidos.
7. Feedback no bloqueante (toasts o banners) solo si el proyecto lo requiere; por defecto no se implementan en esta vista salvo que el producto lo requiera explícitamente.

## Design rules

- Mensajes en lenguaje claro: qué pasó y qué puede hacer el usuario.
- El estado de error nunca se comunica solo con color: icono + texto (relevante porque `#C40700` es también el color de marca).
- El estado vacío ofrece una acción útil cuando existe.
- Los esqueletos usan `color-surface-alt`; sin animaciones agresivas y respetando `prefers-reduced-motion`.
- El 404 mantiene header y footer para permitir la navegación.

## Implementation rules

- Regiones dinámicas con `aria-live="polite"` para carga/errores; `role="alert"` para errores críticos de formulario.
- Título del documento (`<title>`) y `h1` específicos en la página 404.
- Evitar parpadeo: no mostrar `Skeleton` si la respuesta llega en menos de un umbral corto (por defecto 150-250 ms) y solo si el contenido real llega antes del umbral.
- Centralizar textos de estado para facilitar traducción.
- El botón "Home Page" es un enlace (`a`) hacia la raíz, no un `button` con `onClick` de navegación.

## Validation

- Cada vista con datos tiene los cinco estados alcanzables y probados.
- La página 404 se muestra en rutas inexistentes y el botón vuelve a la home.
- Los lectores de pantalla anuncian cambios de estado.
- Sin saltos de layout al pasar de carga a contenido.

## Constraints

- No inventar copy legal ni códigos de error de backend.
- No añadir sistemas de logging/monitorización sin petición; se usan servicios del stack del proyecto si existen.
- No bloquear toda la pantalla si solo falla un widget.

## Examples

- Widget sin datos en el rango: `EmptyState` con "No hay datos para este periodo" y acción "Cambiar fechas" usando mensajes del mismo dominio del producto.
- Fallo de carga del dashboard: `ErrorState` en el widget afectado con "Reintentar".