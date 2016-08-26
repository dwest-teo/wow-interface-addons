--------------------------------------------------------------------------
-- GTFO_Spells_LGN.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Legion
Author: Zensunim of Malygos
]]--

--- ********************
--- * The Broken Isles *
--- ********************

GTFO.SpellID["203114"] = {
  --desc = "Twilight Whirl (Twilight Bladetwister)";
  sound = 1;
};

GTFO.SpellID["193009"] = {
  --desc = "The Jailer's Prison (Niskaran Executioner)";
  applicationOnly = true;
  sound = 1;
};

GTFO.SpellID["206702"] = {
  --desc = "Choking Fog";
  sound = 1;
};

GTFO.SpellID["219044"] = {
  --desc = "Ennervating Field (Senegos Drawing)";
  applicationOnly = true;
  sound = 2;
};

GTFO.SpellID["208069"] = {
  --desc = "Arrow Barrage (Nathanos Blightcaller)";
  sound = 1;
  tankSound = 2;
};

GTFO.SpellID["190364"] = {
  --desc = "Plague-Dipped Arrows (Nathanos Blightcaller)";
  sound = 1;
};

GTFO.SpellID["180675"] = {
  --desc = "Guardian Gaze (Vault Guardian)";
  sound = 1;
};

GTFO.SpellID["195824"] = {
  --desc = "Lightforged Defense Matrix (Yotnar)";
  sound = 1;
};

GTFO.SpellID["187117"] = {
  --desc = "Static Charge";
  sound = 1;
};

GTFO.SpellID["193907"] = {
  --desc = "Fel Winds (Fel Commander Igrius)";
  sound = 1;
};

GTFO.SpellID["202809"] = {
  --desc = "Fury of the Illidari (Varedis Felsoul)";
  sound = 1;
};

GTFO.SpellID["209928"] = {
  --desc = "Creeping Nightmare (Gorebeak)";
  applicationOnly = true;
  sound = 1;
  test = true; -- Unreliable... sometimes this is applied from unavoidable damage from mobs other than Gorebeak
};

GTFO.SpellID["192754"] = {
  --desc = "Nightmare Breath (Ysera)";
  sound = 1;
};

GTFO.SpellID["220053"] = {
  --desc = "Conductive Charge (Akama)";
  sound = 1;
};

GTFO.SpellID["215604"] = {
  --desc = "Dragon's Breath (Vision of Deathwing)";
  sound = 1;
};

-- **********
-- * Mardum *
-- **********

GTFO.SpellID["194811"] = {
	--desc = "Fel Beam";
	sound = 2;
};

GTFO.SpellID["200511"] = {
	--desc = "Anguished Soul (Anguish Jailer)";
	sound = 1;
};

GTFO.SpellID["195054"] = {
	--desc = "Beaming Gaze (Inquisitor Baleful)";
	sound = 1;
};

GTFO.SpellID["195401"] = {
	--desc = "Shadow Blaze (Doom Commander Beliash)";
	sound = 1;
};

GTFO.SpellID["192603"] = {
	--desc = "Spire of Woe (Doom Commander Beliash)";
	sound = 1;
};

GTFO.SpellID["197747"] = {
	--desc = "Fel Burning (General Volroth)";
	sound = 1;
};

GTFO.SpellID["197243"] = {
  --desc = "Gaseous Cloud (Prolifica)";
  sound = 1;
};

GTFO.SpellID["197609"] = {
  --desc = "Demon's Blood (Brood Queen Tyranna)";
  sound = 1;
};

-- ************************
-- * Vault of the Wardens *
-- ************************

GTFO.SpellID["201037"] = {
  --desc = "Seeping Shadows (Kethrazor)";
  sound = 1;
};

GTFO.SpellID["196502"] = {
  --desc = "Lingering Gaze (Glazer)";
  sound = 2;
};

GTFO.SpellID["191853"] = {
  --desc = "Furious Flames (Tirathon Saltheril)";
  sound = 1;
};

-- ********************
-- * The Broken Shore *
-- ********************


GTFO.SpellID["211195"] = {
  --desc = "Burn (Captain Naranoth)";
  sound = 1;
};

GTFO.SpellID["183623"] = {
  --desc = "Felsoul Inferno";
  sound = 1;
};

GTFO.SpellID["222588"] = {
  --desc = "Fel Immolation (Infernal Siegebreaker)";
  sound = 1;
};

GTFO.SpellID["183737"] = {
  --desc = "Felblaze (Felblaze Infernal)";
  sound = 1;
};



-- *********************
-- * Darkheart Thicket *
-- *********************

GTFO.SpellID["191326"] = {
  --desc = "Breath of Corruption (Dresaron)";
  sound = 1;
  test = true;
};

GTFO.SpellID["199460"] = {
  --desc = "Falling Rocks (Dresaron)";
  sound = 1;
};

GTFO.SpellID["204976"] = {
  --desc = "Noxious Spit (Kudzilla)";
  sound = 1;
};



-- ******************
-- * Eye of Azshara *
-- ******************

GTFO.SpellID["196871"] = {
  --desc = "Storm (Hatecoil Stormweaver)";
  sound = 1;
};

GTFO.SpellID["195473"] = {
  --desc = "Abrasive Slime (Gritslime Snail)";
  sound = 1;
  tankSound = 0;
  applicationOnly = true;
};

GTFO.SpellID["191858"] = {
  --desc = "Toxic Puddle (Serpentrix)";
  sound = 1;
};

GTFO.SpellID["193055"] = {
  --desc = "Call the Seas (Call the Seas)";
  sound = 1;
  negatingBuffSpellID = 193018; -- Gaseous Bubbles
};

-- *********************
-- * Neltharion's Lair *
-- *********************

