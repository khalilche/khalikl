--[[
    ROBLOX TRAMPOLINE SCRIPT
    
    Descripción:
    Este script convierte un objeto (cilindro/plataforma) en un trampolín funcional.
    Cuando un jugador toca la parte superior, es impulsado hacia arriba con un efecto suave.
    
    Características:
    - Detecta solo el HumanoidRootPart del jugador
    - Impulso suave y controlado hacia arriba
    - Sistema de cooldown para evitar activaciones múltiples
    - Efecto visual de rebote (opcional)
    - Sonido de salto (opcional)
    - El objeto permanece anclado y estable
    
    Instalación:
    1. Coloca este script como Script (NO LocalScript) dentro del objeto trampolín
    2. Asegúrate de que el objeto tenga Anchored = true
    3. Opcional: Añade un sonido llamado "JumpSound" dentro del script
]]

-- ============================================================================
-- CONFIGURACIÓN
-- ============================================================================

local trampoline = script.Parent -- El objeto que actuará como trampolín
local BOUNCE_FORCE = 75 -- Fuerza del impulso hacia arriba (ajustable: 50-100)
local COOLDOWN_TIME = 0.7 -- Tiempo de espera entre saltos (segundos)
local BOUNCE_DURATION = 0.3 -- Duración del efecto visual de rebote (segundos)
local SCALE_FACTOR = 0.85 -- Factor de compresión del trampolín (0.8 = 20% más pequeño)

-- ============================================================================
-- VARIABLES DE ESTADO
-- ============================================================================

local playersOnCooldown = {} -- Tabla para rastrear jugadores en cooldown
local isBouncing = false -- Estado del efecto visual

-- ============================================================================
-- SERVICIOS DE ROBLOX
-- ============================================================================

local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- ============================================================================
-- FUNCIONES AUXILIARES
-- ============================================================================

--[[
    Reproduce el efecto visual de rebote del trampolín
    Comprime el objeto brevemente para simular el impacto
]]
local function playBounceEffect()
    if isBouncing then return end
    isBouncing = true
    
    -- Guardar el tamaño original
    local originalSize = trampoline.Size
    local originalPosition = trampoline.Position
    
    -- Crear el tamaño comprimido (más bajo en Y)
    local compressedSize = Vector3.new(
        originalSize.X,
        originalSize.Y * SCALE_FACTOR,
        originalSize.Z
    )
    
    -- Ajustar la posición para que se comprima hacia abajo
    local compressedPosition = Vector3.new(
        originalPosition.X,
        originalPosition.Y - (originalSize.Y - compressedSize.Y) / 2,
        originalPosition.Z
    )
    
    -- Información del Tween para comprimir
    local tweenInfoCompress = TweenInfo.new(
        BOUNCE_DURATION / 2, -- Duración de la compresión
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out,
        0, -- Sin repetición
        false, -- Sin reversa
        0 -- Sin delay
    )
    
    -- Información del Tween para expandir
    local tweenInfoExpand = TweenInfo.new(
        BOUNCE_DURATION / 2, -- Duración de la expansión
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    
    -- Crear los tweens
    local compressTween = TweenService:Create(trampoline, tweenInfoCompress, {
        Size = compressedSize,
        Position = compressedPosition
    })
    
    local expandTween = TweenService:Create(trampoline, tweenInfoExpand, {
        Size = originalSize,
        Position = originalPosition
    })
    
    -- Ejecutar la animación de compresión
    compressTween:Play()
    
    -- Cuando termine la compresión, expandir
    compressTween.Completed:Connect(function()
        expandTween:Play()
    end)
    
    -- Cuando termine la expansión, restablecer el estado
    expandTween.Completed:Connect(function()
        isBouncing = false
    end)
end

--[[
    Reproduce el sonido de salto si existe
]]
local function playJumpSound()
    local jumpSound = script:FindFirstChild("JumpSound")
    if jumpSound and jumpSound:IsA("Sound") then
        jumpSound:Play()
    end
end

--[[
    Verifica si un jugador está en cooldown
    @param player - El jugador a verificar
    @return boolean - true si está en cooldown, false si no
]]
local function isPlayerOnCooldown(player)
    return playersOnCooldown[player.UserId] ~= nil
end

--[[
    Pone a un jugador en cooldown
    @param player - El jugador a poner en cooldown
]]
local function setPlayerCooldown(player)
    playersOnCooldown[player.UserId] = true
    
    -- Remover el cooldown después del tiempo especificado
    task.delay(COOLDOWN_TIME, function()
        playersOnCooldown[player.UserId] = nil
    end)
end

--[[
    Aplica el impulso hacia arriba al jugador
    @param humanoidRootPart - La parte raíz del humanoide
]]
local function applyBounceForce(humanoidRootPart)
    -- Crear un BodyVelocity para el impulso suave
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0) -- Solo afecta el eje Y
    bodyVelocity.Velocity = Vector3.new(0, BOUNCE_FORCE, 0) -- Impulso hacia arriba
    bodyVelocity.Parent = humanoidRootPart
    
    -- Remover el BodyVelocity después de un breve momento para un impulso suave
    Debris:AddItem(bodyVelocity, 0.2)
