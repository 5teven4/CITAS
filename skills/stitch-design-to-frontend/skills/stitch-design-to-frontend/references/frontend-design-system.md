# frontend-design-system

## Purpose

Definir y aplicar un sistema de diseño basado en tokens para todas las interfaces frontend, usando la paleta corporativa `#C40700`, `#FFFFFF` y `#F2F2F2`, de modo que ningún componente o pantalla contenga valores visuales hardcodeados.

## When to use

- Al iniciar un proyecto frontend nuevo o al crear/actualizar tokens.
- Al añadir cualquier color, tamaño de fuente, espaciado, borde, sombra o breakpoint.
- Al detectar valores visuales literales (hex, px sueltos) en componentes.

## When not to use

- Para lógica de negocio, routing o consumo de APIs.
- Para decidir la estructura de una pantalla (usar `frontend-layout-navigation`).

## Inputs

- Stack base: `React 18 + TypeScript` con `Tailwind CSS` como sistema de estilos.
- `font-family` por defecto: `Inter, Roboto, "Segoe UI", sans-serif`.
- Paleta corporativa definida en el proyecto: `#C40700` (primario), `#FFFFFF` (base), `#F2F2F2` (superficie alterna).
- Neutros del proyecto (no corporativos):
  - `neutral-50`: `#F7F7F7`
  - `neutral-100`: `#F2F2F2`
  - `neutral-200`: `#E5E7EB`
  - `neutral-300`: `#D1D5DB`
  - `neutral-500`: `#6B7280`
  - `neutral-700`: `#374151`
  - `neutral-900`: `#111827`
- Semánticos auxiliares (no forman parte de la marca):
  - `color-success`: `#15803D`
  - `color-warning`: `#D97706`
  - `color-error`: `#B42318` (no corporativo; solo feedback)
  - `color-info`: `#1D4ED8`
  - `color-surface-inverse`: `#111827`
  - `chart-1`: `#C40700`, `chart-2`: `#F2F2F2`, `chart-3`: `#D1D5DB`, `chart-4`: `#6B7280`, `chart-5`: `#374151`, `chart-6`: `#111827`

## Instructions

1. Crear una única fuente de verdad de tokens en `tailwind.config` y `src/styles/tokens.css` (o equivalente) con estas categorías: color, tipografía, espaciado, radio, borde, sombra, z-index, breakpoints, duración de transición, tamaños de icono.
2. Definir tokens de color **semánticos**, no por valor. Mínimo:
   - `color-brand-primary` = `#C40700`
   - `color-surface-base` = `#FFFFFF`
   - `color-surface-alt` = `#F2F2F2`
   - `color-text-on-primary` = `#FFFFFF`
   - `color-text-default`, `color-text-muted`, `color-border-default`, `color-surface-inverse` (para footer/tooltip oscuro, usando `#111827` como superficie inversa)
   - `color-focus-ring`
   - `color-feedback-*` para éxito, aviso, error e info
3. Derivar de `color-brand-primary` los estados hover, active y disabled mediante tokens (por ejemplo `color-brand-primary-hover`, `color-brand-primary-active`) y documentar cómo se calcularon. No usar opacidades ad hoc en componentes.
4. Definir escala tipográfica a partir de la jerarquía observada en las imágenes: título de página/hero (muy grande, bold), título de sección (grande, bold, centrado), eyebrow/caption (pequeño, mayúsculas, color destacado), título de tarjeta (semibold), cuerpo, texto auxiliar/helper (pequeño), cifra KPI (grande). Nombrarlos como `text-display`, `text-heading-1..3`, `text-eyebrow`, `text-body`, `text-caption`, `text-metric`.
5. Definir una escala de espaciado base (múltiplos de 4 u 8 px) y usar solo esa escala.
6. Definir radio de borde en tokens. Observación: botones, inputs y tarjetas en las imágenes tienen esquinas rectas; usar `radius-none` por defecto en esos elementos y `radius-full` para badges/pills (los indicadores de variación y contadores tienen forma de píldora) y avatares.
7. Definir el grosor de borde de botón secundario (observado ≈ 2 px) como token.
8. Definir tokens de iconografía: un solo set de iconos de trazo (línea) para features/navegación y iconos rellenos para redes sociales. Tamaños en tokens (`icon-sm`, `icon-md`, `icon-lg`, `icon-xl`).
9. Definir breakpoints como tokens: `sm: 640px`, `md: 768px`, `lg: 1024px`, `xl: 1280px` para móvil, tablet, desktop y wide. Si el proyecto ya define otros valores, se respetan y se mantienen en el archivo de tokens.
10. Exponer los tokens a componentes solo mediante Tailwind theme variables y CSS variables; prohibir literales visuales fuera del archivo de tokens.

