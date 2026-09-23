# Justificación de normalización a 3FN

`db.sql` es el esquema ejecutable y `erd.mmd` su fuente de diagrama canónica.

## Dependencias funcionales principales

- `users.id ->` datos de identidad, contacto y estado; `email` y `(document_type, document_number)` son claves candidatas.
- `professionals.id -> user_id, professional_code, license_number`; `user_id` es único porque el perfil profesional extiende a un único usuario.
- `eps_plans.id -> eps_id, regime_id, code, name`. Una cita o usuario no repite nombres de EPS, régimen ni plan: los obtiene mediante FKs.
- `specialties.id ->` nombre, duración, tipo de atención y reglas de aprobación.
- `appointments.id ->` paciente, profesional, sede, especialidad, estado y franja acordada.
- `professional_slots.id ->` bloque y franja atómica de 30 minutos. `slot_reservations.professional_slot_id` es único, por lo que determina como máximo una retención vigente.

## 1FN y 2FN

Todos los atributos son atómicos. Los roles, especialidades y sedes múltiples se representan con las tablas puente `user_roles`, `professional_specialties` y `professional_locations`; no hay listas separadas por comas.

Las relaciones N:M tienen una PK compuesta formada solo por sus FKs. El único atributo adicional de estas relaciones (`is_primary`) depende de la combinación profesional-especialidad completa, no de una sola parte de la clave.

## 3FN

Los catálogos se separan de las transacciones: estados, regímenes, EPS, planes, especialidades y sedes se referencian por clave. Por ello no se propagan nombres ni códigos de esos catálogos a `users` ni a `appointments`.

La afiliación resuelve `usuario -> plan -> EPS/régimen` sin dependencias transitivas en el usuario. La columna generada `current_user_id` solo implementa la regla de una afiliación vigente por usuario en MySQL, que no admite índices únicos parciales; no almacena un dato independiente.

`appointments.duration_minutes` es un snapshot intencional de la duración pactada. Evita que una modificación posterior del catálogo `specialties` altere el historial de una cita. Igual ocurre con la franja programada: se conserva como dato de la transacción, mientras los slots representan su retención operativa.

## Integridad de agenda

Una reserva de cita y una reserva provisional de reprogramación comparten `slot_reservations`. Su `UNIQUE(professional_slot_id)` impide retener el mismo slot dos veces y el `CHECK` exige que cada reserva pertenezca exactamente a una cita o a una solicitud de reprogramación. Las operaciones de aprobar, rechazar, cancelar y reprogramar deben ejecutarse en una transacción junto con el historial de estado.
