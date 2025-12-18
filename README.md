# khalikl

## Roblox Trampoline Script

Este repositorio contiene un script de Lua para Roblox que convierte cualquier objeto (cilindro, plataforma, etc.) en un trampolín funcional.

### Características

- ✅ **Impulso suave y controlado**: Usa `BodyVelocity` para un salto natural, no instantáneo
- ✅ **Detección inteligente**: Solo detecta el `HumanoidRootPart` del jugador
- ✅ **Sistema de cooldown**: Evita activaciones múltiples con un cooldown configurable (0.5-1 segundo)
- ✅ **Objeto estable**: El trampolín permanece anclado y no se mueve
- ✅ **Efecto visual**: Animación de rebote/compresión del trampolín
- ✅ **Soporte de sonido**: Opcional, para reproducir un sonido al saltar
- ✅ **Código limpio**: Totalmente comentado y fácil de entender

### Instalación

1. **Descarga el script**: Copia el contenido de `Trampoline.lua`

2. **En Roblox Studio**:
   - Selecciona el objeto que quieres convertir en trampolín (cilindro, plataforma, etc.)
   - Inserta un nuevo **Script** (NO un LocalScript) dentro del objeto
   - Pega el código de `Trampoline.lua` en el script
   - Asegúrate de que el objeto tenga la propiedad `Anchored = true`

3. **Opcional - Añadir sonido**:
   - Crea un objeto `Sound` dentro del script
   - Nómbralo exactamente `JumpSound`
   - Asigna un SoundId (ejemplo: `rbxassetid://1234567890`)

### Configuración

El script incluye variables configurables al inicio del archivo:

```lua
local BOUNCE_FORCE = 75        -- Fuerza del impulso (50-100 recomendado)
local COOLDOWN_TIME = 0.7      -- Tiempo entre saltos en segundos
local BOUNCE_DURATION = 0.3    -- Duración de la animación visual
local SCALE_FACTOR = 0.85      -- Factor de compresión (0.85 = 15% más pequeño)
```

### Cómo funciona

1. Cuando un jugador toca la parte superior del trampolín con su `HumanoidRootPart`
2. El script verifica que no esté en cooldown
3. Aplica un `BodyVelocity` hacia arriba con la fuerza configurada
4. Reproduce el efecto visual de compresión usando `TweenService`
5. Reproduce el sonido (si está configurado)
6. Activa el cooldown para ese jugador

### Requisitos cumplidos

- ✅ Impulso suave usando `BodyVelocity` (no instantáneo)
- ✅ Detección solo del `HumanoidRootPart`
- ✅ Sistema de cooldown de 0.7 segundos (configurable)
- ✅ Script normal (no LocalScript)
- ✅ Objeto anclado y estable
- ✅ Código comentado y limpio
- ✅ Efecto visual de rebote con Tween
- ✅ Soporte para sonido de salto

### Solución de problemas

**El trampolín no funciona:**
- Verifica que el objeto tenga `Anchored = true`
- Asegúrate de usar un Script, no un LocalScript
- Revisa la consola de Output por mensajes de error

**El impulso es muy fuerte/débil:**
- Ajusta el valor de `BOUNCE_FORCE` (50-100)

**Se activa desde los lados:**
- El script ya filtra por velocidad vertical para evitar esto

**El efecto visual no se ve:**
- Verifica que `SCALE_FACTOR` esté entre 0.7 y 0.95
- Ajusta `BOUNCE_DURATION` para hacerlo más visible

### Licencia

Este proyecto es de código abierto y puede ser usado libremente.