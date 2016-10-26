if not(GetLocale() == "esES") then
    return;
end

local L = WeakAuras.L

-- Options translation
L["<"] = "<"
L["<="] = "<="
L["="] = "="
L[">"] = ">"
L[">="] = ">="
L["!="] = "!="
L["10 Man Raid"] = "Banda de 10 Jugadores"
-- L["20 Man Raid"] = ""
L["25 Man Raid"] = "Banda de 25 Jugadores"
L["40 Man Raid"] = "Banda de 40 Jugadores" -- Needs review
L["5 Man Dungeon"] = "Mazmorra de 5 Jugadores"
L["Absorb"] = "Absorción"
L["Absorbed"] = "Absorbido"
L["Action Usable"] = "Acción Utilizable"
-- L["Additional Trigger Replacements"] = ""
L["Affected"] = "Afectado"
-- L["Aggro"] = ""
L["Alive"] = "Vivo"
L["Alliance"] = "Alianza" -- Needs review
-- L["Allow partial matches"] = ""
L["All Triggers"] = "Todos los Disparadores"
L["Alternate Power"] = "Energía Alternativa"
-- L["Always"] = ""
L["Always active trigger"] = "Siempre activar disparador" -- Needs review
L["Ambience"] = "Ambiente"
L["Amount"] = "Cantidad"
-- L["Anticlockwise"] = ""
L["Any Triggers"] = "Cualquier Disparador"
L["Arena"] = "Arena"
L["Ascending"] = "Ascendente"
L["Assist"] = "Asistencia" -- Needs review
L["At Least One Enemy"] = "Como Mínimo un Enemigo"
L["Attackable"] = "Atacable"
L["Aura"] = "Aura"
L["Aura:"] = "Aura:"
L["Aura Applied"] = "Aura Aplicada"
L["Aura Applied Dose"] = "Aura Aplicada Dosis"
L["Aura Broken"] = "Aura Rota"
L["Aura Broken Spell"] = "Aura Hechizo Roto"
L["Aura Name"] = "Nombre del Aura o ID" -- Needs review
L["Aura Refresh"] = "Aura Refrescada"
L["Aura Removed"] = "Aura Eliminada"
L["Aura Removed Dose"] = "Aura Eliminada Dosis"
L["Auras:"] = "Auras:"
L["Aura Stack"] = "Acumulación de Auras"
L["Aura Type"] = "Tipo de Aura"
L["Automatic"] = "Automático"
-- L["Automatic Rotation"] = ""
-- L["Back"] = ""
L["Back and Forth"] = "De Atrás a Adelante"
L["Battleground"] = "Campo de Batalla"
L["Battle.net Whisper"] = "Battle.net Mensaje"
L["BG>Raid>Party>Say"] = "CdB>Raid>Grupo>Decir"
L["BG-System Alliance"] = "Campo de Batalla - Alianza"
L["BG-System Horde"] = "Campo de Batalla - Horda"
L["BG-System Neutral"] = "Campo de Batalla - Neutral"
L["BigWigs Addon"] = "Addon de BigWigs" -- Needs review
-- L["BigWigs Message"] = ""
L["BigWigs Timer"] = "Temporizador de BigWigs" -- Needs review
L["Blizzard Combat Text"] = "Texto de Combate de Blizzard"
L["Block"] = "Bloqueo"
L["Blocked"] = "Bloqueado"
L["Boss Emote"] = "Jefe - Emoción"
-- L["Boss Whisper"] = ""
L["Bottom"] = "Abajo"
L["Bottom Left"] = "Abajo Izquierda"
L["Bottom Right"] = "Abajo Derecha"
L["Bottom to Top"] = "De Abajo a Arriba"
L["Bounce"] = "Rebotar"
L["Bounce with Decay"] = "Rebotar con Amortiguación"
L["Buff"] = "Beneficio"
L["Cast"] = "Lanzar Hechizo"
-- L["Caster"] = ""
L["Cast Failed"] = "Hechizo - Fallido"
L["Cast Start"] = "Hechizo - Empezar"
L["Cast Success"] = "Hechizo - Completado"
L["Cast Type"] = "Tipo de Hechizo"
L["Center"] = "Centro"
L["Centered Horizontal"] = "Centrado Horizontal"
L["Centered Vertical"] = "Centrado Vertical"
-- L["Challenge"] = ""
L["Channel"] = "Canal"
L["Channel (Spell)"] = "Canalizar Hechizo"
L["Character Type"] = "Tipo de Personaje"
L["Charges"] = "Cargas" -- Needs review
L["Chat Frame"] = "Pantalla de Chat"
L["Chat Message"] = "Mensaje de Chat"
-- L["Chest"] = ""
L["Children:"] = "Hijos:"
L["Circle"] = "Círculo"
L["Circular"] = "Circular"
L["Class"] = "Clase"
L["Click to close configuration"] = "Clic para cerrar la configuración"
L["Click to open configuration"] = "Clic para abrir la configuración"
-- L["Clockwise"] = ""
-- L["Clone per Event"] = ""
-- L["Clone per Match"] = ""
L["Combat Log"] = "Registro de Combate"
L["Conditions"] = "Condiciones"
L["Contains"] = "Contiene"
-- L["Cooldown Progress (Equipment Slot)"] = ""
L["Cooldown Progress (Item)"] = "Recarga en Progreso (Objeto)"
L["Cooldown Progress (Spell)"] = "Recarga en Progreso (Hechizo)"
L["Cooldown Ready (Item)"] = "Recarga Lista (Objeto)"
L["Cooldown Ready (Spell)"] = "Recarga Lista (Hechizo)"
L["Create"] = "Crear"
L["Critical"] = "Crítico"
L["Crowd Controlled"] = "Bajo Control"
L["Crushing"] = "Golpe Aplastador"
L["Curse"] = "Maldición"
L["Custom"] = "Personalizado"
L["Custom Function"] = "Función Personalizada"
L["Damage"] = "Daño"
L["Damager"] = "Atacante"
L["Damage Shield"] = "Escudo Dañino"
L["Damage Shield Missed"] = "Escudo Dañino Fallido"
L["Damage Split"] = "Daño Repartido"
L["DBM Announce"] = "Anuncio de DBM" -- Needs review
L["DBM Timer"] = "Temporizador de DBM" -- Needs review
L["Death Knight Rune"] = "Caballero de la Muerte - Runa"
L["Debuff"] = "Perjuicio"
L["Defensive"] = "Defensivo" -- Needs review
L["Deflect"] = "Desviar"
L["Descending"] = "Descendente"
L["Destination Name"] = "Nombre del Destino"
L["Destination Unit"] = "Unidad de Destino"
L["Dialog"] = "Diálogo" -- Needs review
L["Disease"] = "Enfermedad"
L["Dispel"] = "Disipar"
L["Dispel Failed"] = "Disipar Fallido"
L["Dodge"] = "Esquivar"
L["Done"] = "Finalizado"
L["Down"] = "Abajo"
L["Drain"] = "Drenar"
L["Drowning"] = "Ahogar"
L["Dungeon Difficulty"] = "Dificultad de la Mazmorra"
L["Durability Damage"] = "Daño a la Durabilidad"
L["Durability Damage All"] = "Daño a la Durabilidad Total"
L["Emote"] = "Emocion"
-- L["Empty"] = ""
L["Encounter ID"] = "ID de Encuentro" -- Needs review
L["Energize"] = "Vigorizar"
L["Enrage"] = "Enfurecido"
L["Environmental"] = "Ambiental"
L["Environment Type"] = "Tipo de Entorno"
-- L["Equipment Slot"] = ""
L["Evade"] = "Evadir"
L["Event"] = "Evento"
L["Event(s)"] = "Evento(s)"
L["Every Frame"] = "Cada Uno de los Marcos"
L["Extra Amount"] = "Cantidad Adicional"
L["Extra Attacks"] = "Ataques Adicional"
L["Extra Spell Name"] = "Nombre del Hechizo Extra"
L["Fade In"] = "Aparecer"
L["Fade Out"] = "Desaparecer"
L["Fail Alert"] = "Alerta de Fallo" -- Needs review
L["Falling"] = "Caer"
L["Fatigue"] = "Fatiga"
-- L["Feet"] = ""
-- L["Finger 1"] = ""
-- L["Finger 2"] = ""
L["Fire"] = "Fuego"
-- L["Fishing Lure / Weapon Enchant (Old)"] = ""
L["Flash"] = "Destello"
L["Flex Raid"] = "Banda Flexible" -- Needs review
L["Flip"] = "Voltear"
L["Focus"] = "Foco"
L["Form"] = "Forma"
L["Friendly"] = "Amistoso"
L["Friendly Fire"] = "Fuego Amigo" -- Needs review
L["From"] = "Desde"
-- L["Full"] = ""
-- L["Full/Empty"] = ""
L["Glancing"] = "de refilón"
L["Global Cooldown"] = "Recarga Global"
L["Glow"] = "Brillante"
L["Gradient"] = "Degradado"
L["Gradient Pulse"] = "Degradado Pulsante"
L["Group"] = "Grupo"
L["Group %s"] = "Grupo %s"
L["Grow"] = "Crecer"
L["GTFO Alert"] = "Alerta GTFO" -- Needs review
L["Guild"] = "Hermandad"
-- L["Hands"] = ""
L["HasPet"] = "Mascota viva"
-- L["Has Vehicle UI"] = ""
-- L["Head"] = ""
L["Heal"] = "Cura"
L["Healer"] = "Sanador"
L["Health"] = "Salud"
L["Health (%)"] = "Vida (%)"
L["Heroic"] = "Heroico"
L["Hide"] = "Ocultar"
L["High Damage"] = "Alto Daño" -- Needs review
L["Higher Than Tank"] = "Mayor Que el Tanque"
L["Horde"] = "Horda" -- Needs review
L["Hostile"] = "Hostil"
L["Hostility"] = "Holstilidad"
L["Humanoid"] = "Humanoide"
-- L["Hybrid"] = ""
L["Icon"] = "Icono"
-- L["Id"] = ""
L["Ignore Rune CD"] = "Ignorar Recarga de Runas"
L["Immune"] = "Inmune"
L["Include Bank"] = "Incluye el Banco"
L["Include Charges"] = "Incluye las Cargas"
L["In Combat"] = "En Combate"
L["Inherited"] = "Heredado"
L["In Pet Battle"] = "En duelo de mascotas"
L["Inside"] = "Dentro"
L["Instakill"] = "Muerte Instantanea"
-- L["Instance"] = ""
L["Instance Type"] = "Tipo de Instancia"
L["Interrupt"] = "Interrupcion"
L["Interruptible"] = "Interrumpible"
L["In Vehicle"] = "Conduciendo"
L["Inverse"] = "Inverso"
L["Is Exactly"] = "Es Exactamente"
L["Is Moving"] = "se está moviendo" -- Needs review
-- L["Is Off Hand"] = ""
-- L["is useable"] = ""
L["Item"] = "Objeto"
L["Item Count"] = "Contar los Objetos"
L["Item Equipped"] = "Objeto Equipado"
-- L["Item Set"] = ""
-- L["Item Set Equipped"] = ""
L["Lava"] = "Lava"
L["Leech"] = "Parasitar"
L["Left"] = "Izquierda"
L["Left to Right"] = "De Izquierda a Derecha"
-- L["Legs"] = ""
L["Level"] = "Nivel"
-- L["Looking for Raid"] = ""
L["Low Damage"] = "Bajo Daño" -- Needs review
L["Lower Than Tank"] = "Menor Que el Tanque"
L["Magic"] = "Magia"
L["Main Hand"] = "Mano Principal"
-- L["Manual Rotation"] = ""
-- L["Marked First"] = ""
-- L["Marked Last"] = ""
L["Master"] = "Maestro"
L["Matches (Pattern)"] = "Corresponde (Patrón)"
L["Message"] = "Mensaje"
L["Message type:"] = "Tipo de Mensaje:"
L["Message Type"] = "Tipo de Mensaje"
L["Miss"] = "Fallo"
L["Missed"] = "Fallado"
L["Missing"] = "Ausente"
L["Miss Type"] = "Tipo de Fallo"
L["Monochrome"] = "Monocromo" -- Needs review
L["Monochrome Outline"] = "Monocromo" -- Needs review
L["Monochrome Thick Outline"] = "Borde gordo monocromo" -- Needs review
-- L["Monster Emote"] = ""
-- L["Monster Party"] = ""
-- L["Monster Say"] = ""
-- L["Monster Whisper"] = ""
L["Monster Yell"] = "Grito de Monstruo"
L["Mounted"] = "Montado"
-- L["Multistrike"] = ""
L["Multi-target"] = "Objetivo Múltiple"
L["Music"] = "Música"
-- L["Mythic"] = ""
L["Name"] = "Nombre"
-- L["Neck"] = ""
L["Neutral"] = "Neutral" -- Needs review
L["Never"] = "Nunca"
L["Next"] = "Siguiente"
L["No Children:"] = "Sin dependientes"
L["No Instance"] = "Fuera de Instancia"
L["None"] = "Nada"
L["Non-player Character"] = "Personaje No Jugador"
L["Normal"] = "Normal"
-- L["Not on cooldown"] = ""
L["Not On Threat Table"] = "No Está En La Tabla De Amenaza"
L["Number"] = "Número"
L["Number Affected"] = "Dependiente de números"
L["Off Hand"] = "Mano Secundaria"
L["Officer"] = "Oficial"
-- L["On cooldown"] = ""
-- L["Only if Primary"] = ""
L["Opaque"] = "Opaco"
L["Orbit"] = "Orbitar"
L["Outline"] = "Linea exterior"
L["Outside"] = "Fuera"
L["Overhealing"] = "Sobre Curación"
L["Overkill"] = "Muerte de Más"
L["Parry"] = "Parar"
L["Party"] = "Grupo"
L["Party Kill"] = "Muerte de Grupo"
L["Passive"] = "Pasivo" -- Needs review
L["Paused"] = "Pausado"
L["Periodic Spell"] = "Hechizo Periódico"
L["Pet"] = "Mascota"
L["Pet Behavior"] = "Comportamiento de mascota"
L["Player"] = "Jugador"
L["Player Character"] = "Personaje Jugador"
L["Player Class"] = "Clase del Jugador"
L["Player Dungeon Role"] = "Rol en Mazmorra del Jugador"
L["Player Faction"] = "Facción del jugador" -- Needs review
L["Player Level"] = "Nivel del Personaje"
L["Player Name"] = "Nombre del Jugador"
L["Player Race"] = "Raza del Jugador" -- Needs review
L["Player(s) Affected"] = "Jugador(es) Afectados"
L["Player(s) Not Affected"] = "Jugador(es) no Afectados"
L["Poison"] = "Veneno"
L["Power"] = "Poder"
L["Power (%)"] = "Poder  (%)"
L["Power Type"] = "Tipo de Poder"
L["Preset"] = "Predefinido"
L["Progress"] = "Progreso"
L["Pulse"] = "Pulso"
L["PvP Flagged"] = "Marcado JcJ"
-- L["PvP Talent selected"] = ""
L["Radius"] = "Radio"
L["Raid"] = "Banda"
L["Raid Warning"] = "Alerta de Banda"
L["Range"] = "Rango"
-- L["Ready Check"] = ""
L["Realm"] = "Reino" -- Needs review
L["Receiving display information"] = "Recibiendo información de aura de %s..."
L["Reflect"] = "Reflejar"
-- L["Region type %s not supported"] = ""
L["Relative"] = "Relativo"
L["Remaining Time"] = "Tiempo Restante"
L["Requested display does not exist"] = "El aura requerida no existe"
L["Requested display not authorized"] = "El aura requerida no está autorizada"
L["Require Valid Target"] = "Requiere Objetivo Válido"
L["Resist"] = "Resistir"
L["Resisted"] = "Resistido"
L["Resolve collisions dialog"] = "Resolver colisiones en dialogos"
L["Resolve collisions dialog singular"] = "Resolver colisiones en dialogos singulares"
L["Resolve collisions dialog startup"] = "Resolver colisiones en dialogos inicial"
L["Resolve collisions dialog startup singular"] = "Resolver colisiones en dialogos singulares inicial"
L["Resting"] = "Descansado"
L["Resurrect"] = "Resucitar"
L["Right"] = "Derecha"
L["Right to Left"] = "De Derecha a Izquierda"
L["Rotate Left"] = "Rotar a la Izquierda"
L["Rotate Right"] = "Rotar a la Derecha"
L["Rune"] = "Runa"
-- L["Rune #1"] = ""
-- L["Rune #2"] = ""
-- L["Rune #3"] = ""
-- L["Rune #4"] = ""
-- L["Rune #5"] = ""
-- L["Rune #6"] = ""
-- L["Runes Count"] = ""
-- L["%s - 1. Trigger"] = ""
-- L["%s - Alpha Animation"] = ""
L["Say"] = "Decir"
-- L["Scenario"] = ""
-- L["%s - Color Animation"] = ""
-- L["%s - Custom Text"] = ""
-- L["%s Duration Function"] = ""
L["Seconds"] = "Segundos"
-- L["%s - Finish"] = ""
-- L["%s - Finish Action"] = ""
L["Shake"] = "Sacudida"
L["Shift-Click to pause"] = "Mayúsculas-Clic para pausar"
L["Shift-Click to resume"] = "Mayúsculas-Clic para continuar"
-- L["Shoulder"] = ""
L["Show"] = "Mostrar"
-- L["Show Code"] = ""
L["Shrink"] = "Encoger"
-- L["%s Icon Function"] = ""
-- L["%s - Init Action"] = ""
-- L["%s - %i. Trigger"] = ""
L["Slide from Bottom"] = "Arrastrar Desde Abajo"
L["Slide from Left"] = "Arrastrar Desde la Izquierda"
L["Slide from Right"] = "Arrastrar Desde la Derecha"
L["Slide from Top"] = "Arrastrar Desde Arriba"
L["Slide to Bottom"] = "Arrastrar Hacia Abajo"
L["Slide to Left"] = "Arrastrar Hacia la Izquierda"
L["Slide to Right"] = "Arrastrar Hacia la Derecha"
L["Slide to Top"] = "Arrastrar Hacia Arriba"
L["Slime"] = "Baba"
-- L["%s - Main"] = ""
-- L["%s Name Function"] = ""
L["Sound Effects"] = "Efectos de Sonido"
L["Source Name"] = "Nombre de Origen"
L["Source Unit"] = "Unidad Origen"
L["Spacing"] = "Espaciado"
L["Specific Unit"] = "Unidad Específica"
L["Spell"] = "Hechizo"
L["Spell (Building)"] = "Hechizo (en curso)"
-- L["Spell/Encounter Id"] = ""
-- L["Spell Id"] = ""
-- L["Spell ID"] = ""
-- L["Spell Known"] = ""
L["Spell Name"] = "Nombre del Hechizo"
L["Spin"] = "Girar"
L["Spiral"] = "Espiral"
L["Spiral In And Out"] = "Espiral de Dentro a Fuera"
-- L["%s - Rotate Animation"] = ""
-- L["%s - Scale Animation"] = ""
-- L["%s Stacks Function"] = ""
-- L["%s - Start"] = ""
-- L["%s - Start Action"] = ""
L["Stacks"] = "Acumulaciones"
-- L["Stagger"] = ""
L["Stance/Form/Aura"] = "Impostura/Forma/Aura"
L["Status"] = "Estado"
-- L["%s Texture Function"] = ""
L["Stolen"] = "Robado"
-- L["%s total auras"] = ""
-- L["%s - Translate Animation"] = ""
-- L["%s Trigger Function"] = ""
-- L["%s - Trigger Logic"] = ""
L["Summon"] = "Invocar"
-- L["%s Untrigger Function"] = ""
L["Swing"] = "Golpe"
L["Swing Timer"] = "Temporizador de Golpes"
-- L["System"] = ""
-- L["Tabard"] = ""
L["Talent selected"] = "Talento seleccionado" -- Needs review
L["Talent Specialization"] = "Especialización de Talentos"
L["Tank"] = "Tanque"
L["Tanking And Highest"] = "Tanqueando y el más alto"
L["Tanking But Not Highest"] = "Tanqueando pero no el mas alto"
L["Target"] = "Objetivo"
L["Thick Outline"] = "Linea exterior gruesa"
L["Threat Situation"] = "Situación de la Amenaza"
L["Tier "] = "Tier" -- Needs review
L["Timed"] = "Temporizado"
-- L["Timewalking"] = ""
L["Top"] = "Superior"
L["Top Left"] = "Superior Izquierda"
L["Top Right"] = "Superior Derecha"
L["Top to Bottom"] = "De Arriba a Abajo"
L["Total"] = "Total"
L["Totem"] = "Tótem"
-- L["Totem #%i"] = ""
L["Totem Name"] = "Nombre del Tótem"
-- L["Totem Number"] = ""
L["Transmission error"] = "Error de transmisión"
L["Trigger:"] = "Disparador:"
-- L["Trigger State Updater"] = ""
L["Trigger Update"] = "Actualizaci'on del Disparador"
-- L["Trinket 1"] = ""
-- L["Trinket 2"] = ""
L["Undefined"] = "No Definido"
L["Unit"] = "Unidad"
L["Unit Characteristics"] = "Características de la unidad"
L["Unit Destroyed"] = "Unidad Destruida"
L["Unit Died"] = "Unit Muerta"
L["Up"] = "Arriba"
L["Version error received higher"] = "Éste aura es incompatible con tu versión de WeakAuras - se creó con la versión %s pero tu tienes la versión %s. Bájate la última versión de WeakAuras" -- Needs review
L["Version error received lower"] = "Éste aura es incompatible con tu versión de WeakAuras - se creó con la versión %s y tu tienes la versión %s. Pídele que se baje la última versión de WeakAuras" -- Needs review
-- L["Waist"] = ""
L["Weapon"] = "Arma"
-- L["Weapon Enchant"] = ""
L["Whisper"] = "Susurro"
L["Wobble"] = "Temblar"
-- L["Wrist"] = ""
L["Yell"] = "Grito"
L["Zone"] = "Zona"
L["Zone ID"] = "ID de Zona" -- Needs review
-- L["Zone ID List"] = ""



