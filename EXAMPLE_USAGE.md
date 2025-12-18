# Ejemplo de Uso - Trampolin Script

Este documento proporciona ejemplos prácticos de cómo implementar y personalizar el script del trampolín en Roblox Studio.

## Instalación Paso a Paso

### 1. Crear el Objeto Trampolín

1. Abre **Roblox Studio**
2. En el **Explorer**, selecciona **Workspace**
3. Inserta una **Part** (Insertar → Part) o usa un cilindro existente
4. Configura las propiedades del objeto:
   - **Anchored**: ✅ true (MUY IMPORTANTE)
   - **Size**: Ajusta al tamaño deseado (ej: 8, 1, 8)
   - **Shape**: Cylinder (recomendado para trampolines)
   - **Color**: A tu gusto (ej: azul para simular un trampolín)

### 2. Añadir el Script

1. Haz clic derecho en el objeto trampolín en el **Explorer**
2. Selecciona **Insert Object** → **Script** (NO LocalScript)
3. Elimina el código por defecto en el script
4. Copia y pega el código completo de `Trampoline.lua`
5. Presiona **Ctrl+S** para guardar

### 3. Probar el Trampolín

1. Presiona **F5** o el botón **Play** para probar en el juego
2. Camina hacia el trampolín y salta sobre él
3. Deberías ser impulsado hacia arriba con un efecto suave

## Personalización

### Ejemplo 1: Trampolín de Baja Altura

Para un trampolín que impulse suavemente (bueno para áreas interiores):

```lua
local BOUNCE_FORCE = 50        -- Salto bajo
local COOLDOWN_TIME = 0.5      -- Cooldown corto
```

### Ejemplo 2: Super Trampolín

Para un trampolín muy potente (áreas de parkour o desafíos):

```lua
local BOUNCE_FORCE = 120       -- Salto muy alto
local COOLDOWN_TIME = 1.0      -- Cooldown más largo para seguridad
```

### Ejemplo 3: Trampolín Realista

Para simular un trampolín real de gimnasia:

```lua
local BOUNCE_FORCE = 75        -- Altura media
local COOLDOWN_TIME = 0.7      -- Tiempo realista
local BOUNCE_DURATION = 0.4    -- Animación más lenta
local SCALE_FACTOR = 0.8       -- Compresión más visible
```

## Añadir Sonido

### Paso a Paso para Añadir Sonido de Salto

1. En el **Explorer**, localiza tu **Script** del trampolín
2. Haz clic derecho en el script → **Insert Object** → **Sound**
3. Selecciona el objeto Sound que acabas de crear
4. En las **Properties**, cambia:
   - **Name**: `JumpSound` (debe ser exactamente este nombre)
   - **SoundId**: ID del sonido de Roblox (ver abajo)
   - **Volume**: 0.5 (ajusta a tu preferencia)
   - **PlaybackSpeed**: 1.0 (o ajusta para efectos)

### IDs de Sonidos Recomendados

Aquí algunos IDs de sonidos de Roblox que funcionan bien para trampolines:

```lua
-- Sonido de rebote suave
rbxassetid://6783289446

-- Sonido de boing clásico
rbxassetid://6718380055

-- Sonido de salto/spring
rbxassetid://5897796203

-- Sonido de whoosh
rbxassetid://5855279225
```

**Nota**: Para usar estos sonidos:
1. Copia el ID completo (ej: `rbxassetid://6783289446`)
2. Pégalo en la propiedad **SoundId** del objeto Sound

## Solución de Problemas Comunes

### ❌ El trampolín no funciona en absoluto

**Posibles causas:**
- El objeto no está anclado (`Anchored = false`)
- Usaste un LocalScript en lugar de un Script normal
- El script tiene errores de sintaxis

**Solución:**
1. Verifica que `Anchored = true` en las propiedades del objeto
2. Asegúrate de usar un **Script**, no un **LocalScript**
3. Revisa la ventana **Output** (View → Output) por errores

### ❌ El trampolín se activa cuando toco los lados

**Explicación:**
El script ya incluye protección contra esto. Verifica que la línea 193-198 esté presente:

```lua
local velocity = hit.AssemblyLinearVelocity
if velocity.Y > 5 then
    return
end
```

Si aún ocurre, puedes aumentar el umbral de `5` a `10` para mayor filtrado.

### ❌ El impulso es demasiado fuerte/débil

**Solución:**
Ajusta el valor de `BOUNCE_FORCE`:
- **Muy débil**: Aumenta a 80-100
- **Muy fuerte**: Disminuye a 50-60
- **Recomendado**: 70-80 para la mayoría de casos

