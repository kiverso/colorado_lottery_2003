require "minitest/autorun"
require "./lib/game"
require "./lib/contestant"
require "./lib/colorado_lottery"


class GameTest < Minitest::Test
  def setup
    @lottery = ColoradoLottery.new
    @pick_4 = Game.new('Pick 4', 2)

    @mega_millions = Game.new('Mega Millions', 5, true)

    @cash_5 = Game.new('Cash 5', 1)

    @alexander = Contestant.new({
    first_name: 'Alexander',
    last_name: 'Aigades',
    age: 28,
    state_of_residence: 'CO',
    spending_money: 10})

    @benjamin = Contestant.new({
    first_name: 'Benjamin',
    last_name: 'Franklin',
    age: 17,
    state_of_residence: 'PA',
    spending_money: 100})

    @frederick = Contestant.new({
    first_name:  'Frederick',
    last_name: 'Douglas',
    age: 55,
    state_of_residence: 'NY',
    spending_money: 20})

    @winston = Contestant.new({
    first_name: 'Winston',
    last_name: 'Churchill',
    age: 18,
    state_of_residence: 'CO',
    spending_money: 5})
  end

  def test_it_exists
    assert_instance_of ColoradoLottery, @lottery
  end
  def test_it_has_readable_attributes
    expected_hash = {}
    assert_equal expected_hash, @lottery.registered_contestants
    assert_equal [], @lottery.winners
    assert_equal expected_hash, @lottery.current_contestants
  end

  def test_contestant_is_interested_and_18
    @alexander.add_game_interest('Pick 4')
    @alexander.add_game_interest('Mega Millions')
    @frederick.add_game_interest('Mega Millions')
    @winston.add_game_interest('Cash 5')
    @winston.add_game_interest('Mega Millions')
    @benjamin.add_game_interest('Mega Millions')
    assert_equal true, @lottery.interested_and_18?(@alexander, @pick_4)
    assert_equal false, @lottery.interested_and_18?(@benjamin, @mega_millions)
    assert_equal false, @lottery.interested_and_18?(@alexander, @cash_5)
  end

  def test_it_can_tell_if_contestant_can_register
    @alexander.add_game_interest('Pick 4')
    @alexander.add_game_interest('Mega Millions')
    @frederick.add_game_interest('Mega Millions')
    @winston.add_game_interest('Cash 5')
    @winston.add_game_interest('Mega Millions')
    @benjamin.add_game_interest('Mega Millions')

    assert_equal true, @lottery.can_register?(@alexander, @pick_4)
    assert_equal false, @lottery.can_register?(@alexander, @cash_5)
    assert_equal true, @lottery.can_register?(@frederick, @mega_millions)
    assert_equal false, @lottery.can_register?(@benjamin, @mega_millions)
    assert_equal false, @lottery.can_register?(@frederick, @cash_5)
  end

  def test_contestants_can_register
    @alexander.add_game_interest('Pick 4')
    @alexander.add_game_interest('Mega Millions')
    @frederick.add_game_interest('Mega Millions')
    @winston.add_game_interest('Cash 5')
    @winston.add_game_interest('Mega Millions')
    @benjamin.add_game_interest('Mega Millions')

    @lottery.register_contestant(@alexander, @pick_4)
    expected = {"Pick 4" => [@alexander]}
    assert_equal expected, @lottery.registered_contestants
    @lottery.register_contestant(@alexander, @mega_millions)
    expected = {"Pick 4" => [@alexander], "Mega Millions" => [@alexander]}
    assert_equal expected, @lottery.registered_contestants

    @lottery.register_contestant(@frederick, @mega_millions)
    @lottery.register_contestant(@winston, @cash_5)
    @lottery.register_contestant(@winston, @mega_millions)
    expected = {"Pick 4" => [@alexander],
                "Mega Millions" => [@alexander, @frederick, @winston],
                "Cash 5" => [@winston]}
    assert_equal expected, @lottery.registered_contestants
  end

  def test_it_can_get_eligible_contestants
    @alexander.add_game_interest('Pick 4')
    @alexander.add_game_interest('Mega Millions')
    @frederick.add_game_interest('Mega Millions')
    @winston.add_game_interest('Cash 5')
    @winston.add_game_interest('Mega Millions')
    @benjamin.add_game_interest('Mega Millions')
    @lottery.register_contestant(@alexander, @pick_4)
    @lottery.register_contestant(@alexander, @mega_millions)
    @lottery.register_contestant(@frederick, @mega_millions)
    @lottery.register_contestant(@winston, @cash_5)
    @lottery.register_contestant(@winston, @mega_millions)

    assert_equal [@alexander], @lottery.eligible_contestants(@pick_4)
  end

end

