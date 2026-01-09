# 📦 How to Use the DVTOONL Module
## This module requires no installation—it consists of a single file and has no external dependencies.

---

### 1. Download the File
**Copy only one file into your project:**
📁 **[DVTOONL.lua](DVTOONL.lua)**

Place it in your project directory, for example:

```
my_folder/
├── main.lua
└── DVTOONL.lua   ← put it here
```

---

### 2. Require the Module
In any Lua script, load it using require:

``` lua
local TOON = require("DVTOONL")
```

> [!TIP]
> Make sure the filename is exactly DVTOONL.lua (case-sensitive).
If you rename the file, update the name in require.

---

### 3. Core Functions
* **Serialize (table → TOON string)**
``` lua
local data = { player = { name = "Alice", level = 5 } }
local toon_str = TOON.serialization(data)
print(toon_str)
```

* **Deserialize (TOON string → table)**
``` lua
local restored = TOON.deserialization(toon_str)
print(restored.player.name)  -- Alice
```

* **Save to File**
``` lua
TOON.save_to_file(data, "save.toon")
```

* **Load from File**
``` lua
local loaded = TOON.load_from_file("save.toon")
```
---
### 4. You're Done!
You can now:

Save game states,
Load configuration files,
Exchange structured data between components.
The module works in any Lua 5.1+ environment, including:

* LÖVE2D,
* Standalone scripts,
* OpenComputers, CC:Tweaked, and more.
> [!TIP]
>You don’t need to copy .git, test/, README.md, or the license file—those are only for development. For usage, only DVTOONL.lua is required.