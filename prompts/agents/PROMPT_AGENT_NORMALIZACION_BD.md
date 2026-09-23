# Prompt — Agente `normalizacion-bd`

Para usar este agente dentro de Codex, copia el contenido de
`database/agent-normalizacion-bd/INSTRUCCIONES_PROJECT.md` como instrucciones
base y ejecuta este mensaje desde la raíz del workspace:

```text
Actúa como el agente de normalización de base de datos FCV Citas. Lee primero
PRD.md, RESTRICCIONES_TECNICAS.md, database/REQUISITOS_NORMALIZACION_3FN.md,
database/reference/db.sql, database/reference/NORMALIZACION_3FN.md y
database/reference/erd.mmd. Inspecciona después la configuración de Docker y
las migraciones existentes.

Para esta primera tarea trabaja en modo de solo lectura: entrega una matriz de
cumplimiento 1FN/2FN/3FN, dependencias funcionales, claves y cardinalidades,
riesgos de conexión o concurrencia, y pruebas SQL recomendadas. No modifiques
archivos, datos, volúmenes ni contenedores hasta recibir una solicitud explícita
de implementación.
```