# - Use TDD to update your `Lottery` class so that it responds to the following interaction pattern.
# - To save time, we will keep the same setup from iteration 2 with all of the same objects and interests, plus we will add one additional contestant with interests at a specific point in the interaction.
# - We will only register contestants that `#can_register?`
# - `#eligible_contestants` is a list of all the contestants who have been registered to play a given game and that have more spending_money than the cost.
# - current_contestants are lists of contestant names who have been charged, organized by game.
#
# ```ruby
# pry(main)> lottery.register_contestant(alexander, pick_4)
#
# pry(main)> lottery.registered_contestants
# #=> {"Pick 4"=> [#<Contestant:0x007f8a3251c390...>]}
#
# pry(main)> lottery.register_contestant(alexander, mega_millions)
#
# pry(main)> lottery.registered_contestants
# #=> {"Pick 4"=> [#<Contestant:0x007f8a3251c390...>], "Mega Millions"=> [#<Contestant:0x007f8a3251c390...>]}
#
# pry(main)> lottery.register_contestant(frederick, mega_millions)
# pry(main)> lottery.register_contestant(winston, cash_5)
# pry(main)> lottery.register_contestant(winston, mega_millions)
#
# pry(main)> lottery.registered_contestants
# #=> {"Pick 4"=> [#<Contestant:0x007f8a3251c390>], "Mega Millions" => [#<Contestant:0x007f8a3251c390...>, #<Contestant:0x007f8a325a6c98...>, #<Contestant:0x007f8a33092c10...>], "Cash 5" => [#<Contestant:0x007f8a33092c10...>]}
#
# pry(main)> grace = Contestant.new({
#                      first_name: 'Grace',
#                      last_name: 'Hopper',
#                      age: 20,
#                      state_of_residence: 'CO',
#                      spending_money: 20})
# #=> #<Contestant:0x007ffe99998190...>
#
# pry(main)> grace.add_game_interest('Mega Millions')
# pry(main)> grace.add_game_interest('Cash 5')
# pry(main)> grace.add_game_interest('Pick 4')
# pry(main)> lottery.register_contestant(grace, mega_millions)
# pry(main)> lottery.register_contestant(grace, cash_5)
# pry(main)> lottery.register_contestant(grace, pick_4)
#
# lottery.registered_contestants
# #=> {"Pick 4"=> [#<Contestant:0x007f8a3251c390>, #<Contestant:0x007ffe99998190...>], "Mega Millions" => [#<Contestant:0x007f8a3251c390...>, #<Contestant:0x007f8a325a6c98...>, #<Contestant:0x007f8a33092c10...>, #<Contestant:0x007ffe99998190...>], "Cash 5" => [#<Contestant:0x007f8a33092c10...>, #<Contestant:0x007ffe99998190...>]}
#
# pry(main)> lottery.eligible_contestants(pick_4)
# #=> [#<Contestant:0x007ffe95fab0b8...>,
#  #<Contestant:0x007ffe99998190...>]
#
# pry(main)> lottery.eligible_contestants(cash_5)
# #=> [#<Contestant:0x007ffe96db1180...>, #<Contestant:0x007ffe99998190...>]
#
# pry(main)> lottery.eligible_contestants(mega_millions)
# #=> [#<Contestant:0x007ffe95fab0b8...>, #<Contestant:0x007ffe99848470...>, #<Contestant:0x007ffe99998190...>]
#
# pry(main)> lottery.charge_contestants(cash_5)
#
# pry(main)> lottery.current_contestants
# #=> {#<Game:0x007f8a32295360...> => ["Winston Churchill", "Grace Hopper"]}
#
# pry(main)> grace.spending_money
# #=> 19
#
# pry(main)> winston.spending_money
# #=> 4
#
# pry(main)> lottery.charge_contestants(mega_millions)
#
# pry(main)> lottery.current_contestants
# #=> {#<Game:0x007f8a32295360...> => ["Winston Churchill", "Grace Hopper"],
#  #<Game:0x007f8a322ad5a0...> => ["Alexander Aigades", "Frederick Douglas", "Grace Hopper"]}
#
# pry(main)> grace.spending_money
# #=> 14
#
# pry(main)> winston.spending_money
# #=> 4
#
# pry(main)> alexander.spending_money
# #=> 5
#
# pry(main)> frederick.spending_money
# #=> 15
#
# pry(main)> lottery.charge_contestants(pick_4)
#
# pry(main)> lottery.current_contestants
# #=> {#<Game:0x007f8a32295360...> => ["Winston Churchill", "Grace Hopper"],
# #<Game:0x007f8a322ad5a0...> => ["Alexander Aigades", "Frederick Douglas", "Grace Hopper"],
# #<Game:0x007f8a317b5e40...> => ["Alexander Aigades", "Grace Hopper"]}
#
