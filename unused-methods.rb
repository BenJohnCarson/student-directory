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