### ❌ El efecto visual no se nota

**Solución:**
Aumenta la compresión visual:
```lua
local SCALE_FACTOR = 0.7       -- Compresión más pronunciada (más pequeño)
local BOUNCE_DURATION = 0.5    -- Animación más lenta (más visible)
```

### ❌ Los jugadores pueden spammear el trampolín

**Explicación:**
Esto no debería ocurrir si el cooldown está funcionando. Verifica que estas líneas estén presentes:

```lua
if isPlayerOnCooldown(player) then
    return
end
```

Si quieres un cooldown más largo:
```lua
local COOLDOWN_TIME = 1.5  -- 1.5 segundos entre saltos
```

## Múltiples Trampolines

Para crear varios trampolines en tu juego:

1. **Método 1: Copiar y pegar**
   - Copia el objeto trampolín completo (con el script)
   - Pégalo en diferentes ubicaciones
   - Cada uno funcionará independientemente

2. **Método 2: Scripts individuales**
   - Crea cada trampolín por separado
   - Añade el script a cada uno
   - Personaliza cada uno con diferentes valores

## Integración con Sistemas Existentes

### Compatibilidad con Checkpoints

El script es compatible con sistemas de checkpoints. No interfiere con la mecánica de respawn.

### Compatibilidad con Sistemas de Stamina

Si tu juego tiene sistema de stamina, puedes modificar la función `onTouched` para verificar el stamina:

```lua
local function onTouched(hit)
    -- ... código existente ...
    
    -- Verificar stamina (ejemplo)
    local playerData = game.ServerStorage.PlayerData:FindFirstChild(player.Name)
    if playerData and playerData.Stamina.Value < 10 then
        return  -- No activar si no hay suficiente stamina
    end
    
    -- ... resto del código ...
end
```

### Uso en Obbies/Parkour

El script es ideal para juegos de obstáculos. Considera:
- Usar `BOUNCE_FORCE = 85-95` para altura considerable
- `COOLDOWN_TIME = 0.5` para fluidez en el gameplay
- Añadir colores brillantes o efectos de partículas para visibilidad

## Tips Adicionales

### 1. Efectos Visuales Extra

Puedes añadir partículas al trampolín:
1. Insert → ParticleEmitter en el objeto trampolín
2. Configura para que emita hacia abajo cuando alguien salte
3. Modifica el script para activar las partículas en `playBounceEffect()`

### 2. Trampolines Direccionales

Modifica la línea del BodyVelocity para impulsar en direcciones específicas:

```lua
-- Impulso diagonal
bodyVelocity.Velocity = Vector3.new(10, BOUNCE_FORCE, 10)

-- Impulso hacia adelante
bodyVelocity.Velocity = trampoline.CFrame.LookVector * 50 + Vector3.new(0, BOUNCE_FORCE, 0)
```

### 3. Trampolines Activables

Para trampolines que solo funcionan bajo ciertas condiciones:

```lua
local trampolineActive = true  -- Variable global

local function onTouched(hit)
    if not trampolineActive then
        return  -- No hacer nada si está desactivado
    end
    -- ... resto del código ...
end

-- Para activar/desactivar desde otro script:
-- script.Parent.TrampolineActive.Value = false
```

## Preguntas Frecuentes

**P: ¿Funciona en móvil/tablet?**
R: Sí, el script es completamente compatible con todas las plataformas de Roblox.

**P: ¿Puedo vender juegos con este script?**
R: Sí, es código abierto y puede usarse libremente en proyectos comerciales.

**P: ¿Afecta el rendimiento del juego?**
R: Mínimamente. El script es eficiente y usa cooldowns para evitar cálculos innecesarios.

**P: ¿Funciona con NPCs/bots?**
R: Actualmente solo funciona con jugadores reales. Para NPCs necesitarías modificar la función `onTouched`.

**P: ¿Puedo cambiar el color del trampolín mientras rebota?**
R: Sí, añade esto en `playBounceEffect()`:

```lua
local originalColor = trampoline.Color
trampoline.Color = Color3.fromRGB(0, 255, 0)  -- Verde brillante
task.delay(0.2, function()
    trampoline.Color = originalColor
end)
```

## Créditos y Soporte

Script creado para la comunidad de Roblox. Para reportar problemas o sugerencias, visita el repositorio de GitHub.

**¡Disfruta creando experiencias divertidas con trampolines en Roblox!** 🎮🦘
