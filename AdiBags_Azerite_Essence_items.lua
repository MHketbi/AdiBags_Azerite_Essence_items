--[[
AdiBags - Azerite Essence items
by Mandus
version: v1.0
Add various Azerite Essence items to AdiBags filter groups
]]

local addonName, addon = ...
local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")

local L = addon.L
local MatchIDs
local Tooltip
local Result = {}

local function AddToSet(Set, List)
	for _, v in ipairs(List) do
		Set[v] = true
	end
end

--Items collected and combined to be upgrade item.
local collectableItems = {
	169590, --Burgeoning Battlefield Furor
	169614, --Call to Arms Distinction
	169687, --Fragment of Zem'lan's Lost Treasure Map
	169774, --Progression Sprocket
	169694, --Aqueous Reliquary
	169491, --Focused Life Anima
}

--Items used at the forget to acquire or upgrade azerite essence.
local upgradeItems = { 
	168328, --Hardened Azerite Formation
	168399, --Fetish of the Dark Caverns
	168400, --Null Force Containment Unit
	168442, --Roiling Blood of the Vanquished
	168443, --Agitated Blood of the Dominated
	168444, --Churning Blood of the Conquered
	168536, --Recrystallizing Azerite Formation
	168537, --Tempered Azerite Formation
	168538, --Dazzling Azerite Formation
	168558, --Fetish of the Deep Dungeons
	168559, --Fetish of the Hidden Labyrinths
	168560, --Fetish of the Gilded Catacombs
	168566, --Null Force Cooling Unit
	168568, --Null Force Nullifier
	168569, --Null Force Visualizer
	168578, --Sphere of Suppressed Force
	168579, --Sphere of Unrestrained Fury
	168580, --Sphere of Leeched Mobility
	168581, --Sphere of Incandescent Neutralization
	168611, --Petrified Ebony Scale
	168612, --Dreamglow Dragonscale
	168613, --Tempered Scale of the Scarlet Broodmother
	168614, --Charged Scale of the Blue Aspect
	168615, --Volatile Worldvein
	168616, --Stalwart Worldvein
	168617, --Fluctuating Worldvein
	168618, --Brilliant Worldvein
	168620, --Converging Lens of the Focusing Iris
	168621, --Magnifying Lens of the Focusing Iris
	168622, --Stabilizing Lens of the Focusing Iris
	168623, --Biconcavic Lens of the Focusing Iris
	168814, --Animated Blood of the Decimated 
	168837, --Depth Forged Aegis
	168838, --Enduring Bulwark of the Depths
	168839, --Regenerating Barrier of the Depths
	168840, --Resplendent Bastion of the Depths
	168842, --Engine of Mecha-Perfection
	168843, --Perfectly Timed Differential
	168844, --Perfection-Enhancing Gearbox
	168845, --Mecha-Perfection Turbo
	168846, --Pearl of Lucid Dreams
	168847, --Pearl of Manifest Ambitions
	168848, --Pearl of Perspicuous Intentions
	168849, --Pearl of Luminous Designs
	168850, --Time-Lost Battlefield Memento
	168851, --Enduring Battlefield Memento
	168852, --Stalwart Battlefield Memento
	168853, --Glinting Battlefield Memento
	168854, --Animated Elemental Heart
	168855, --Pulsing Elemental Heart
	168856, --Resonating Elemental Heart
	168857, --Sparkling Elemental Heart
	168858, --Titan Purification Protocols
	168859, --Targeted Purification Protocols
	168860, --Enhanced Purification Protocols
	168861, --Ultimate Purification Protocols
	168863, --Unbound Azerite Slivershards
	168864, --Sharpened Azerite Slivershards
	168865, --Polarized Azerite Slivershards
	168866, --Incandescent Azerite Slivershards
	168920, --Azerite-Encrusted Timequartz
	168921, --Azerite-Infused Timequartz
	168922, --Azerite-Fueled Timequartz
	168923, --Unburdened Azerite Timequartz
	168924, --Bursting Seed of Life
	168925, --Replicating Seed of Abundance
	168926, --Lingering Seed of Renewal
	168927, --Seed of Vibrant Blooms
	168928, --Tablet of the Balancing Tides
	168929, --Codex of the Never-Ending Tides
	168930, --Tome of the Quickening Tides
	168931, --Vellum of Illuminating Tides
	168932, --Reactive Existence Battery
	168933, --Enhanced Existence Capacitor
	168934, --Calibrated Existence Gauge
	168935, --Existence Vibrancy Display
	168941, --Vitality Redistribution Lattice
	168942, --Mesh of Expanding Vitality
	168943, --Grid of Bursting Vitality
	168944, --Web of Unbridled Vitality
	169899, --Polished Skull Trophy
	169900, --Rib-Bone Choker of Dominance
	169901, --Etched Bone Trophy of the Vanquished
	169902, --Finger-Bone Trophy of Battle
}



local function MatchIDs_Init(self)
	wipe(Result)

	if self.db.profile.moveCollectable then
		AddToSet(Result, collectableItems)
	end

	if self.db.profile.moveUpgrade then
		AddToSet(Result, upgradeItems)
	end

	return Result
end

local function Tooltip_Init()
	local tip, leftside = CreateFrame("GameTooltip"), {}
	for i = 1, 6 do
		local Left, Right = tip:CreateFontString(), tip:CreateFontString()
		Left:SetFontObject(GameFontNormal)
		Right:SetFontObject(GameFontNormal)
		tip:AddFontStrings(Left, Right)
		leftside[i] = Left
	end
	tip.leftside = leftside
	return tip
end

local setFilter = AdiBags:RegisterFilter("Azerite Essence Items", 98, "ABEvent-1.0")
setFilter.uiName = "Azerite Essence Items"
setFilter.uiDesc = "Items that are connected to Azerite Essence."

function setFilter:OnInitialize()
    self.db = AdiBags.db:RegisterNamespace("Azerite Essence Items", {
        profile = {
            moveCollectable = true,
            moveUpgrade = true,
		}
	})
end

function setFilter:Update()
	MatchIDs = nil
	self:SendMessage("AdiBags_FiltersChanged")
end

function setFilter:OnEnable()
	AdiBags:UpdateFilters()
end

function setFilter:OnDisable()
	AdiBags:UpdateFilters()
end

function setFilter:Filter(slotData)
	MatchIDs = MatchIDs or MatchIDs_Init(self)
	if MatchIDs[slotData.itemId] then
		return "Azerite Essence Items"
	end
	
	Tooltip = Tooltip or Tooltip_Init()
	Tooltip:SetOwner(UIParent,"ANCHOR_NONE")
	Tooltip:ClearLines()
	
	if slotData.bag == BANK_CONTAINER then
		Tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slotData.slot, nil))
	else
		Tooltip:SetBagItem(slotData.bag, slotData.slot)
	end
	
	Tooltip:Hide()
end

function setFilter:GetOptions()
	return {
		moveCollectable = {
			name = "Collectable Items",
			desc = "Items collected and combined to be upgrade item",
			type = "toggle",
			order = 10
		},
		moveUpgrade = {
			name = "BAzerite Essence Items",
			desc = "Items used to unlock and upgrade Azerite Essence Items",
			type = "toggle",
			order = 20
		}
	},
	AdiBags:GetOptionHandler(self, false, function ()
		return self:Update()
	end)
end
