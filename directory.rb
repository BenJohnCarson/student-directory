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

    # Get the first name, using gsub instead of chomp
    name = STDIN.gets.gsub(/\n/, "")
    # While the name is not empty, repeat this code
    while !name.empty? do
        puts "What's their IQ?"
        iq = STDIN.gets.chomp
        iq = "Unknown" if iq.empty?
        
        puts "And which month's cohort are they in?"
        cohort = STDIN.gets.chomp.downcase.to_sym
        cohort = :november if cohort.empty?
        
        while !@months.include? cohort do
            puts "Please enter a valid month"
            cohort = STDIN.gets.chomp.downcase.to_sym
        end
        
        # Add the student hash to the array
        add_student(name, iq, cohort)
        if @students.count == 1
            puts "Now we have #{@students.count} student."
        else
            puts "Now we have #{@students.count} students."
        end
        # Get another name from the user
        name = STDIN.gets.chomp
    end
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
        cohorts = []
        # Create an ordered array of possible cohorts
        @students.map do |student| 
            cohorts[@months.index(student[:cohort])] = student[:cohort]
        end
        
        cohorts.compact!
    
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
    # open file for writing ("w")
    file = File.open("students.csv", "w")
    # iterate over the array of students
    @students.each do |student|
        student_data = [student[:name], student[:iq], student[:cohort]]
        csv_line = student_data.join(",")
        file.puts csv_line
    end
    file.close
end

def load_students(filename = "students.csv")
    file = File.open(filename, "r")
    file.readlines.each do |line|
        name, iq, cohort = line.chomp.split(",")
        #puts "#{name} + #{iq} + #{cohort}"
        add_student(name, iq, cohort)
        #puts @students
    end
    file.close
end

def try_load_students
    filename = ARGV.first # First argument from the command line
    return if filename.nil? # Get out of the method if it isn't given
    if File.exists?(filename) # If it exists
        load_students(filename)
        puts "Loaded #{@students.count} from #{filename}"
    else # If it doesn't exist
        puts "Sorry, #{filename} doesn't exist."
        exit # Quits the program
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
    puts "3. Save the students to students.csv"
    puts "4. Load the students from students.csv"
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
        when "3"
            save_students
        when "4"
            load_students
        when "9"
            exit # terminates the program
        else
            puts "Not a valid option, try again"
    end
end

try_load_students
interactive_menu
