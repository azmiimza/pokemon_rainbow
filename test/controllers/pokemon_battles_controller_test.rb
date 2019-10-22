require 'test_helper'

class PokemonBattlesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get pokemon_battles_new_url
    assert_response :success
  end

  test "should get index" do
    get pokemon_battles_index_url
    assert_response :success
  end

  test "should get show" do
    get pokemon_battles_show_url
    assert_response :success
  end

end
