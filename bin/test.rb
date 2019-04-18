# require 'uri'
# require 'net/http'
# require 'openssl'
# require 'pry'
# require 'rspec'
# require 'nokogiri'
# require 'json'
# require 'tty-command'
# require 'tty-prompt'

require_relative '../config/environment.rb'

$difficulty_num = 5
$prompt = TTY::Prompt.new
# url = URI("https://api.themoviedb.org/3/movie/%7Bmovie_id%7D?language=en-US&api_key=#{tmdb_key}")

def clear_logs
    system "clear"
end

def motivational_movie_quotes
    ["May the odds be ever in your favor...", "May the force be with you", "May the hair on your toes never fall out!", "...and whichsoever way thou goest, may fortune follow"]
end

def winner
puts " "  
puts "          You found Bacon!"
puts    "          __      _.._       ".red
puts    "       .-'__`-._.'.--.'.__., ".red
puts    "      /--'  '-._.'    '-._./ ".red
puts    "     /__.--._.--._.'``-.__/  ".red
puts   "     '._.-'-._.-._.-''-..'   ".red
puts " "
puts "         Congratulations!"
sleep(20)
again = $prompt.yes?("Would you like to play again, champ?")
if again == true
    first_prompt
else
exit!
end
end

def loser
    try = $prompt.yes?("You didn't find any bacon, care to try again?")
    if try == true
        first_prompt
    else
        puts "Things could be worse. You remember that, and you go on with your life. - Kevin Bacon"
        sleep(10)
        exit!
    end
end

def first_prompt
    # prompt = TTY::Prompt.new
    clear_logs
    puts "Welcome to 6 degrees of Kevin Bacon\n\n"
    # $key = $prompt.secret("Please enter your key from The Movie DB to continue")
    options = {"Play":1, "How to Play":2, "Difficulty Settings":3, "Exit Game":4}
    return_value = $prompt.select("Begin by selecting from the following options:",options)
    first_menu(return_value)
end

def first_menu(first_response)
    # prompt = TTY::Prompt.new
    clear_logs
    case first_response
    when 1
        
        return_value = $prompt.ask("Please type an actor/actress name")
        if return_value == "Kevin Bacon" 
            cheater
        else
            six_degrees_online(return_value)
        end

    when 2
       puts "Six degrees of Kevin Bacon is played by browsing a database of movies and actors and end up with Kevin Bacon."
       sleep(6)
       puts "You will start by typing out an actor/actress, which will then display a list of films that actor has appeared in."
       sleep(6)
       puts "If you manage to reach the magnificance that is Kevin Bacon in 6 steps, you may receive a tasty treat!"
       sleep(6)
       puts motivational_movie_quotes.sample
       sleep(10)
       clear_logs
       first_prompt


    when 3
        nums = {"easy" => 6, "medium" => 5, "hard" => 4}
        $difficulty_num = $prompt.select("Please choose a difficulty setting", nums)
        puts "Difficulty selected. You have #{$difficulty_num + 1} chances"
        sleep (10)
        first_prompt

    when 4
        clear_logs
        puts "K bye"
        sleep(120)
        return "You're still here?"
    end
end

def get_actor_id(input)
    puts input
    actor_int = Actor.find_by(name: input)
    return actor_int
end

def get_actor_movies(id) 
    puts id
    mv = ActorMovie.all.select do |actormovie|
        actormovie.actor_id == id
    end
    mv.map do |x|
        x.movie_id
    end
end


def get_movie_titles(array)
    x = []
    Movie.all.select do |film|
        array.each do |num|
            if film.id == num
                x.push(film.title)
            end
        end
    end
    x
end

def get_movie_id(input)
    puts input
    movie_int = Movie.find_by(title: input)
    return movie_int
end

def get_movie_actors(input)
    act = ActorMovie.all.select do |actormovie|
        actormovie.movie_id == input.id
    end
    act.map do |y|
        y.actor_id
    end
end

def get_actor_names(array)
    x = []
    Actor.all.select do |film|
        array.each do |num|
            if film.id == num
                x.push(film.name)
            end
        end
    end
    x
end



def six_degrees(input)
    actor = "#{input}"

    i = 0

    while i <= $difficulty_num do

        t = get_actor_id(actor)

        t.id

        m = get_actor_movies(t.id)

        movie_selection = get_movie_titles(m)
        # binding.pry

        selected_movie = $prompt.select("#{input} was in the following movies, choose from the following options to find Bacon!",movie_selection)

        "You have chosen: #{selected_movie}!"

        smid = get_movie_id(selected_movie)

        persons = get_movie_actors(smid)

        select_person = get_actor_names(persons)

        final_answer = $prompt.select("#{selected_movie} cast the following actors, choose from the following options to find Bacon!",select_person)

        i += 1

        break if final_answer == "Kevin Bacon"
    end

    if final_answer == "Kevin Bacon"
        winner
    else
        loser
    end
