$months = [	
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
    # Create and empty array
    students = []

    # Get the first name, using gsub instead of chomp
    name = gets.gsub(/\n/, "")
    # While the name is not empty, repeat this code
    while !name.empty? do
        puts "What's their IQ?"
        iq = gets.chomp
        iq = "Unknown" if iq.empty?
        
        puts "And which month's cohort are they in?"
        cohort = gets.chomp.downcase.to_sym
        cohort = :november if cohort.empty?
        
        while !$months.include? cohort do
            puts "Please enter a valid month"
            cohort = gets.chomp.downcase.to_sym
        end
        
        # Add the student hash to the array
        students << {name: name, iq: iq, cohort: cohort}
        if students.count == 1
            puts "Now we have #{students.count} student."
        else
            puts "Now we have #{students.count} students."
        end
        # Get another name from the user
        name = gets.chomp
    end
    # Return the array of students
    students
end

def print_header
    puts "The students of Villains Academy".center(100)
    puts "-------------".center(100)
    puts
end

def print_students(students)
    cohorts = []
    # Create an ordered array of possible cohorts
    students.map do |student| 
        cohorts[$months.index(student[:cohort])] = student[:cohort]
    end
    
    cohorts.compact!

    cohorts.each do |cohort|
        # Position in list of each student
        num = 1
          
        puts "Students in the #{cohort.to_s.capitalize} cohort".center(100)
        puts "-------------".center(100)
        students.each_with_index do |student, index|
            if student[:cohort] == cohort
                puts "#{num}. #{student[:name]}, IQ is #{student[:iq]}".center(100)
                num += 1
            end
        end
        puts
    end    
end

def print_using_while(students)
    student_num = 0
    
    while student_num < students.length do
        print "#{student_num + 1}. #{students[student_num][:name]} "
        puts "(#{students[student_num][:cohort]} cohort)"
        
        student_num += 1
    end
end

def print_specific_letter(students)
    print "Enter a letter to print names starting with that letter: "
    letter = gets.chomp
    
    puts "Here are the students with names beginning with #{letter}"
    
    students.each do |student|
        if letter.capitalize == student[:name][0].capitalize
            puts "#{student[:name]} (#{student[:cohort]} cohort)"
        end
    end
end

def print_footer(names)
    puts "-------------".center(100)
    if names.length == 1
        puts "Overall, we have #{names.count} great student".center(100)
        puts
    else
        puts "Overall, we have #{names.count} great students".center(100)
        puts
    end
end

students = input_students
# Nothing happens untill we call the methods
print_header
print_students(students)
print_footer(students)