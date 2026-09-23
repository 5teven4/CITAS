# Instrucciones del workspace FCV Citas

## Alcance

Este workspace coordina dos repositorios independientes: `citas-api` y `citas-web`. La raíz contiene especificaciones, infraestructura, referencias de base de datos y utilidades; no debe convertirse en un tercer proyecto de aplicación.

## Fuentes de verdad

Lee `PRD.md`, `RESTRICCIONES_TECNICAS.md` y la historia de usuario aprobada antes de implementar. La wiki global vive exclusivamente en `citas-api/docs/wiki/llm-wiki/`; sigue sus reglas en `AGENTS.md` antes de actualizarla.

## Límites

- Backend y migraciones: solo `citas-api`.
- Frontend: solo `citas-web`.
- No introducir Express/BFF ni datos reales de pacientes o profesionales.
- No versionar ni revelar `.env`, secretos, tokens o contraseñas.
- Para cambios cross-repo, describe los archivos y contratos afectados antes de editar y valida ambos lados.

## Calidad

Trabaja desde `develop` cuando los repositorios estén inicializados. Ejecuta pruebas relevantes y diferencia evidencia comprobada de trabajo pendiente.
