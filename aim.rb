require 'csv'
require 'progress_bar'

def get_chances_of_getting_in(spots, people, player_status)
  """
  Calculates the chances of a player getting in to a program.

  Args:
    spots: The number of spots available.
    people: The number of people who want the spot.
    player_status: The player's status, as a percentage.

  Returns:
    The player's chances of getting in, as a percentage.
  """

  probability_of_getting_in = spots / people
  player_status_as_a_fraction = player_status / 100.0
  player_chances_of_getting_in = probability_of_getting_in * player_status_as_a_fraction
  return player_chances_of_getting_in * 100
end

def list_files(directory)
  if directory == nil
    directory = 'kierunki_uam_html'
  end
  files = Dir.entries(directory)
  files.delete('.')
  files.delete('..')
  return files
end

# if output of shell command is empty, nil then do nothing
# else print output
def print_if_not_empty(output)
  if output != nil
    print output
  end
end

def check_level(file)
  level = `cat kierunki_uam_html/#{file} | htmlq "#main > div.jumbotron > div > div > div:nth-child(1) > strong" --text`
  if not level.include? "pierwszego stopnia"
    # puts "Error: #{file} is erroneously parsed."
    return false
  end
  return true
end

def check_first_test_math(file)
  test = `cat kierunki_uam_html/#{file} | htmlq ".table-bordered > tbody > tr:nth-child(1) > .border-bottom-darker:nth-child(2)" --text`
  # split on (część pisemna)
  test = test.split("(część pisemna)")[0]
  if test == "matematyka"
    return false
  end
  return true
end

def check_second_test_math(file)
  test = `cat kierunki_uam_html/#{file} | htmlq ".table-bordered > tbody > tr:nth-child(4) > .border-bottom-darker:nth-child(2)" --text`
  # split on (część pisemna)
  test = test.split("(część pisemna)")[0]
  if test == "matematyka"
    return false
  end
  return true
end

def check_if_test_wos(file)
  test = `cat kierunki_uam_html/#{file} | htmlq ".table-bordered > tbody > tr > .border-bottom-darker" | rg "wiedza o społeczeństwie"`
  test = test.chomp
  if test.include? "wiedza o społeczeństwie"
    return true
  else
    return false
  end
end

def check_if_test_historia(file)
  test = `cat kierunki_uam_html/#{file} | htmlq ".table-bordered > tbody > tr > .border-bottom-darker" | rg "historia"`
  test = test.chomp
  if test.include? "historia"
    return true
  else
    return false
  end
end

def check_if_test_jezyk_angielski(file)
  test = `cat kierunki_uam_html/#{file} | htmlq ".table-bordered > tbody > tr > .border-bottom-darker" | rg "język angielski"`
  test = test.chomp
  if test.include? "język angielski"
    return true
  else
    return false
  end
end

def check_if_test_jezyk_obcy(file)
  test = `cat kierunki_uam_html/#{file} | htmlq ".table-bordered > tbody > tr > .border-bottom-darker" | rg "język obcy"`
  test = test.chomp
  if test.include? "język obcy"
    return true
  else
    return false
  end
end

def check_if_test_jezyk_polski(file)
  test = `cat kierunki_uam_html/#{file} | htmlq ".table-bordered > tbody > tr > .border-bottom-darker" | rg "język polski"`
  test = test.chomp
  if test.include? "język polski"
    return true
  else
    return false
  end
end

def check_if_test_geografia(file)
  test = `cat kierunki_uam_html/#{file} | htmlq ".table-bordered > tbody > tr > .border-bottom-darker" | rg "wiedza o społeczeństwie"`
  test = test.chomp
  if test.include? "geografia"
    return true
  else
    return false
  end
end

def spots(file)
  liczba_miejsc = `cat kierunki_uam_html/#{file} | htmlq ".mb-0:nth-child(2) > tbody > tr:nth-child(7) > td:nth-child(2) > b" --text`
  payed = `cat kierunki_uam_html/#{file} | htmlq ".mb-0:nth-child(3) > tbody > tr:nth-child(2) > td:nth-child(2)" --text`
  return liczba_miejsc, payed
end  

def get_unique_array_rows(array, column)
  unique_rows = []
  seen_elements = []

  for row in array
    if !seen_elements.include?(row[column])
      unique_rows.push(row)
      seen_elements.push(row[column])
    end
  end

  return unique_rows
end

def check_if_free(file)
  payed = `cat kierunki_uam_html/#{file} | htmlq "#main > div.jumbotron > div > p:nth-child(6) > strong" --text | rg "Opłata za studia:"`
  if payed.include? "Opłata"
    return false
  else
    return true
  end
end

if __FILE__ == $PROGRAM_NAME
  base_from_matura = 45.0
  second_spot = 0.0
  directory = ARGV[0]
  files = list_files(directory)
  wyniki = []
  bar = ProgressBar.new(files.length)
  puts "Parsing files for points on spot..."
  for file in files
    bar.increment!
    if not check_if_free(file)
      next
    end
    if not check_level(file)
      next
    end
    if not check_first_test_math(file) and not check_second_test_math(file)
      next
    end
    liczba_miejsc, payed = spots(file)
    if liczba_miejsc == "" or payed == ""
      # puts "Error: #{file} is erroneously parsed."
      next
    else
      begin
        liczba_miejsc = Float(liczba_miejsc)
        payed = Float(payed)
        if payed + second_spot <= liczba_miejsc
          #
          next
        end
        # puts file
      rescue ArgumentError => e
        # puts "Error: #{file} is erroneously parsed."
        next
      end
    end
    bonus = 0
    if check_if_test_wos(file)
      bonus = 13
    end
    if check_if_test_geografia(file)
      bonus = 20
    end
    if not (check_if_test_historia(file) or check_if_test_geografia(file) or check_if_test_wos(file) or check_if_test_jezyk_angielski(file))
      next
    end
    if not ((check_if_test_jezyk_angielski(file) or check_if_test_jezyk_obcy(file)) or check_if_test_jezyk_polski(file))
      next
    end
    where = file.split(",")[0]
    url = file.split(",")[1]
    chance = get_chances_of_getting_in(Float(liczba_miejsc), Float(payed), base_from_matura + bonus)
    # append to array wyniki
    wyniki.append([where, chance, liczba_miejsc, payed, url])
  end
  wyniki.sort_by! { |a| a[1] }
  wyniki.reverse!
  puts "Sorting..."
  bar = ProgressBar.new(wyniki.length)
  puts "Getting unique rows..."
  wyniki = get_unique_array_rows(wyniki, -1)
  puts "Najlepsze kierunki:"
  for w in wyniki
    puts "#{w[0]} - szansa: #{w[1]}, liczba miejsc: #{w[2]}, liczba chętnych: #{w[3]}"
  end
  file.split(",")[0]
  CSV.open("wyniki.csv", "w") do |csv|
    csv << ["Kierunek", "Szansa", "Liczba miejsc", "Liczba chętnych"]
    for w in wyniki
      csv << w
    end
  end
  puts "Saved to wyniki.csv"
  puts "Done!"
end
  