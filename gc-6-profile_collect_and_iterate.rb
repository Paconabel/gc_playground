require 'csv'
require 'ostruct'
GC::Profiler.enable

class Parser
  MOVIES_FILE_PATH = 'fixtures/movies_500.csv'
  class << self

    def store_movies_with_map
      content = File.read(MOVIES_FILE_PATH)
      options = { headers: :first_row, liberal_parsing: { double_quote_outside_quote: true } }
      movies = CSV.parse(content, options).map do |row|
        translate(row)
      end
      store_collecion_of(movies)
    end

    def store_movies_with_each
      options = { headers: :first_row, liberal_parsing: { double_quote_outside_quote: true } }
      CSV.foreach(MOVIES_FILE_PATH, options) do |row|
        movie = translate(row)
        store(movie)
      end
    end

    def translate(row)
      OpenStruct.new(
        {
          title: row[0],
          genre: row[1],
          profitability: row[4],
          year: row[7]
        }
      )
    end

    def store_collecion_of(movies)
      movies.each { |movie| store(movie) }
    end

    def store(movie)
      movie
    end
  end
end


def display_count
  data = ObjectSpace.count_objects
  puts "Total: #{data[:TOTAL]} Free: #{data[:FREE]} Object: #{data[:T_OBJECT]}"
end

display_count
Parser.store_movies_with_map
display_count
GC.start

GC::Profiler.report