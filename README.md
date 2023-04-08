# gfa-goldpanning v1.0.0

# Description

gfa-goldpanning is drag-and-drop resource for the QBCore Framework with compatibility for ox_inventory, qb-inventory and lj-inventory. You are able to gather gravel, which you can then wash it for a change to get Raw Gold and other items. You can then smelt the Raw Gold down into Gold Bars. You are then able to sell the Gold bars to the Pawnshop, or however you wish to sell them. 

# Dependencies

*[qb-core](https://github.com/qbcore-framework/qb-core)
*[PolyZone](https://github.com/mkafrin/PolyZone)
*[qb-inventory](https://github.com/qbcore-framework/qb-inventory) or
*[lj-inventory](https://github.com/loljoshie/lj-inventory) or
*[ox_inventory](https://github.com/overextended/ox_inventory)

**You can find the images below
[gfa-items](https://github.com/Griefa/gfa-items/tree/main/activities/goldpanning)

# Preview

*[Gathering/Washing](https://streamable.com/pu7icv)
*[Smelting](https://streamable.com/zuygar)
*[Pawnshop](https://streamable.com/t8x655) **Optional**

# Instructions (qb/lj)

**Add the following anywhere to qb-shops/config.lua**

```
        ["gold"] = {
        [1] = {
            name = 'sifter',
            price = 150,
            amount = 200,
            info = {},
            type = 'item',
            slot = 1,
        },
        [2] = {
            name = 'bucket',
            price = 150,
            amount = 200,
            info = {},
            type = 'item',
            slot = 2,
        },  
        [2] = {
            name = 'mold',
            price = 150,
            amount = 200,
            info = {},
            type = 'item',
            slot = 3,
        },

    },```

** Add the following to qb-core/items.lua

```
    ["sifter"]				= {["name"] = "sifter",       		    		["label"] = "Sifter",	 		["weight"] = 1000, 		["type"] = "item", 		["image"] = "SiftingPan.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = ""},
	["bucket"]				= {["name"] = "bucket",       		    		["label"] = "Bucket",	 		["weight"] = 1000, 		["type"] = "item", 		["image"] = "Bucket.png", 				["unique"] = true, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = ""},
	["mold"]				= {["name"] = "mold",       		            ["label"] = "Mold",	 		    ["weight"] = 1000, 		["type"] = "item", 		["image"] = "Mold.png", 		["unique"] = true, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = ""},
    ["gravel"]				= {["name"] = "gravel",       		    		["label"] = "Gravel",	 		["weight"] = 1000, 		["type"] = "item", 		["image"] = "Gravel.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = ""},
	["rawgold"]				= {["name"] = "rawgold",       		    		["label"] = "Raw Gold",	 		["weight"] = 5000, 		["type"] = "item", 		["image"] = "Rawgold.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = ""},
```

# Instructions (Ox)

** Add the following to ox_inventory/data/shops.lua Note: If you do not want the metadata, simply remove it.

```
{ name = 'bucket', price = 1, metadata = { durability = 100 }},
{ name = 'mold', price = 1, metadata = { durability = 100 }},
{ name = 'sifter', price = 1, metadata = { durability = 100 }},

```

** Add the following into ox_inventory/data/items.lua

```
['sifter'] = {
		label = 'Sifter',
		weight = 100,
		stack = true,
		close = false,
		description = "",
	},

	['bucket'] = {
		label = 'Bucket',
		weight = 100,
		stack = true,
		close = false,
		description = "",
	},

	['mold'] = {
		label = 'Mold',
		weight = 100,
		stack = true,
		close = false,
		description = "",
	},

	['gravel'] = {
		label = 'Gravel',
		weight = 100,
		stack = true,
		close = false,
		description = "",
	},

	['rawgold'] = {
		label = 'Raw Gold',
		weight = 100,
		stack = true,
		close = false,
		description = "",
	},
```

# Support

If you require support, you can join the [Discord](https://discord.gg/9tqRdwsVpW)