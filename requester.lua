return {
    { name = "Spruce Plank", id = "minecraft:spruce_planks", require = 512, threshold = 128, type = 'item' },
    { name = "Glass",        id = "minecraft:glass",         require = 512, threshold = 128, type = 'item' },
    {
        name = "AE2",
        groups =
        {
            { name = "Logic Processor",         id = "ae2:logic_processor",               require = 512, threshold = 128, type = "item" },
            { name = "Calculation Processor",   id = "ae2:calculation_processor",         require = 512, threshold = 128, type = "item" },
            { name = "Engineering Processor",   id = "ae2:engineering_processor",         require = 512, threshold = 128, type = "item" },
            { name = "Quartz Cable",            id = "ae2:quartz_fiber",                  require = 512, threshold = 128, type = "item" },
            { name = "Smart Cable",             id = "ae2:fluix_smart_cable",             require = 512, threshold = 128, type = "item" },
            { name = "Thicc Smart Cable",       id = "ae2:fluix_smart_dense_cable",       require = 512, threshold = 128, type = "item" },
            { name = "Ext Pattern Provider",    id = "extendedae:ex_pattern_provider",    require = 64,  threshold = 16,  type = "item" },
            { name = "Ext Molecular Assembler", id = "extendedae:ex_molecular_assembler", require = 64,  threshold = 16,  type = "item" },
            { name = "Storage Bus",             id = "ae2:storage_bus",                   require = 64,  threshold = 16,  type = "item" },
            { name = "Import Bus",              id = "ae2:import_bus",                    require = 64,  threshold = 16,  type = "item" },
            { name = "Export Bus",              id = "ae2:export_bus",                    require = 64,  threshold = 16,  type = "item" },
        }
    },
    {
        name = "Redstone Components",
        groups =
        {
            { name = "Dropper",        id = "minecraft:dropper",        require = 64, threshold = 32, type = "item" },
            { name = "Observer",       id = "minecraft:observer",       require = 64, threshold = 32, type = "item" },
            { name = "Lever",          id = "minecraft:lever",          require = 64, threshold = 32, type = "item" },
            { name = "Button",         id = "minecraft:stone_button",   require = 64, threshold = 32, type = "item" },
            { name = "Redstone Torch", id = "minecraft:redstone_torch", require = 64, threshold = 32, type = "item" },
            { name = "Repeater",       id = "minecraft:repeater",       require = 64, threshold = 32, type = "item" },
            { name = "Comparator",     id = "minecraft:comparator",     require = 64, threshold = 32, type = "item" },
            { name = "Hopper",         id = "minecraft:hopper",         require = 64, threshold = 32, type = "item" },
            { name = "Piston",         id = "minecraft:piston",         require = 64, threshold = 32, type = "item" },
            { name = "Sticky Piston",  id = "minecraft:sticky_piston",  require = 64, threshold = 32, type = "item" },
        },
    },
    {
        name = "Flux",
        groups =
        {
            { name = "Flux PLUG (Gain FE)",  id = "fluxnetworks:flux_plug",  require = 64, threshold = 16, type = "item" },
            { name = "Flux POINT (Give FE)", id = "fluxnetworks:flux_point", require = 64, threshold = 16, type = "item" },
        },
    },
    {
        name = "SFM",
        groups =
        {
            { name = "Block Cable", id = "sfm:cable",       require = 128, threshold = 32, item = "item" },
            { name = "Fancy Cable", id = "sfm:fancy_cable", require = 128, threshold = 32, item = "item" },
            { name = "Manager",     id = "sfm:manager",     require = 128, threshold = 32, item = "item" },
            { name = "Disk",        id = "sfm:disk",        require = 128, threshold = 32, item = "item" },

        }
    },
}
