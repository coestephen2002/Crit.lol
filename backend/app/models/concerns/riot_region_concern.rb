# app/services/concerns/riot_region_concern.rb
module RiotRegionConcern
  extend ActiveSupport::Concern

  REGION_MAP = {
    "na1"  => "americas",
    "br1"  => "americas",
    "la1"  => "americas",
    "la2"  => "americas",
    "oc1"  => "americas",

    "euw1" => "europe",
    "eun1" => "europe",
    "tr1"  => "europe",
    "ru"   => "europe",

    "kr"   => "asia",
    "jp1"  => "asia",
    "sg2"  => "asia",
    "tw2"  => "asia",
    "vn2"  => "asia",
    "me1"  => "asia",
  }.freeze

  MATCH_REGION_MAP = {
    "na1"  => "americas",
    "br1"  => "americas",
    "la1"  => "americas",
    "la2"  => "americas",

    "euw1" => "europe",
    "eun1" => "europe",
    "tr1"  => "europe",
    "ru"   => "europe",
    "me1"  => "europe",

    "kr"   => "asia",
    "jp1"  => "asia",

    "oc1"  => "sea",
    "sg2"  => "sea",
    "tw2"  => "sea",
    "vn2"  => "sea"
}.freeze

  def self.routing_region_for(platform_region)
    REGION_MAP[platform_region.to_s.downcase]
  end
end
