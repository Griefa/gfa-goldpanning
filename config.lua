Config = {}

-- Framework related
Config.Inventory = "ox" -- change to "qb", "lj" or "ox"

-- Debug
Config.ZoneDebug = true -- true = enable Polyzone debug for all zones (Gold, Wash and Smelt) false = disable all zone debugs


-- Item Names
Config.BucketName = "bucket"
Config.SifterName = "sifter"
Config.MoldName = "mold"


-- Item Requirement needed (Only for Ox)
Config.RawGoldAmount = 20

--Enable/Disable Item Decay (Ox_Inventory only)
Config.BucketDecay = true -- Set to 'true' to enable decay on buckets. Set to 'false' to disable
Config.SifterDecay = true -- Set to 'true' to enable decay on sifters. Set to 'false' to disable
Config.MoldDecay = true -- Set to 'true' to enable decay on molds. Set to 'false' to disable

-- Item Decay Amount (Decay must be set to true for this to work)
Config.BucketDecayAmount = 5 -- Removes decay amount based on Value. 1 = Removes 1 Durability per use, 5 will remove 2 etc
Config.SifterDecayAmount = 5
Config.MoldDecayAmount = 5

-- ProgressBar Duration
Config.BucketDuration = 5000 -- Value is set to seconds. 1000 = 1 second, 5000 = 5 seconds etc
Config.SifterDuration = 5000 -- Value is set to seconds. 1000 = 1 second, 5000 = 5 seconds etc
Config.MoldDuration = 5000  -- Value is set to seconds. 1000 = 1 second, 5000 = 5 seconds etc

--Items
Config.GoldItems = {
    {start = "bucket", name = "gravel", threshold = 80, min = 1, max = 3, remove = nil, },
}

Config.WashingItems = {
    {start = "sifter", name = "rawgold", threshold = 100, min = 1, max = 3, remove = "gravel", },
    {start = "sifter", name = "copper", threshold = 75,  min = 1, max = 15, remove = nil, },
    {start = "sifter", name = "steel", threshold = 75,  min = 1, max = 15, remove = nil, },
    {start = "sifter", name = "aluminum", threshold = 75, min = 1, max = 15, remove = nil, },
}

Config.SmeltingItems = {
    {start = "mold", name = "goldbar", threshold = 100, min = 1, max = 1, remove = "rawgold", },
}

-- Blips
Config.Blips = {
    {
        blippoint = vector3(-183.24, 3038.42, 19.2),
        blipsprite = 618,
        blipscale = 0.80,
        blipcolour = 46,
        label = "Gold Panning & Washing"
    },
    {
        blippoint = vector3(1061.71, -1978.43, 31.24),
        blipsprite = 436,
        blipscale = 0.80,
        blipcolour = 47,
        label = "Smelting"
    },

    {
        blippoint = vector3(-183.24, 3038.42, 19.2),
        blipcolor = 5,
    }
}

-- Zones
Config.Gold = {
    {
        zones = {
            vector2(-170.13887023926, 3078.7465820312),
            vector2(-172.35494995117, 3079.5407714844),
            vector2(-193.98593139648, 3057.228515625),
            vector2(-195.68803405762, 3046.1743164062),
            vector2(-225.02757263184, 3013.3051757812),
            vector2(-239.65968322754, 3011.5939941406),
            vector2(-253.34945678711, 3012.7243652344),
            vector2(-233.41017150879, 2978.3986816406),
            vector2(-225.39804077148, 2973.7893066406),
            vector2(-169.88653564453, 3055.2421875),
            vector2(-157.40686035156, 3071.4321289062),
        },
        minz = 18.58,
        maxz = 19.60,
    },
}

Config.Washing = {
    {
        zones = {
            vector2(-170.13887023926, 3078.7465820312),
            vector2(-172.35494995117, 3079.5407714844),
            vector2(-193.98593139648, 3057.228515625),
            vector2(-195.68803405762, 3046.1743164062),
            vector2(-225.02757263184, 3013.3051757812),
            vector2(-239.65968322754, 3011.5939941406),
            vector2(-253.34945678711, 3012.7243652344),
            vector2(-233.41017150879, 2978.3986816406),
            vector2(-225.39804077148, 2973.7893066406),
            vector2(-169.88653564453, 3055.2421875),
            vector2(-157.40686035156, 3071.4321289062),
        },
        minz = 18.58,
        maxz = 19.60,
    },
}

Config.Smelting = {
    {
        zones = {
            vector2(1114.97, -2008.14),
            vector2(1111.14, -2005.42),
            vector2(1107.87, -2010.28),
            vector2(1111.82, -2013.07),
        },
        minz = 28.0,
        maxz = 36.0,
    },
}

-- Locales (Beta)

Config.Locales = {

    -- Progressbars 
    ['gravel_progress'] = 'Getting Gravel',
    ['washing_progress'] = 'Washing Gravel',
    ['mold_progress'] = 'Melting Raw Gold',

    --Notify
    ['swimming_notify_error'] = 'You can\'t do this while swimming',
    ['shallow_water_notify_error'] = 'The water is too shallow. You need to go a bit deeper',
    ['water_purity_notify_error'] = 'This water is contaminated. Find a more pure water source',
    ['no_wash_notify_error'] = 'You currently have nothing to wash',
    ['no_melt_notify_error'] = 'You don\'t have anything to melt',
    ['not_enough_melt_notify_error'] = 'You require at least 10 Raw Gold',
    ['bucket_decay_notify_error'] = 'Oops looks like you need to get a new Bucket',
    ['sifter_decay_notify_error'] = 'Oops looks like you need to get a new Sifter',
    ['mold_decay_notify_error'] = 'Oops looks like you need to get a new Mold',
    ['wash_location_success'] = 'Checking wash location',
    ['overweight_notify_error'] = 'You seem to be carrying too much already',

}