GTFO.SpellID["183407"] = {
  --desc = "Acid Splatter";
  sound = 1;
};

GTFO.SpellID["192800"] = {
  --desc = "Choking Dust (Rokmora)";
  sound = 1;
};

GTFO.SpellID["183566"] = {
  --desc = "Rancid Pool (Tarspitter Lurker)";
  sound = 1;
};

GTFO.SpellID["186576"] = {
  --desc = "Petrifying Cloud";
  applicationOnly = true;
  sound = 1;
  test = true; -- Doesn't appear to be restricted to application only for some reason
};

GTFO.SpellID["188494"] = {
  --desc = "Rancid Maw (Naraxas)";
  applicationOnly = true;
  sound = 1;
};

GTFO.SpellID["226388"] = {
  --desc = "Rancid Ooze";
  sound = 1;
};

GTFO.SpellID["188493"] = {
  --desc = "Rancid Maw (Naraxas)";
  sound = 1;
};

GTFO.SpellID["210166"] = {
  --desc = "Toxic Wretch (Naraxas)";
  sound = 1;
};

GTFO.SpellID["217090"] = {
  --desc = "Magma Wave (Dargrul)";
  sound = 1;
};

-- *************
-- * The Nexus *
-- *************

GTFO.SpellID["209848"] = {
  --desc = "Icicle Barrage (Scion of Ice)";
  sound = 1;
};

GTFO.SpellID["207556"] = {
  --desc = "Heated Ground";
  sound = 1;
};

GTFO.SpellID["209839"] = {
  --desc = "Burning Diffusion (Diffusion)";
  sound = 1;
};

-- ******************
-- * Halls of Valor *
-- ******************

GTFO.SpellID["198903"] = {
  --desc = "Crackling Storm (Storm Drake)";
  sound = 1;
};

GTFO.SpellID["193234"] = {
  --desc = "Dancing Blade (Hymdall)";
  sound = 1;
};

GTFO.SpellID["199818"] = {
  --desc = "Crackle (Valarjar Thundercaller)";
  sound = 1;
};

GTFO.SpellID["200682"] = {
  --desc = "Eye of the Storm (Solsten)";
  sound = 1;
  negatingBuffSpellID = 203963; -- Eye of the Storm
};

GTFO.SpellID["193702"] = {
  --desc = "Infernal Flames (God-King Skovald)";
  sound = 1;
};

GTFO.SpellID["193827"] = {
  --desc = "Ragnarok (God-King Skovald)";
  sound = 1;
};

-- *******************
-- * The Violet Hold *
-- *******************

GTFO.SpellID["205014"] = {
  --desc = "Seeping Shadows (Lord Malgath)";
  sound = 1;
};

GTFO.SpellID["205014"] = {
  --desc = "Frost Breath (Shivermaw)";
  sound = 1;
  tankSound = 0;
  applicationOnly = true;
};

GTFO.SpellID["201957"] = {
  --desc = "Frostbite (Shivermaw)";
  sound = 1;
};

GTFO.SpellID["204762"] = {
  --desc = "Violent Fel Energy (Portal Keeper)";
  sound = 1;
};

-- *********************
-- * The Emerald Dream *
-- *********************

GTFO.SpellID["220916"] = {
  --desc = "Tainted Ground";
  sound = 1;
};

GTFO.SpellID["213124"] = {
  --desc = "Venomous Pool";
  sound = 1;
};

GTFO.SpellID["212886"] = {
  --desc = "Nightmare Corruption (Il'gynoth)";
  sound = 1;
};

GTFO.SpellID["213936"] = {
  --desc = "Dark Storm (Elerethe Renferal)";
  sound = 2;
  test = true; -- may be spammy?
};

GTFO.SpellID["203045"] = {
  --desc = "Infested Ground (Nythendra)";
  sound = 1;
};

GTFO.SpellID["202978"] = {
  --desc = "Infested Breath (Nythendra)";
  sound = 1;
};

GTFO.FFSpellID["203097"] = {
  --desc = "Rot (Nythendra)";
  sound = 4;
  negatingBuffSpellID = 203096; -- Rot
};

-- *************
-- * Nighthold *
-- *************

GTFO.SpellID["212736"] = {
  --desc = "Pool of Frost (Spellblade Aluriel)";
  sound = 1;
};

GTFO.SpellID["213504"] = {
  --desc = "Arcane Fog (Spellblade Aluriel)";
  sound = 1;
};

GTFO.SpellID["213278"] = {
  --desc = "Burning Ground (Spellblade Aluriel)";
  sound = 1;
};

GTFO.SpellID["206398"] = {
  --desc = "Fel Flame (Star Augur Etraeus)";
  sound = 1;
  applicationOnly = true;
  test = true;
};

GTFO.SpellID["219950"] = {
  --desc = "Controlled Chaos (High Botanist Tel'arn)";
  sound = 1;
  test = true;
};

GTFO.SpellID["213624"] = {
  --desc = "Mark of Frost (Spellblade Aluriel)";
  sound = 4;
  negatingBuffSpellID = 212587; -- Mark of Frost
};

GTFO.SpellID["213520"] = {
  --desc = "Arcane Orb (Spellblade Aluriel)";
  sound = 1;
  test = true;
};

GTFO.SpellID["212494"] = {
  --desc = "Annihilated (Spellblade Aluriel)";
  sound = 1;
  tankSound = 0;
};

GTFO.SpellID["216027"] = {
  --desc = "Nether Zone (Tichondrius)";
  sound = 1;
};

GTFO.SpellID["209433"] = {
  --desc = "Spanning Singularity (Grand Magistrix Elisande)";
  sound = 1;
};

GTFO.SpellID["209433"] = {
  --desc = "Spanning Singularity (Grand Magistrix Elisande)";
  sound = 1;
};

