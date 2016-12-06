require 'csv'

@center_value = 100
@students = []
@months = [	
        :january,
	    :febuary,
		:march,
		:april,
		:may,
		:june,
		:july,
		:august,
		:september,
		:october,
		:november,
		:december
]

def input_students
    puts "Please enter the names of the students"
    puts "To finish, just hit return twice"
    name = STDIN.gets.chomp.capitalize
    # While the name is not empty, repeat this code
    while !name.empty? do
        iq, cohort = get_iq_cohort
        add_student(name, iq, cohort)
        if @students.count == 1
            puts "Now we have #{@students.count} student."
        else
            puts "Now we have #{@students.count} students."
        end
        # Get another name from the user
        name = STDIN.gets.chomp.capitalize
    end
end

def get_iq_cohort
    iq_cohort = []
    puts "What's their IQ?"
    iq = STDIN.gets.chomp
    iq.empty? ? iq_cohort << "Unknown" : iq_cohort << iq

    puts "Which month's cohort are they in?"
    cohort = STDIN.gets.chomp.downcase.to_sym
    cohort.empty? ? iq_cohort << :november : iq_cohort << cohort
    # If a month is entered, check it's valid
    while !@months.include? iq_cohort[1] do
        puts "Please enter a valid month"
        iq_cohort[1] = STDIN.gets.chomp.downcase.to_sym
    end
    iq_cohort
end

def add_student(name, iq, cohort)
    cohort = cohort.to_sym
    @students << {name: name, iq: iq, cohort: cohort}
end

def print_header
    puts "The students of Villains Academy".center(@center_value)
    puts "-------------".center(@center_value)
    puts
end

def print_students_list
    if @students.count >= 1
        cohorts = ordered_cohorts
        
        cohorts.each do |cohort|
            # Position in list of each student
            num = 1
              
            puts "Students in the #{cohort.to_s.capitalize} cohort".center(@center_value)
            puts "-------------".center(@center_value)
            @students.each_with_index do |student, index|
                if student[:cohort] == cohort
                    puts "#{num}. #{student[:name]}, IQ is #{student[:iq]}".center(@center_value)
                    num += 1
                end
            end
            puts
        end
    else
        puts "We have no students :(".center(@center_value)
        puts
    end
end

def ordered_cohorts
    cohorts = []
    # Create an ordered array of possible cohorts
    @students.map do |student| 
        cohorts[@months.index(student[:cohort])] = student[:cohort]
    end
    cohorts.compact!
    cohorts
end

def print_footer
    if @students.count >= 1
        puts "-------------".center(@center_value)
        if @students.length == 1
            puts "Overall, we have #{@students.count} great student".center(@center_value)
            puts
        else
            puts "Overall, we have #{@students.count} great students".center(@center_value)
            puts
        end
    end
end

def save_students
    filename = get_filename
    # open file for writing ("w")
    CSV.open(filename, "w") do |csv|
        # iterate over the array of students
        @students.each do |student|
            csv << [student[:name], student[:iq], student[:cohort]]
        end
    end
end

def load_students(filename = "students.csv")
    @students = []
    CSV.foreach(filename) do |row|
        name, iq, cohort = row
        add_student(name, iq, cohort)
    end
end

def get_filename
    puts "Please enter a filename"
    puts "Press enter again to use default name"
    filename = STDIN.gets.chomp
    
    return "students.csv" if filename.empty?
    
    !filename.end_with?(".csv") ? (filename << ".csv") : (filename)
end

def try_load_students(filename = "students.csv")
    filename = ARGV.first if !ARGV.empty?  # First argument from the command line
    if File.exists?(filename) # If it exists
        load_students(filename)
        puts "Loaded #{@students.count} from #{filename}"
    else # If it doesn't exist
        puts "Sorry, #{filename} doesn't exist. No students were loaded."
    end
end

def interactive_menu
    loop do
        print_menu
        process(STDIN.gets.chomp)
    end
end

def print_menu
    puts "1. Input the students"
    puts "2. Show the students"
    puts "3. Save the students to a file"
    puts "4. Load the students from a file"
    puts "5. Clear current students"
    puts "9. Exit" # 9 because we will add more options
end

def show_students
    print_header
    print_students_list
    print_footer
end

def process(selection)
    case selection
        when "1"
            input_students
        when "2"
            show_students
            sleep 1
        when "3"
            save_students
            puts "Save successful!"
            sleep 1
        when "4"
            filename = get_filename
            load_students(filename)
            puts "Loading successful!"
            sleep 1
        when "5"
            @students = []
            puts "Students cleared successfully"
            sleep 1
        when "9"
            puts "Exiting program..."
            exit # terminates the program
        else
            puts "Not a valid option, try again"
    end
end

try_load_students
interactive_menu