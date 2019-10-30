require 'test_helper'

class PokemonBattleLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get pokemon_battle_logs_create_url
    assert_response :success
  end

end
