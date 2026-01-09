# **Created by Dovintc**
## **[Source code](https://github.com/dovintc-off/TOON-for-Lua)** - **[Telegramm channel](https://t.me/Xwared)**

---

# **TOON-for-Lua**
A pure Lua implementation of the `TOON (Token-Oriented Object Notation)` format.
TOON is a compact, human-readable, and LLM-friendly data format designed as an efficient alternative to `JSON`.

This library is intended for serialization and deserialization of data structures in games, configuration files, and any other scenario where Lua is used — including LÖVE2D, Roblox, and standalone applications.

---

## **Key Features**
* **Full round-trip compatibility** between Lua tables and TOON with no data loss
* **Automatic detection of uniform object arrays** for compact representation
* Support for nested objects, simple arrays, strings, numbers, booleans, and `nil`
* **Human-readable output with indentation**, similar to *YAML*
* **Compliance with the official TOON specification**, enabling seamless data exchange with other implementations (`Python`, `JavaScript`, etc.)

---

## **Current Status**
The project is under active development.
Planned features include:

* **robust handling of escaped and quoted strings,**
* **full support for deeply nested structures,**
* **reliable parsing of edge cases and ambiguous inputs.**

---

The library has no external dependencies and consists of a single file, making it easy to integrate into any Lua project.

## **License**
[MIT © Dovintc](LICENSE)