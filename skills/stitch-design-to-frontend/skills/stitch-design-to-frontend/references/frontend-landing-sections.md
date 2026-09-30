# frontend-landing-sections

## Purpose

Generar landing pages ensamblando secciones de marketing reutilizables y configurables por datos, según los patrones de la imagen de landing.

## When to use

- Al crear o modificar una landing o página de marketing.
- Al añadir una sección promocional a una página pública.

## When not to use

- Para dashboards, autenticación o pantallas de error.
- Para definir botones o tarjetas genéricas (usar `frontend-ui-components`).

## Inputs

- Stack base: `React 18 + TypeScript` con contenido proveniente de datos estáticos o de un CMS/API según el proyecto.
- Contenido de cada sección: textos, imágenes, iconos, enlaces, planes.
- Lista y orden de las secciones requeridas.

## Instructions

1. Cada sección es un componente independiente que recibe sus datos por props y usa `SectionShell` (contenedor con fondo alterno, padding vertical, eyebrow, título y subtítulo opcionales, slot de contenido y CTA opcional).
2. Secciones disponibles (todas observadas en la imagen):
   - **Hero**: título grande, subtítulo, dos CTAs (primario con flecha, secundario) y un medio a la derecha (marco con botón de reproducir; por defecto se trata de un vídeo y se reemplaza por contenido real en el proyecto).
   - **FeatureIconList**: eyebrow, título, 4 columnas con icono, texto breve y CTA centrado.
   - **LogoCloud**: eyebrow, título, párrafo y fila de logos de clientes.
   - **FeatureGrid**: cuadrícula 2×2 de icono + texto, con eyebrow, título y CTA.
   - **Testimonials**: carrusel con tarjetas (logo de empresa, cita, avatar, nombre, cargo) y flechas laterales.
   - **BlogTeaser**: 4 tarjetas con imagen, categoría, título, extracto y autor (avatar, nombre, rol) y CTA.
   - **TeamGrid**: 4 miembros con foto, nombre, cargo, redes sociales y botón "Contactar".
   - **Pricing**: toggle anual/mensual con etiqueta de descuento, 3 planes (nombre, descripción, precio tachado, precio actual, nota de facturación, CTA, lista de características con check), plan destacado con etiqueta "Most Popular".
   - **FAQ**: acordeón con preguntas.
   - **FinalCTA**: título, párrafo y dos botones (primario y secundario).
   - **Footer ampliado**: ver `frontend-layout-navigation`.
3. Definir tipos/esquemas de datos para cada sección y un componente `LandingPage` que reciba un array de secciones y las renderice en orden.
4. Pricing: el cálculo de precio anual/mensual y del descuento proviene de los datos, no de constantes en el componente. Supuesto: el toggle "Yearly" muestra el precio con descuento y el precio original tachado; confirmar con el usuario.
5. Carrusel: incluir controles anterior/siguiente; autoplay, indicadores de página y número de tarjetas visibles se implementan con la estrategia del proyecto y, si no se indican, se usan valores mínimos accesibles sin autoplay agresivo.

## Design rules

- El eyebrow usa `text-eyebrow` con color de marca o de acento definido en tokens; los títulos de sección van centrados con jerarquía consistente.
- Alternar fondos entre secciones consecutivas.
- Las tarjetas de blog, equipo y precios comparten el componente `Card`.
- El plan destacado se distingue con más de una señal (etiqueta y énfasis de borde/fondo), no solo con color.
- Los textos lorem ipsum de las imágenes son placeholders; no copiarlos como contenido final.

## Implementation rules

- Contenido separado de presentación (datos en archivos/objetos tipados).
- Imágenes con `alt` significativo (o `alt=""` si decorativas), `loading="lazy"` bajo el pliegue y dimensiones reservadas.
- CTA como enlaces (`a`) si navegan y `button` si ejecutan acciones.
- Cuadrículas responsive: 4 → 2 → 1 columnas; el precio pasa de 3 columnas a apiladas.
- Cada sección con `aria-labelledby` apuntando a su título.

## Validation

- Añadir, quitar o reordenar una sección solo requiere cambiar la configuración de datos.
- Ninguna cadena de contenido en los componentes de sección.
- Carrusel, acordeón y toggle operables por teclado y anunciados a lectores de pantalla.
- Puntuación de rendimiento: imágenes optimizadas y sin layout shift visible.

## Constraints

- No inventar secciones, precios, testimonios ni métricas.
- No implementar pasarela de pago ni suscripción; el CTA solo navega o dispara una callback de la capa de la vista.
- Newsletter: envío del email se gestiona por la capa de formulario o servicio del proyecto y no se asume un proveedor concreto.

## Examples

- `sections: [hero, featureIcons, logoCloud, testimonials, pricing, faq, finalCta]` genera una landing reducida sin modificar componentes.