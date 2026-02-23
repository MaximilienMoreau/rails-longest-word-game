require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    @letters = params[:letters].to_s.split # ex: "A B C" => ["A","B","C"]
    @word    = params[:word].to_s.strip.upcase

    if @word.empty?
      @message = "Tu n'as saisi aucun mot 😈"
      @score = 0
      return
    end

    if !in_grid?(@word, @letters)
      @message = "Impossible : #{@word} ne peut pas être formé avec #{@letters.join(" ")}."
      @score = 0
      return
    end

    if !english_word?(@word)
      @message = "Presque… mais #{@word} n'a pas l'air d'être un mot anglais valide."
      @score = 0
      return
    end

    @score = @word.length
    @message = "Bien joué ! #{@word} est valide. Score = #{@score} 🩸"
  end

  private

  # Vérifie les occurrences (tu ne peux pas utiliser une lettre 2 fois si elle n'apparaît qu'1 fois)
  def in_grid?(word, letters)
    word_counts = word.chars.tally
    grid_counts = letters.tally

    word_counts.all? { |char, count| grid_counts[char].to_i >= count }
  end

  # API utilisée dans les exos Le Wagon (retourne { "found": true/false, ... })
  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word.downcase}" # :contentReference[oaicite:0]{index=0}
    json = JSON.parse(URI.open(url).read)
    json["found"] == true
  rescue
    false
  end
end