end






# binding.pry





def get_movie_details(movie_id)

    tmdb_key = "116cc896d67e7df86c31bdfb6dfda8e6"

    url = URI("https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{tmdb_key}&language=en-US")


    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    response = http.request(request)
    puts response.read_body

end


# def get_actor_details(input)
    
#     tmdb_key = "116cc896d67e7df86c31bdfb6dfda8e6"

#     url = URI("https://api.themoviedb.org/3/person/#{input}?api_key=116cc896d67e7df86c31bdfb6dfda8e6&language=en-US")


 
#     http = Net::HTTP.new(url.host, url.port)
#     http.use_ssl = true
#     http.verify_mode = OpenSSL::SSL::VERIFY_NONE

#     request = Net::HTTP::Get.new(url)
#     request.body = "{}"

#     response = http.request(request)
#     puts response.read_body

# end

#https://api.themoviedb.org/3/movie/#{movie_id}/credits?api_key=116cc896d67e7df86c31bdfb6dfda8e6



def get_movie_details_online(movie_title)

    tmdb_key = "116cc896d67e7df86c31bdfb6dfda8e6"
    
    url = URI("https://api.themoviedb.org/3/search/movie?api_key=116cc896d67e7df86c31bdfb6dfda8e6&language=en-US&query=#{movie_title}&page=1&include_adult=false")
    

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    response = http.request(request)
    yes = response.read_body

    hash = JSON.parse(yes)
    hash["results"][0]["id"]
    
end

def get_actor_credits_online(person_id)
    
    person_credit_array = []

    tmdb_key = "116cc896d67e7df86c31bdfb6dfda8e6"

    url = URI("https://api.themoviedb.org/3/person/#{person_id}/movie_credits?api_key=#{tmdb_key}&language=en-US")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    response = http.request(request)
    yes = response.read_body
    
    hash = JSON.parse(yes)
    # binding.pry
    i = 0
    a = hash["cast"].size
    while i < a do
        person_credit_array << hash["cast"][i]["title"]
        i += 1
    end
    person_credit_array
end


def online_actor_id(string)

    tmdb_key = "116cc896d67e7df86c31bdfb6dfda8e6"
    url = URI("https://api.themoviedb.org/3/search/person?api_key=#{tmdb_key}&query=#{string}")
    # binding.pry

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    response = http.request(request)
    yes = response.read_body

    hash = JSON.parse(yes)
    # binding.pry
    # 0
    if hash == {"page"=>1, "total_results"=>0, "total_pages"=>1, "results"=>[]}
        puts "Who?"
        sleep(2)
        first_prompt
    end 
    hash["results"][0]["id"]



end

def get_actors_by_online_movie_id(id)

    actors_array = []

    url = URI("https://api.themoviedb.org/3/movie/#{id}/credits?api_key=116cc896d67e7df86c31bdfb6dfda8e6")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request.body = "{}"
    
    response = http.request(request)
    yes = response.read_body
        
    hash = JSON.parse(yes)
        
    i = 0
    a = hash["cast"].size



    while i < a 
        actors_array << hash["cast"][i]["name"]
        i += 1
    end
   
    actors_array
end

def cheater
    puts "You can't start with Kevin Bacon"
    sleep (3)
    puts "Try again"
    sleep (3)
    first_menu(1)
end

def six_degrees_online(input)
    actor = "#{input}"

    


    i = 0

    while i <= $difficulty_num do
        

        # t = get_actor_id(actor)
        t = online_actor_id(actor)
        # if t == nil
        #     puts "Who is that?"
        #     sleep(2)
        #     first_prompt
        # end
         # t.id
        m = get_actor_credits_online(t)
        # m = get_actor_movies(t.id)
        # movie_selection = get_actor_credits_online(m)
        # # movie_selection = get_movie_titles(m)
        # binding.pry
        selected_movie = $prompt.select("#{actor} was in the following movies, choose from the following options to find Bacon!",m)
        # selected_movie = $prompt.select("#{input} was in the following movies, choose from the following options to find Bacon!",movie_selection)
        "You have chosen: #{selected_movie}!"
        # "You have chosen: #{selected_movie}!"
        smid = get_movie_details_online(selected_movie)
        
        # smid = get_movie_id(selected_movie)
        final_stage = get_actors_by_online_movie_id(smid)

        # persons = get_movie_actors(smid)
        actor = $prompt.select("#{selected_movie} cast the following actors, choose from the following options to find Bacon!",final_stage)
        # select_person = get_actor_names(persons)
        
        # final_answer = $prompt.select("#{selected_movie} cast the following actors, choose from the following options to find Bacon!",select_person)

        

        break if actor == "Kevin Bacon"
        break if i == $difficulty_num
        i += 1
    end

    if actor == "Kevin Bacon"
        winner
    else
        loser
    end
    
end

# binding.pry

# 0