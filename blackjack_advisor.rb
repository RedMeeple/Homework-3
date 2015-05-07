# Optimal Moves Data
hard = {8 => {},9 => {}, 10 => {}, 11 => "Double if possible, otherwise Hit",
  12 => {}, 13 => {}, 14 => {}, 15 => {}, 16 => {},
  }

  (5..7).each {|n| hard[n] = Hash.new("Hit")}
  ((2..4).to_a + (7..11).to_a).each {|n| hard[8][n] = "Hit"}
  (5..6).each {|n| hard[8][n] = "Double if possible, otherwise Hit"}
  (2..6).each {|n| hard[9][n] = "Double if possible, otherwise Hit"}
  (7..11).each {|n| hard[9][n] = "Hit"}
  (10..11).each {|n| hard[10][n] = "Double if possible, otherwise Hit"}
  (2..9).each {|n| hard[10][n] = "Hit"}
  ((2..3).to_a + (7..11).to_a).each {|n| hard[12][n] = "Hit"}
  (4..6).each {|n| hard[12][n] = "Stand"}
  (13..16).each{|n| (2..6).each {|a| hard[n][a] = "Stand"}}
  (13..16).each{|n| (7..11).each {|a| hard[n][a] = "Hit"}} ##woo!!
  (17..21).each {|n| hard[n] = Hash.new("Stand")}

soft = {13 => {}, 14 => {}, 15 => {}, 16 => {}, 17 => {}, 18 => {},
  19 => {6 => "Double if possible, otherwise Stand"}, 20 => {}, 21 => {}
}

  (13..16).each{|n| ((2..3).to_a + (7..11).to_a).each {|a| soft[n][a] = "Hit"}}
  (13..16).each{|n| (4..6).each {|a| soft[n][a] = "Double if possible, otherwise Hit"}}
  (2..6).each {|n| soft[17][n] = "Hit"}
  (7..11).each {|n| soft[17][n] = "Double if possible, otherwise Hit"}
  [2,7,8,11].each {|n| soft[18][n] = "Stand"}
  (3..6).each {|n| soft[18][n] = "Double if possible, otherwise Hit"}
  [9,10].each {|n| soft[18][n] = "Hit"}
  ((2..5).to_a + (7..11).to_a).each {|n| soft[19][n] = "Stand"}
  [20, 21].each {|n| soft[n] = Hash.new("Stand")}


pair = {2 => {}, 3 => {}, 4 => {}, 5 => {}, 6 => {}, 7 => {10 => "Stand"},
  8 => "Split", 9 => {},
}
  [2,6].each {|n| (2..7).each {|a| pair[n][a] = "Split"}}
  [2,6].each {|n| (8..11).each {|a| pair[n][a] = "Hit"}}
  (2..8).each {|n| pair[3][n] = "Split"}
  (9..11).each {|n| pair[3][n] = "Hit"}
  (4..6).each {|n| pair[4][n] = "Split"}
  ([2,3] + (7..11).to_a).each {|n| pair[4][n] = "Hit"}
  (2..9).each {|n| pair[5][n] = "Double if possible, otherwise Hit"}
  [10,11].each {|n| pair[5][n] = "Hit"}
  (2..8).each {|n| pair[7][n] = "Split"}
  [9,11].each {|n| pair[7][n] = "Hit"}
  ((2..6).to_a + [8,9]).each {|n| pair[9][n] = "Split"}
  [7,10,11].each {|n| pair[9][n] = "Stand"}

# Changes some data if 2 or 4+ decks are being used.
puts "How many decks are you playing with? 1, 2, or 4+"
decks = gets.chomp
if decks != "1"
  [5,6].each {|n| hard[8][n] = "Hit" }
  soft[13][4] = "Hit"
  soft[14][4] = "Hit"
  soft[17][2] = "Hit"
  soft[18][11] = "Hit"
  soft[19][6] = "Stand"
  pair[3][8] = "Hit"
  pair[4][4] = "Hit"
  pair[7][10] = "Hit"
end
if decks == "4+"
  hard[9][2] = "Hit"
  pair[6][7] = "Hit"
  pair[7][8] = "Hit"

end

# Turns each card into a number
def get_card
  tens = ["10", "j", "q", "k", "jack", "queen", "king"]
  card = gets.chomp.downcase
  if tens.include? card
    return 10
  elsif card == "a"
    return 11
  else
    return card.to_i
  end
end


# Main Program

puts "Please enter your first card:"
first_card = get_card
puts "Please enter your second card:"
second_card = get_card
puts "Please enter the dealer's card:"
dealers_card = get_card
total = first_card + second_card

if first_card == second_card
  optimal_move = pair[first_card][dealers_card]
elsif first_card != 11 && second_card != 11
  optimal_move = hard[total][dealers_card]
else
  optimal_move = soft[total][dealers_card]
end
puts "Your optimal move is to #{optimal_move}"

# The program will only continue if Hit was recommended and the user did not
# bust so wishes to continue.
while optimal_move == "Hit" || optimal_move == "Double if possible, otherwise Hit"
  puts "Would you like to continue?"
  answer = gets.chomp
  break if answer.capitalize.start_with?("N")
  puts "What card did you get?"
  next_card = get_card
  total = total + next_card
  if first_card != 11 && second_card != 11
    if next_card != 11
      optimal_move = hard[total][dealers_card]
    elsif total > 21
      total -= 10
      optimal_move = hard[total][dealers_card]
    else
      optimal_move = soft[total][dealers_card]
    end
  else
    if total > 21
      total -= 10
      next_card == 11 ? optimal_move = soft[total][dealers_card] : optimal_move = hard[total][dealers_card]
    else
      optimal_move = soft[total][dealers_card]
    end
  end
  puts "Your optimal move is to #{optimal_move}"
end
