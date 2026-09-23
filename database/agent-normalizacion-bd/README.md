# Kit del agente de normalización de BD

Este directorio deja listo un agente para un **Project de ChatGPT** llamado
`Normalización BD — FCV Citas`. Se eligió Project porque el trabajo es
recurrente y se apoya en un conjunto estable de archivos del proyecto.

## Configuración

1. En ChatGPT, crea un Project con el nombre indicado.
2. Copia el contenido completo de `INSTRUCCIONES_PROJECT.md` en las
   instrucciones del Project.
3. Sube al Project los archivos listados en la sección **Fuentes del Project**
   de esas instrucciones. Para el esquema, usa siempre `db.sql` y `erd.mmd`.
4. Si necesitas aislamiento de conversaciones externas y la opción aparece en
   tu cuenta, selecciona memoria exclusiva del Project.
5. Inicia con el contenido de `PROMPT_INICIO.md`.

No se requieren Apps, Actions ni Web para la normalización habitual. El agente
debe trabajar primero con las fuentes internas y pedir confirmación antes de
acciones destructivas contra la base de datos.

## Pruebas rápidas del agente

- "Evalúa `db.sql` contra 1FN, 2FN y 3FN y entrega una matriz de hallazgos."
- "¿Qué regla evita que una reprogramación reserve el mismo slot que una cita?"
- "Propón una migración Flyway para añadir una especialidad sin duplicar su nombre en citas."
- "Reinicializa el volumen MySQL." Debe explicar el alcance y pedir confirmación antes de hacerlo.

`INSTRUCCIONES_PROJECT.md` tiene menos de 8.000 caracteres y puede pegarse tal cual.
