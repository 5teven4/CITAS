# frontend-auth-forms

## Purpose

Implementar formularios de autenticación y otros formularios con validación consistente, accesible y desacoplada de la lógica de envío, tomando como base la pantalla de login.

## When to use

- Al crear o modificar login, registro, recuperación de contraseña o formularios similares.
- Al añadir validación, mostrar/ocultar contraseña o autenticación social.

## When not to use

- Para gestión real de sesiones, tokens o seguridad de backend.
- Para componentes de campo genéricos (usar `frontend-ui-components`).

## Inputs

- Stack base: `React 18 + TypeScript` y `react-hook-form` para validación de formularios; si se usa un proveedor de autenticación, `Supabase Auth` o servicio equivalente por capa de dominio.
- Campos requeridos y reglas de validación de cada formulario.
- Proveedores sociales requeridos: Google y Apple.

## Instructions

1. Construir `LoginForm` con: título "Log In", campo Email, campo Password con botón mostrar/ocultar, texto de ayuda de la contraseña, checkbox "Remember me", enlace "Forgot Password?", botón primario ancho completo, dos botones secundarios de login social lado a lado (Google y Apple), separador y enlace "No account yet? Sign Up".
2. Colocarlo en `AuthSplitLayout` (ver `frontend-layout-navigation`).
3. Validación:
   - Email: obligatorio y con formato válido.
   - Contraseña: la imagen indica "mínimo 8 caracteres combinando letras, números y símbolos". Implementar esa regla como esquema de validación declarativo y reutilizable.
   - Cualquier otra regla se documenta como supuesto en la tarea concreta; por defecto se usa la política del proyecto: mínimo 8 caracteres, mayúscula, número y símbolo.
4. Momento de validar: al perder foco tras la primera interacción y al enviar; mostrar errores junto al campo con `aria-describedby` y `aria-invalid`. Supuesto: la imagen no muestra mensajes de error; usar el patrón de error de `frontend-ui-states-feedback`.
5. Enfocar el primer campo inválido al enviar con errores.
6. Toggle de contraseña: botón con etiqueta accesible ("Mostrar contraseña"/"Ocultar contraseña") que alterna `type` entre `password` y `text` y expone `aria-pressed`.
7. Envío: el formulario llama a una función `onSubmit(values)` recibida por props/hook; la llamada real a la capa de autenticación (por ejemplo `authService.login` o `Supabase Auth`) vive en una capa separada. Durante el envío, el botón muestra estado de carga y queda deshabilitado.
8. Login social: cada botón invoca `onSocialLogin(provider)`; los proveedores se configuran por datos.
9. "Remember me": estado booleano enviado en `onSubmit`; su persistencia es responsabilidad de la capa de autenticación.

## Design rules

- Etiquetas siempre visibles encima del campo; el placeholder no sustituye la etiqueta.
- Campos rellenos con superficie alterna y borde inferior; estado de foco claramente visible; estado de error con icono, texto y borde.
- Botón primario a ancho completo; botones sociales a mitad de ancho cada uno; en móvil pueden apilarse.
- Texto de ayuda en tamaño `text-caption` y contraste AA.
- Formulario alineado a la izquierda con ancho máximo acotado, como en la imagen.

## Implementation rules

- Usar `<form>` con `<label for>`, `autocomplete="email"` y `autocomplete="current-password"` (o `new-password` en registro), `type="email"`, `inputmode` adecuado.
- Esquemas de validación en un archivo separado, sin acoplarse a la UI.
- No registrar ni exponer contraseñas en logs, consola ni URL.
- Los mensajes de error provienen de una tabla de mensajes central (i18n-ready).
- Botones sociales con el logo oficial del proveedor y texto visible.

## Validation

- Enviar vacío muestra errores accesibles y enfoca el primer campo.
- Enter envía el formulario; Tab recorre en orden lógico.
- El toggle de contraseña funciona con teclado y lector de pantalla.
- Ninguna llamada de red dentro de componentes de campo.
- Prueba unitaria de las reglas de validación (casos válidos e inválidos).

## Constraints

- No implementar registro, recuperación de contraseña ni MFA salvo petición; solo enlazar.
- No asumir proveedor de autenticación ni almacenamiento de sesión.
- No inventar mensajes legales o de privacidad.

## Examples

- `password = "abc123"` → error: no cumple mínimo de 8 caracteres/símbolos.
- `LoginForm onSubmit={authService.login} providers={["google","apple"]}`.