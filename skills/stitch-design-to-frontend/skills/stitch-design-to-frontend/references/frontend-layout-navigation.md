# frontend-layout-navigation

## Purpose

Definir la estructura de las pantallas y la navegación (layouts, header, footer, sidebar, tabs de sección) con comportamiento responsive desde el inicio.

## When to use

- Al crear una página nueva o un layout compartido.
- Al añadir o modificar navegación (header, footer, sidebar, tabs, dropdowns).
- Al adaptar una pantalla a móvil/tablet.

## When not to use

- Para el diseño interno de un componente (usar `frontend-ui-components`).
- Para el contenido de secciones específicas (usar la skill de pantalla).

## Inputs

- Stack base: `React 18 + TypeScript` y `React Router` para rutas.
- Tipo de pantalla: pública, autenticación, aplicación (dashboard), error.
- Estructura de navegación: `Overview`, `Tasks`, `Documents`, `Team`, `Reports`, `Admin` según el panel principal.
- Breakpoints del sistema de diseño: `sm`, `md`, `lg`, `xl` con la escala tailwind del proyecto.

## Instructions

1. Implementar estos cuatro layouts reutilizables y ninguno más salvo petición:
   - **PublicLayout**: header superior + contenido + footer. Usado por landing y 404.
   - **AuthSplitLayout**: dos mitades; izquierda con imagen/ilustración decorativa sobre superficie `color-surface-alt`, derecha con formulario alineado a la izquierda y ancho máximo acotado.
   - **AppShellLayout**: sidebar fija a la izquierda + área principal con título de página, tabs de sección y contenido en cuadrícula.
   - **CenteredMessageLayout**: contenido centrado vertical y horizontalmente para mensajes (404), dentro de PublicLayout.
2. **Header público**: logo a la izquierda, navegación central con ítems simples y uno con desplegable, acciones a la derecha (un botón secundario y uno primario). Borde inferior sutil.
3. **Footer público**: superficie oscura (`color-surface-inverse`), logo, enlaces de navegación en fila, iconos de redes sociales, copyright centrado. En la landing, variante ampliada con formulario de newsletter, columnas de enlaces, badges de tiendas de apps y bloque de redes.
4. **Sidebar de aplicación**, de arriba abajo: logo, fila de utilidades (avatar, ajustes, notificaciones con contador), campo de búsqueda, lista de ítems con icono + etiqueta. Un ítem puede llevar contador y chevron de expansión (submenú). Marcar estado activo/hover con fondo de superficie alterna.
5. **Tabs de sección** bajo el título de página (ver `frontend-ui-components`), con controles de filtro alineados a la derecha en desktop.
6. Responsive:
   - Header público: colapsa en menú móvil (botón hamburguesa) por debajo del breakpoint de tablet; las dos acciones pasan al menú.
   - AuthSplitLayout: por debajo de tablet se oculta o reduce la imagen y el formulario ocupa todo el ancho.
   - AppShellLayout: la sidebar pasa a drawer accesible por botón en móvil; la cuadrícula de tarjetas baja de 4 → 2 → 1 columnas.
   - Footer: columnas apiladas en móvil.
7. Contenido principal siempre dentro de un contenedor con ancho máximo y padding lateral tokenizado.
8. Usar landmarks: `header`, `nav`, `main`, `aside`, `footer`; un solo `main` por página y enlace "saltar al contenido".

## Design rules

- Alternar superficies (`color-surface-base` / `color-surface-alt`) entre secciones consecutivas para separación sin bordes.
- Espaciado vertical entre secciones consistente y tomado de tokens.
- La navegación indica claramente la ubicación actual (`aria-current`).
- El desplegable de navegación es operable por teclado y se cierra con Escape y clic exterior.
- Los ítems y rutas del ejemplo se reemplazan por los nombres reales del producto y la navegación del proyecto; si no existen, se usan los items de la pantalla actual con labels claros.

## Implementation rules

- Layouts como componentes que reciben `children`/slots; no incluyen contenido de negocio.
- Enfoque mobile-first con los breakpoints de tokens; evitar anchos fijos en px.
- Usar CSS Grid/Flex; evitar posicionamiento absoluto para estructura.
- Navegación declarativa a partir de una configuración (array de ítems) y no JSX/HTML repetido.
- La lógica de ruta activa proviene de `React Router` y del `NavLink`/`useLocation`, no de comparaciones de strings dispersas.
- Imágenes con dimensiones o `aspect-ratio` reservados para evitar saltos de layout.

## Validation

- Probar en anchos representativos de móvil, tablet y desktop: sin scroll horizontal ni solapamientos.
- Navegación completa por teclado, incluido el desplegable y el drawer móvil (con foco atrapado y devolución del foco).
- Un solo `h1` por página; landmarks correctos.
- Sidebar, header y footer se reutilizan sin copiar código entre pantallas.

## Constraints

- No crear layouts adicionales sin justificarlos con una pantalla real.
- No inventar ítems de navegación o rutas.
- No hardcodear anchos de contenedor ni colores.

## Examples

- Página 404: `PublicLayout > CenteredMessageLayout`.
- Login: `AuthSplitLayout` con `LoginForm` en la mitad derecha.
- Dashboard: `AppShellLayout` con `Sidebar`, título "Dashboard", `Tabs` y cuadrícula de tarjetas.