## Design rules

- El color primario `#C40700` se reserva para acciones principales, enlaces destacados, estados activos y énfasis. No usarlo como fondo de áreas grandes salvo hero/CTA final si el diseño lo pide.
- `#F2F2F2` se usa para alternar secciones y fondos de campos/paneles; `#FFFFFF` para tarjetas y superficies de contenido. Alternar superficies entre secciones consecutivas de una página.
- Contraste mínimo WCAG AA: 4.5:1 para texto normal y 3:1 para texto grande y elementos de UI. Referencia: `#C40700` sobre `#FFFFFF` ≈ 6.2:1 y sobre `#F2F2F2` ≈ 5.5:1; texto blanco sobre `#C40700` ≈ 6.2:1. Validar cualquier combinación nueva.
- El rojo corporativo es un color de marca, no de error. El feedback de error usa `color-error` como token semántico distinto del primario, pero no se incorpora como color corporativo adicional. Regla: los errores nunca se comunican solo con color; siempre icono + texto.
- Jerarquía visual: un solo CTA primario por bloque; los secundarios usan borde con el color primario y fondo transparente.
- Los datos que las imágenes muestran en grises (gráficos) deben mapearse a una paleta de datos tokenizada: `chart-1..n` derivada de la marca y neutros. La paleta base del proyecto, sin añadir colores corporativos nuevos, es: `chart-1 #C40700`, `chart-2 #F2F2F2`, `chart-3 #D1D5DB`, `chart-4 #6B7280`, `chart-5 #374151`, `chart-6 #111827`.

## Implementation rules

- Nombrar tokens por rol (`color-text-muted`), nunca por apariencia (`gray-500`), en la capa de componentes. La capa primitiva puede usar escalas, pero los componentes solo consumen semánticos.
- Soportar cambio de tema (por ejemplo modo oscuro) únicamente si el usuario lo solicita; dejar la estructura de tokens preparada sin implementar el modo.
- Generar un archivo de referencia de tokens versionado y comentado por categoría.
- Al modificar código existente, sustituir literales visuales por tokens en el mismo cambio y listarlos en el resumen.
- Las fuentes se cargan con `font-display` adecuado y fallback del sistema.

## Validation

- Buscar en el código hex, `rgb()`, `px` de espaciado y `font-size` literales fuera del archivo de tokens: el resultado debe ser cero coincidencias.
- Todo token de color de texto sobre fondo tiene ratio de contraste documentado y ≥ AA.
- `#C40700`, `#FFFFFF` y `#F2F2F2` aparecen definidos exactamente una vez.
- Existe un token para cada elemento de la escala tipográfica y de espaciado usado.

## Constraints

- No introducir colores de marca adicionales sin confirmación del usuario.
- No copiar el azul de las imágenes; es un placeholder del kit.
- No asumir modo oscuro, ni librería de estilos.

## Examples

- Correcto: `background: var(--color-brand-primary)` o la clase equivalente del tema.
- Incorrecto: `background: #C40700` dentro de un componente.
- Tokens mínimos de color esperados: `color-brand-primary: #C40700`, `color-surface-base: #FFFFFF`, `color-surface-alt: #F2F2F2`.