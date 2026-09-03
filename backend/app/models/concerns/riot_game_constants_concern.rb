module RiotGameConstantsConcern
  extend ActiveSupport::Concern

  QUEUE_INFO = {
    0    => { notes: "Custom games",          description: nil },

    72   => { notes: "Howling Abyss",         description: "1v1 Snowdown Showdown" },
    73   => { notes: "Howling Abyss",         description: "2v2 Snowdown Showdown" },
    75   => { notes: "Summoner's Rift",       description: "6v6 Hexakill" },
    76   => { notes: "Summoner's Rift",       description: "Ultra Rapid Fire" },
    78   => { notes: "Howling Abyss",         description: "One For All: Mirror Mode" },
    83   => { notes: "Summoner's Rift",       description: "Co-op vs AI Ultra Rapid Fire" },
    98   => { notes: "Twisted Treeline",      description: "6v6 Hexakill" },
    100  => { notes: "Butcher's Bridge",      description: "5v5 ARAM" },

    310  => { notes: "Summoner's Rift",       description: "Nemesis" },
    313  => { notes: "Summoner's Rift",       description: "Black Market Brawlers" },
    317  => { notes: "Crystal Scar",          description: "Definitely Not Dominion" },
    325  => { notes: "Summoner's Rift",       description: "All Random" },

    400  => { notes: "Summoner's Rift",       description: "5v5 Draft Pick" },
    420  => { notes: "Summoner's Rift",       description: "5v5 Ranked Solo" },
    430  => { notes: "Summoner's Rift",       description: "5v5 Blind Pick" },
    440  => { notes: "Summoner's Rift",       description: "5v5 Ranked Flex" },
    450  => { notes: "Howling Abyss",         description: "5v5 ARAM" },
    490  => { notes: "Summoner's Rift",       description: "Normal (Quickplay)" },

    600  => { notes: "Summoner's Rift",       description: "Blood Hunt Assassin" },
    610  => { notes: "Cosmic Ruins",          description: "Dark Star: Singularity" },

    700  => { notes: "Summoner's Rift",       description: "Summoner's Rift Clash" },
    720  => { notes: "Howling Abyss",         description: "ARAM Clash" },

    820  => { notes: "Twisted Treeline",      description: "Co-op vs. AI Beginner Bot" },

    870  => { notes: "Summoner's Rift",       description: "Co-op vs. AI Intro Bot" },
    880  => { notes: "Summoner's Rift",       description: "Co-op vs. AI Beginner Bot" },
    890  => { notes: "Summoner's Rift",       description: "Co-op vs. AI Intermediate Bot" },

    900  => { notes: "Summoner's Rift",       description: "ARURF" },
    910  => { notes: "Crystal Scar",          description: "Ascension" },
    920  => { notes: "Howling Abyss",         description: "Legend of the Poro King" },
    940  => { notes: "Summoner's Rift",       description: "Nexus Siege" },
    950  => { notes: "Summoner's Rift",       description: "Doom Bots Voting" },
    960  => { notes: "Summoner's Rift",       description: "Doom Bots Standard" },

    980  => { notes: "Valoran City Park",     description: "Star Guardian Invasion: Normal" },
    990  => { notes: "Valoran City Park",     description: "Star Guardian Invasion: Onslaught" },
    1000 => { notes: "Overcharge",            description: "PROJECT: Hunters" },
    1010 => { notes: "Summoner's Rift",       description: "Snow ARURF" },
    1020 => { notes: "Summoner's Rift",       description: "One for All" },

    1030 => { notes: "Crash Site",            description: "Odyssey Extraction: Intro" },
    1040 => { notes: "Crash Site",            description: "Odyssey Extraction: Cadet" },
    1050 => { notes: "Crash Site",            description: "Odyssey Extraction: Crewmember" },
    1060 => { notes: "Crash Site",            description: "Odyssey Extraction: Captain" },
    1070 => { notes: "Crash Site",            description: "Odyssey Extraction: Onslaught" },

    1090 => { notes: "Convergence",           description: "Teamfight Tactics" },
    1100 => { notes: "Convergence",           description: "Ranked Teamfight Tactics" },
    1110 => { notes: "Convergence",           description: "Teamfight Tactics Tutorial" },
    1111 => { notes: "Convergence",           description: "Teamfight Tactics test" },
    1210 => { notes: "null",                  description: "Teamfight Tactics Choncc's Treasure Mode" },

    1300 => { notes: "Nexus Blitz",           description: "Nexus Blitz" },
    1400 => { notes: "Summoner's Rift",       description: "Ultimate Spellbook" },

    1700 => { notes: "Rings of Wrath",        description: "Arena" },
    1710 => { notes: "16 player lobby",       description: "Arena" },

    1810 => { notes: "Swarm Mode 1 player",   description: "Swarm Mode" },
    1820 => { notes: "Swarm Mode 2 players",  description: "Swarm" },
    1830 => { notes: "Swarm Mode 3 players",  description: "Swarm" },
    1840 => { notes: "Swarm Mode 4 players",  description: "Swarm" },

    1900 => { notes: "Summoner's Rift",       description: "Pick URF" },

    2000 => { notes: "Summoner's Rift",       description: "Tutorial 1" },
    2010 => { notes: "Summoner's Rift",       description: "Tutorial 2" },
    2020 => { notes: "Summoner's Rift",       description: "Tutorial 3" },
  }.freeze

  def self.queue_desc(id, default: nil)
    QUEUE_INFO[id]&.dig(:description) || default
  end

  def self.queue_notes(id, default: nil)
    QUEUE_INFO[id]&.dig(:notes) || default
  end

  MAP_INFO = {
    1  => { map_name: "Summoner's Rift",   notes: "Original Summer variant" },
    2  => { map_name: "Summoner's Rift",   notes: "Original Autumn variant" },
    3  => { map_name: "The Proving Grounds", notes: "Tutorial Map" },
    4  => { map_name: "Twisted Treeline",  notes: "Original Version" },
    8  => { map_name: "The Crystal Scar",  notes: "Dominion map" },
    10 => { map_name: "Twisted Treeline",  notes: "Last TT map" },
    11 => { map_name: "Summoner's Rift",   notes: "Current Version" },
    12 => { map_name: "Howling Abyss",     notes: "ARAM map" },
    14 => { map_name: "Butcher's Bridge",  notes: "Alternate ARAM map" },
    16 => { map_name: "Cosmic Ruins",      notes: "Dark Star: Singularity map" },
    18 => { map_name: "Valoran City Park", notes: "Star Guardian Invasion map" },
    19 => { map_name: "Substructure 43",   notes: "PROJECT: Hunters map" },
    20 => { map_name: "Crash Site",        notes: "Odyssey: Extraction map" },
    21 => { map_name: "Nexus Blitz",       notes: "Nexus Blitz map" },
    22 => { map_name: "Convergence",       notes: "Teamfight Tactics map" },
    30 => { map_name: "Rings of Wrath",    notes: "Arena map" },
  }.freeze

  def self.map_name(id, default: nil)
    MAP_INFO[id]&.dig(:map_name) || default
  end

  def self.map_notes(id, default: nil)
    MAP_INFO[id]&.dig(:notes) || default
  end

end
  