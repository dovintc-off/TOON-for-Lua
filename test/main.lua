-- test/main.lua
local DVTOONL = require "../DVTOONL"
TEST = require("test.test_data")

-- TOONL.save_to_file(TEST(arg[1]), "test/test" .. arg[1] .. ".toon")

-- local loaded = TOONL.load_from_file("test/test4.toon")
-- for key, value in pairs(loaded.shops) do
--     for key2, value2 in pairs(value) do
--         for key3, value3 in pairs(value2) do
--             print(key, key3, value3)
--         end
--     end
-- end

-- 1. Lua source table
local original = {
    player = {
        name = "Dovintc",
        level = 10,
        active = true,
        inventory = {
            { item = "Health Potion", count = 5, equipped = false },
            { item = "Iron Sword", count = 1, equipped = true }
        },
        stats = {
            health = 100,
            mana = 75.5,
            isOnline = nil
        }
    },
    settings = {
        volume = 0.8,
        fullscreen = true,
        language = "ru"
    },
    achievements = {},  -- empty table
    flags = {
        seenTutorial = false,
        debugMode = nil
    }
}

-- 2. Serialize in TOON
local toon_str = DVTOONL.serialization(original)
print("=== SERIALIZED STRING ===")
print(toon_str)
print("\n=== DESERIALIZATION ===")

-- 3. Deserialize back
local restored = DVTOONL.deserialization(toon_str)

-- 4. Checking key values
assert(restored.player.name == "Dovintc")
assert(restored.player.level == 10)
assert(restored.player.active == true)
assert(#restored.player.inventory == 2)
assert(restored.player.inventory[1].item == "Health Potion")
assert(restored.player.inventory[1].count == 5)
assert(restored.player.inventory[1].equipped == false)
assert(restored.player.stats.mana == 75.5)
assert(restored.player.stats.isOnline == nil)
assert(restored.settings.language == "ru")
assert(type(restored.achievements) == "table" and next(restored.achievements) == nil)
assert(restored.flags.seenTutorial == false)
assert(restored.flags.debugMode == nil)

print("All checks passed! Round-trip is successful.")