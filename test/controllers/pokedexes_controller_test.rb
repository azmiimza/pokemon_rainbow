require 'test_helper'

class PokedexesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get pokedexes_new_url
    assert_response :success
  end

  test "should get index" do
    get pokedexes_index_url
    assert_response :success
  end

  test "should get edit" do
    get pokedexes_edit_url
    assert_response :success
  end

  test "should get show" do
    get pokedexes_show_url
    assert_response :success
  end

end
