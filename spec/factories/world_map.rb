FactoryBot.define do
  factory :world_map do
    width { 10 }
    height  { 10 }
    tile_size { 2 }
    seed { 123 }
  end
end