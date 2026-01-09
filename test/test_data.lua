-- test/test_data.lua
local tests = {
    _1 = {
        employees = {
            { Name = "Anna", Age = 12, Worked = false },
            { Name = "Cristina", Age = 24, Worked = true },
            { Name = "Cristina", Age = 23, Worked = true },
            { Name = "Cristina", Age = 22, Worked = false },
            { Name = "Cristina", Age = 20, Worked = true },
            { Name = "Cristina", Age = 29, Worked = false },
        }
    },
    _2 = {
        players = {
            {Username = "User01", DateRegisre = "10.10.10", friends = {
                        {ID = 01238, online = false, friend = "send"},
                        {ID = 12380, online = true, friend = "accepted"},
                        {ID = 01238, online = true, friend = "rejected"}
                    }
            },
            {Username = "User67", DateRegisre = "12.12.12", friends = {
                        {ID = 02338, online = false, friend = "send"},
                        {ID = 17580, online = true, friend = "send"},
                        {ID = 01223, online = false, friend = "rejected"}
                    }
            }
        }
    },
    _3 = {
        players = {
            { ID = 1, Username = "User01", DateRegisre = "10.10.10" },
            { ID = 2, Username = "User67", DateRegisre = "12.12.12" }
        },
        friendships = {
            { playerID = 1, friendID = 01238, online = false, status = "send" },
            { playerID = 1, friendID = 12380, online = true, status = "accepted" },
        }
    },
    _4 = {
        shops = {
            Wilmort = {
                {Product = "Apple", price = "1.99$/1kg", quantity = "290kg"},
                {Product = "Potato", price = "0.99$/1kg", quantity = "1037kg"},
                {Product = "TV", price = "1399.99$", quantity = 20}
            },
            Amazan = {
                {Product = "Apple", price = "1.55$/1kg", quantity = "123kg"},
                {Product = "Potato", price = "0.99$/1kg", quantity = "137kg"},
                {Product = "TV", price = "1000$", quantity = 100}
            },
            Magnit = {
                {Product = "Apple", price = "0.55$/1kg", quantity = "1290kg"},
                {Product = "Potato", price = "0.25$/1kg", quantity = "3956kg"},
                {Product = "TV", price = "1200$", quantity = 5}
            },
        }
    },
    _5 = {
        saveData = {
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
            achievements = {}
        }
    }
}

local function TEST(ntest) 
    return tests["_" .. ntest] end

return TEST