# frontend-ui-components

## Purpose

Construir y reutilizar componentes de interfaz atómicos y compuestos con API consistente, separando presentación, lógica y datos, para reproducir los patrones observados en las imágenes sin duplicar código.

## When to use

- Al crear o modificar un componente de UI.
- Al detectar un patrón visual repetido en dos o más lugares.
- Al decidir si un elemento debe ser componente, variante o composición.

## When not to use

- Para definir tokens visuales (usar `frontend-design-system`).
- Para ensamblar una pantalla completa (usar `frontend-layout-navigation` y la skill de pantalla).
- Para lógica de datos o estado global.

## Inputs

- Stack base: `React 18 + TypeScript` con componentes propios; si se incorpora una librería, se encapsula bajo la API del proyecto.
- Sistema de estilos: `Tailwind CSS` con tokens del design system.
- Tokens del sistema de diseño.
- Descripción del componente requerido y su contexto de uso.

## Instructions

1. Antes de crear, buscar en el repositorio si ya existe un componente equivalente; reutilizar o extender con una variante antes de crear uno nuevo.
2. Clasificar el componente: **primitivo** (Button, Input, Checkbox, Badge, Icon, Avatar, Link), **compuesto** (FormField, Card, Tabs, Accordion, Tooltip/Popover, Toggle, Carousel, DateRangePicker, SearchField) o **de sección/dominio** (ver otras Skills).
3. Implementar los componentes observados en las imágenes con estas variantes mínimas:
   - **Button**: `primary` (sólido, color de marca, texto blanco), `secondary` (borde de marca, fondo transparente), `link`/texto; tamaños `md` y `lg`; ancho `auto` y `full`; estados default, hover, focus, active, disabled, loading; soporte de icono inicial/final (flecha en CTA, logos Google/Apple).
   - **TextField** (email/texto/password): etiqueta encima, campo relleno con superficie `color-surface-alt` y borde inferior, placeholder, texto auxiliar, mensaje de error, icono/acción final (ojo de contraseña, icono calendario, icono de búsqueda al inicio).
   - **Checkbox** con etiqueta.
   - **Toggle/Switch** (periodo anual/mensual).
   - **Badge/Pill**: contador numérico en tabs y nav (valores como "7", "99+"), indicador de notificación (círculo con número), indicador de variación (+/−) con variante positiva y negativa, etiqueta "Most Popular", etiqueta de descuento.
   - **Tabs** con contador opcional, estado activo con subrayado, estado deshabilitado (ítem "Admin") y menú de desbordamiento ("…").
   - **Accordion** (FAQ) con icono +/− y un ítem abierto a la vez por defecto (supuesto).
   - **Card**: contenedor con borde, título, contenido y, opcionalmente, cabecera con leyenda.
   - **Tooltip/Popover**: superficie oscura, texto, acción de enlace y botón.
   - **Avatar**: imagen o placeholder con icono.
   - **SocialIconLink**: iconos de YouTube, Facebook, Twitter/X, Instagram, LinkedIn.
   - **Carousel** con flechas laterales.
   - **Divider**.
4. Definir para cada componente una API mínima y tipada: props/atributos, variantes, estados, slots, eventos. Prefijar nombres de forma consistente en todo el proyecto.
5. Los componentes de presentación no llaman a APIs, no leen estado global ni contienen reglas de negocio; reciben datos y callbacks por props.
6. Los componentes que muestran listas o secciones aceptan datos por configuración/props, no contenido hardcodeado.
7. Exportar todos los componentes desde un punto de entrada único por carpeta.

## Design rules

- Botón primario: un solo por bloque de acción; el secundario nunca compite visualmente con el primario.
- Los iconos decorativos son `aria-hidden`; los iconos que actúan como botón tienen etiqueta accesible.
- Los indicadores de variación positiva/negativa no dependen solo del color: incluir signo (+/−) y, opcionalmente, icono de flecha.
- El estado activo de tabs y navegación se distingue con más de una señal (color y subrayado/fondo).
- Todos los componentes interactivos tienen estado de foco visible con `color-focus-ring`.
- Área táctil mínima de 44×44 px en elementos interactivos en móvil.

## Implementation rules

- Estilos solo mediante tokens (ver `frontend-design-system`); sin valores literales.
- Componentes controlados/no controlados según la convención de `React` con `useState`/`useReducer`; documentar cuál se usa.
- Usar elementos HTML semánticos nativos (`button`, `a`, `input`, `label`, `details/summary` o roles ARIA equivalentes) antes que `div` con roles.
- No duplicar componentes por variante visual: usar props de variante.
- Cada componente nuevo incluye un archivo de historia/ejemplo o prueba mínima de sus estados usando `Vitest` + `@testing-library/react`.
- Mantener componentes bajo un tamaño razonable; si superan responsabilidades múltiples, dividirlos.

## Validation

- Cada componente renderiza todos sus estados documentados (default, hover, focus, disabled, error/loading si aplica).
- Navegación por teclado completa (Tab, Enter, Space, Escape, flechas donde aplique).
- Ninguna importación de datos/servicios dentro de componentes de presentación.
- Cero literales visuales.
- No existen dos componentes con la misma responsabilidad.

## Constraints

- No añadir componentes que no aparezcan en las imágenes o no se requieran explícitamente.
- Supuesto: comportamientos no visibles (animaciones, cierre de tooltip, autoplay del carrusel) no deben inventarse; implementarlos de forma mínima y marcarlos como supuesto.
- Si el proyecto incorpora una librería de UI, se encapsula bajo la API propia para respetar los tokens del sistema; no se forja una dependencia extra sin necesidad.

## Examples

- Un botón "Log in with Google" es `Button variant=secondary fullWidth` con icono inicial, no un componente nuevo.
- El indicador "+2,5%" y "−1,2%" es `Badge` con `tone=positive|negative` y signo visible.