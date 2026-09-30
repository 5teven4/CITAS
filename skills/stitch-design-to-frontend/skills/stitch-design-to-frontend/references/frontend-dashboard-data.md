# frontend-dashboard-data

## Purpose

Construir dashboards con tarjetas KPI, gráficos, mapa, listados de ranking y filtros, separando obtención de datos, transformación y presentación.

## When to use

- Al crear o modificar una pantalla de métricas o panel de control.
- Al añadir gráficos, KPI, tablas de ranking o filtros de fecha.

## When not to use

- Para landings o formularios de autenticación.
- Para diseñar el layout general de la aplicación (usar `frontend-layout-navigation`).

## Inputs

- Stack: `React 18 + TypeScript` con `Tailwind CSS` para UI, `Recharts` para gráficos, `react-simple-maps` para mapa geográfico, `TanStack Query` para fetching y `useReducer`/`Context` para filtros compartidos.
- Modelo de datos de cada widget (métricas, series, países, usuarios).
- Formato de fechas, moneda y locale: `es-ES` con coma decimal. Las cifras se renderizan como `+2,5%`, `4,5M` y `€12.450` según la configuración regional.

## Instructions

1. Estructura del dashboard observado, dentro de `AppShellLayout`:
   - Título de página y `Tabs` (Overview, Tasks, Documents, Team, Reports, Admin deshabilitado, menú "…") con contadores.
   - `DateRangePicker` con "Start date", flecha y "End date", con iconos de calendario, alineado a la derecha de los tabs.
   - Fila de 4 `KpiCard`: etiqueta, valor y `DeltaBadge`.
   - Fila con 3 tarjetas: `GaugeCard` (progreso "Achieved/Remaining" con valor central), `PolarAreaCard` (categorías "Very Active/Inactive") y `MapCard` (países activos con tooltip).
   - Fila inferior con `RankingTable` (país con bandera, porcentaje, valor absoluto) y `DonutRankingCard` (donut multinivel + lista con nombre, importe y variación).
2. Crear una capa por widget: `fetch/select` (datos) → `mapper` (formato de presentación) → componente presentacional. El componente nunca llama a la API directamente.
3. `KpiCard`: props `label`, `value` (ya formateado), `delta` (número), `deltaTone` derivado del signo. Formateo de números compactos (K, M) y porcentajes mediante `Intl.NumberFormat` con locale `es-ES`, no cadenas hardcodeadas.
4. Gráficos: usar `Recharts` y encapsular cada uno en un componente con props de datos y leyenda. Incluir leyenda visible con marcador y etiqueta (como "Achieved/Remaining").
5. Mapa: `react-simple-maps` o SVG; resaltar países activos y mostrar `Popover` con texto y acciones (enlace y botón). Supuesto: el disparador del popover es hover y el contenido se define por país activo.
6. Filtro de fechas: estado compartido por la pantalla con `useReducer`/`Context` y ruta opcional por query-string, propagado a todos los widgets; validar que inicio ≤ fin.
7. Tabs: cada tab representa una vista; solo "Overview" está diseñada en la imagen. Las otras vistas quedan como extensiones del panel y se implementan según la necesidad real de la tarea.
8. Cada widget gestiona sus estados de carga, vacío y error (ver `frontend-ui-states-feedback`).

## Design rules

- Cuadrícula responsive: 4 columnas de KPI → 2 → 1; las tarjetas de gráficos 3 → 1.
- Tarjetas con título en la parte superior, mismo padding y borde.
- Datos numéricos alineados a la derecha en tablas y con tipografía tabular (cifras de igual ancho).
- Los indicadores de variación combinan signo y tono; la variación negativa tiene un estilo visualmente distinto del positivo, pero no depende solo del color.
- Paleta de gráficos tomada de los tokens `chart-*` del design system: `chart-1 #C40700`, `chart-2 #F2F2F2`, `chart-3 #D1D5DB`, `chart-4 #6B7280`, `chart-5 #374151`, `chart-6 #111827`; no depende únicamente del color: añadir etiquetas, patrones o valores para distinguir series.
- Cada gráfico incluye un resumen accesible (título, descripción o tabla equivalente).

## Implementation rules

- Datos y transformación en módulos independientes de la UI y testeables.
- Memoizar cálculos costosos y evitar re-renderizar todos los widgets al cambiar un filtro que no les afecta.
- Cargar gráficos y mapa de forma diferida (lazy) cuando sea posible.
- Banderas como recursos/icons por código de país; con `alt` con el nombre del país.
- Manejo de cancelación de peticiones al cambiar el rango de fechas para evitar condiciones de carrera.
- Sin dimensiones fijas en px en gráficos: usar contenedores responsive.

## Validation

- Cambiar el rango de fechas actualiza todos los widgets dependientes sin errores.
- Cada widget se prueba con datos normales, vacíos y error.
- Los números respetan `es-ES` y formato compacto.
- Un usuario de teclado accede a tabs, selector de fechas y acciones del popover.
- Sin dependencias circulares entre datos, mapeo y presentación.

## Constraints

- No inventar métricas, endpoints ni permisos (por ejemplo, qué usuarios ven "Admin").
- No asumir librería de gráficos ni de mapas.
- La semántica exacta de los KPI (periodo de comparación del delta) se define en la tarea o en el contrato del backend; por defecto el delta compara el periodo actual con el periodo anterior.

## Examples

- Delta `-1.2` → `DeltaBadge` con texto "-1,2%" (según `es-ES`) y tono negativo.
- `RankingTable rows=[{country:"US", share:27.5, total:4500000}]` muestra "United States 27,5% 4,5M".