end

--[[
    Maneja el evento de toque en el trampolín
    @param hit - La parte que tocó el trampolín
]]
local function onTouched(hit)
    -- Verificar que la parte que tocó sea un HumanoidRootPart
    if hit.Name ~= "HumanoidRootPart" then
        return
    end
    
    -- Obtener el personaje y el jugador
    local character = hit.Parent
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return
    end
    
    local player = game.Players:GetPlayerFromCharacter(character)
    if not player then return end
    
    -- Verificar si el jugador está en cooldown
    if isPlayerOnCooldown(player) then
        return
    end
    
    -- Verificar que el jugador esté cayendo o tocando desde arriba
    -- Esto evita que el trampolín se active al tocar los lados
    local velocity = hit.AssemblyLinearVelocity
    if velocity.Y > 5 then
        -- El jugador está subiendo rápidamente, no activar
        return
    end
    
    -- Aplicar el cooldown
    setPlayerCooldown(player)
    
    -- Aplicar el impulso al jugador
    applyBounceForce(hit)
    
    -- Reproducir efectos visuales y sonoros
    playBounceEffect()
    playJumpSound()
end

-- ============================================================================
-- INICIALIZACIÓN
-- ============================================================================

--[[
    Configura el trampolín y conecta los eventos
]]
local function initialize()
    -- Asegurarse de que el trampolín esté anclado
    if trampoline:IsA("BasePart") then
        trampoline.Anchored = true
    end
    
    -- Conectar el evento de toque
    trampoline.Touched:Connect(onTouched)
    
    print("[Trampoline] Script inicializado correctamente en:", trampoline.Name)
end

-- Inicializar el script
initialize()

--[[
    NOTAS DE USO:
    
    1. Ajuste de la fuerza:
       - Modifica BOUNCE_FORCE para cambiar la altura del salto
       - Valores recomendados: 50-100 (50 = salto bajo, 100 = salto alto)
    
    2. Cooldown:
       - Modifica COOLDOWN_TIME para cambiar el tiempo entre saltos
       - Valores recomendados: 0.5-1.0 segundos
    
    3. Sonido (opcional):
       - Crea un objeto Sound dentro de este script
       - Nómbralo "JumpSound"
       - Asigna el audio que desees (ej: rbxassetid://1234567890)
    
    4. Personalización visual:
       - Ajusta SCALE_FACTOR para cambiar el efecto de compresión
       - Ajusta BOUNCE_DURATION para la velocidad de la animación
    
    5. Solución de problemas:
       - Si el trampolín no funciona, verifica que Anchored = true
       - Si se activa desde los lados, el script ya filtra por velocidad Y
       - Si el impulso es muy fuerte/débil, ajusta BOUNCE_FORCE
]]
